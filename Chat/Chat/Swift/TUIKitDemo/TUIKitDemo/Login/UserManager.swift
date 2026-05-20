//
//  UserManager.swift
//  TUIKitDemo
//
//  用户管理类 - 处理用户注册、登录、密码找回
//  通过 CloudBase 云函数实现用户数据云端存储
//

import Foundation

class UserManager {
    
    static let shared = UserManager()
    
    private let currentUserKey = "Chat_Current_User"
    
    private init() {}
    
    // MARK: - 用户数据结构
    struct User: Codable {
        let phone: String
        let username: String
        let createdAt: Date?
        var lastLoginAt: Date?
    }
    
    // MARK: - CloudBase HTTP API
    
    /// 调用云函数
    /// - Parameters:
    ///   - params: 请求参数（必须包含 action）
    ///   - completion: 完成回调 (success, message, data)
    private func callCloudFunction(params: [String: Any], completion: @escaping (Bool, String, [String: Any]?) -> Void) {
        guard let url = URL(string: "\(kCloudBaseBaseURL)/v1/functions/\(kCloudBaseFunctionName)") else {
            completion(false, "URL 格式错误", nil)
            return
        }
        
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 15)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(kCloudBasePublishableKey)", forHTTPHeaderField: "Authorization")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params)
        } catch {
            completion(false, "参数序列化失败", nil)
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(false, "网络错误: \(error.localizedDescription)", nil)
                return
            }
            
            guard let data = data else {
                completion(false, "服务器无响应", nil)
                return
            }
            
            // 尝试解析响应
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                let code = json["code"] as? Int ?? -1
                let message = json["message"] as? String ?? "未知错误"
                let responseData = json["data"] as? [String: Any]
                completion(code == 0, message, responseData)
            } else {
                completion(false, "响应数据格式错误", nil)
            }
        }.resume()
    }
    
    // MARK: - 注册
    
    /// 检查手机号是否已注册（异步）
    func isPhoneRegistered(_ phone: String, completion: @escaping (Bool) -> Void) {
        callCloudFunction(params: ["action": "checkPhone", "phone": phone]) { success, message, data in
            let exists = data?["exists"] as? Bool ?? false
            completion(exists)
        }
    }
    
    /// 检查用户名是否已存在（异步）
    func isUsernameRegistered(_ username: String, completion: @escaping (Bool) -> Void) {
        callCloudFunction(params: ["action": "checkUsername", "username": username]) { success, message, data in
            let exists = data?["exists"] as? Bool ?? false
            completion(exists)
        }
    }
    
    /// 注册新用户（完整版，含密码）- 异步回调版本
    /// - Parameters:
    ///   - phone: 手机号
    ///   - username: 用户名
    ///   - password: 密码
    ///   - completion: 完成回调 (success, message)
    func register(phone: String, username: String, password: String, completion: @escaping (Bool, String) -> Void) {
        let trimmedPhone = phone.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedUsername = username.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // 本地验证
        guard isValidPhone(trimmedPhone) else {
            completion(false, "请输入正确的手机号")
            return
        }
        guard trimmedUsername.count >= 3 else {
            completion(false, "用户名长度需至少3位")
            return
        }
        guard isValidPassword(trimmedPassword) else {
            completion(false, "密码长度需为6-20位")
            return
        }
        
        // 调用云函数注册
        callCloudFunction(params: [
            "action": "register",
            "phone": trimmedPhone,
            "username": trimmedUsername,
            "password": trimmedPassword
        ]) { success, message, data in
            completion(success, message)
        }
    }
    
    // MARK: - 登录
    
    /// 使用用户名和密码登录
    /// - Parameters:
    ///   - username: 用户名
    ///   - password: 密码
    ///   - completion: 完成回调 (success, message, userId)
    func login(username: String, password: String, completion: @escaping (Bool, String, String?) -> Void) {
        let trimmedUsername = username.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard trimmedUsername.count >= 3 else {
            completion(false, "请输入正确的用户名", nil)
            return
        }
        
        callCloudFunction(params: [
            "action": "loginByUsername",
            "username": trimmedUsername,
            "password": trimmedPassword
        ]) { [weak self] success, message, data in
            if success, let userId = data?["userId"] as? String {
                // 保存当前登录用户
                self?.saveCurrentUser(userId)
                completion(true, "登录成功", userId)
            } else {
                completion(false, message, nil)
            }
        }
    }
    
    /// 使用手机号和密码登录
    /// - Parameters:
    ///   - phone: 手机号
    ///   - password: 密码
    ///   - completion: 完成回调 (success, message, userId)
    func login(phone: String, password: String, completion: @escaping (Bool, String, String?) -> Void) {
        let trimmedPhone = phone.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard isValidPhone(trimmedPhone) else {
            completion(false, "请输入正确的手机号", nil)
            return
        }
        
        callCloudFunction(params: [
            "action": "loginByPhone",
            "phone": trimmedPhone,
            "password": trimmedPassword
        ]) { [weak self] success, message, data in
            if success, let userId = data?["userId"] as? String {
                self?.saveCurrentUser(userId)
                completion(true, "登录成功", userId)
            } else {
                completion(false, message, nil)
            }
        }
    }
    
    // MARK: - 密码找回
    
    /// 验证手机号是否存在（异步）
    func verifyPhoneExists(_ phone: String, completion: @escaping (Bool) -> Void) {
        isPhoneRegistered(phone, completion: completion)
    }
    
    /// 重置密码（用户名+手机号双重验证）
    /// - Parameters:
    ///   - username: 用户名
    ///   - phone: 手机号
    ///   - newPassword: 新密码
    ///   - completion: 完成回调 (success, message)
    func resetPassword(username: String, phone: String, newPassword: String, completion: @escaping (Bool, String) -> Void) {
        let trimmedUsername = username.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPhone = phone.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = newPassword.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard trimmedUsername.count >= 3 else {
            completion(false, "请输入正确的用户名")
            return
        }
        guard isValidPhone(trimmedPhone) else {
            completion(false, "请输入正确的手机号")
            return
        }
        guard isValidPassword(trimmedPassword) else {
            completion(false, "密码长度需为6-20位")
            return
        }
        
        callCloudFunction(params: [
            "action": "resetPassword",
            "username": trimmedUsername,
            "phone": trimmedPhone,
            "newPassword": trimmedPassword
        ]) { success, message, data in
            completion(success, message)
        }
    }
    
    // MARK: - 当前用户
    
    /// 保存当前登录用户
    private func saveCurrentUser(_ userId: String) {
        UserDefaults.standard.set(userId, forKey: currentUserKey)
    }
    
    /// 获取当前登录用户名
    func getCurrentUser() -> String? {
        return UserDefaults.standard.string(forKey: currentUserKey)
    }
    
    /// 退出登录
    func logout() {
        UserDefaults.standard.removeObject(forKey: currentUserKey)
    }
    
    // MARK: - 验证方法
    
    /// 验证手机号格式（中国大陆手机号）
    func isValidPhone(_ phone: String) -> Bool {
        let phoneRegex = "^1[3-9]\\d{9}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return predicate.evaluate(with: phone)
    }
    
    /// 验证密码格式
    func isValidPassword(_ password: String) -> Bool {
        return password.count >= 6 && password.count <= 20
    }
}

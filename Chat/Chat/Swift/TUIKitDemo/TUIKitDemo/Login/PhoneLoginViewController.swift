//
//  PhoneLoginViewController.swift
//  TUIKitDemo
//
//  手机号密码登录页面
//

import UIKit
import TIMAppKit
import TIMCommon
import TUICore

class PhoneLoginViewController: UIViewController {
    
    // MARK: - UI 组件
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = TUISwift.tuiDemoDynamicImage("public_login_logo_img", defaultImage: UIImage.safeImage("public_login_logo"))
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "手机号登录"
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.textColor = TUISwift.timCommonDynamicColor("form_title_color", defaultColor: "#000000")
        label.textAlignment = .center
        return label
    }()
    
    private let phoneTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "请输入手机号"
        textField.borderStyle = .none
        textField.backgroundColor = TUISwift.timCommonDynamicColor("form_bg_color", defaultColor: "#F3F4F5")
        textField.layer.cornerRadius = 10
        textField.keyboardType = .phonePad
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftViewMode = .always
        textField.font = UIFont.systemFont(ofSize: 16)
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "请输入密码"
        textField.borderStyle = .none
        textField.backgroundColor = TUISwift.timCommonDynamicColor("form_bg_color", defaultColor: "#F3F4F5")
        textField.layer.cornerRadius = 10
        textField.isSecureTextEntry = true
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftViewMode = .always
        textField.font = UIFont.systemFont(ofSize: 16)
        return textField
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("登录", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = TUISwift.timCommonDynamicColor("primary_theme_color", defaultColor: "#147AFF")
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(loginButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("返回", for: .normal)
        button.setTitleColor(TUISwift.timCommonDynamicColor("primary_theme_color", defaultColor: "#147AFF"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(backToLogin), for: .touchUpInside)
        return button
    }()
    
    private lazy var switchToIDLoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("用户ID登录", for: .normal)
        button.setTitleColor(UIColor.gray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.addTarget(self, action: #selector(switchToIDLogin), for: .touchUpInside)
        return button
    }()
    
    // MARK: - 生命周期
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK: - UI 设置
    
    private func setupUI() {
        view.backgroundColor = TUISwift.timCommonDynamicColor("controller_bg_color", defaultColor: "#FFFFFF")
        
        view.addSubview(logoImageView)
        view.addSubview(titleLabel)
        view.addSubview(phoneTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(backButton)
        view.addSubview(switchToIDLoginButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        phoneTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        switchToIDLoginButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Logo
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            logoImageView.widthAnchor.constraint(equalToConstant: 120),
            logoImageView.heightAnchor.constraint(equalToConstant: 80),
            
            // 标题
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 30),
            
            // 手机号输入框
            phoneTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            phoneTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            phoneTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
            phoneTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // 密码输入框
            passwordTextField.leadingAnchor.constraint(equalTo: phoneTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: phoneTextField.trailingAnchor),
            passwordTextField.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 16),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // 登录按钮
            loginButton.leadingAnchor.constraint(equalTo: phoneTextField.leadingAnchor),
            loginButton.trailingAnchor.constraint(equalTo: phoneTextField.trailingAnchor),
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            
            // 返回按钮
            backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20),
            
            // 切换登录方式按钮
            switchToIDLoginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            switchToIDLoginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
        ])
    }
    
    private func setupKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - 按钮事件
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func backToLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func switchToIDLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func loginButtonClicked() {
        dismissKeyboard()
        
        guard let phone = phoneTextField.text, !phone.isEmpty else {
            showAlert(title: "提示", message: "请输入手机号")
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            showAlert(title: "提示", message: "请输入密码")
            return
        }
        
        // 调用用户管理器登录（异步）
        UserManager.shared.login(phone: phone, password: password) { [weak self] success, message, userId in
            DispatchQueue.main.async {
                if success, let userId = userId {
                    let userSig = GenerateTestUserSig.genTestUserSig(identifier: userId)
                    self?.performIMLogin(userId: userId, userSig: userSig)
                } else {
                    self?.showAlert(title: "登录失败", message: message)
                }
            }
        }
    }
    
    // MARK: - IM 登录
    
    private func performIMLogin(userId: String, userSig: String) {
        TCLoginModel.sharedInstance.isDirectlyLoginSDK = true
        TCLoginModel.sharedInstance.saveLoginedInfo(userID: userId, userSig: userSig)
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
        delegate?.loginSDK(userId, userSig: userSig, succ: { [weak self] in
            TUITool.hideToastActivity()
            self?.showAlert(title: "登录成功", message: "欢迎回来！")
        }, fail: { [weak self] code, _ in
            TUITool.hideToastActivity()
            self?.showAlert(title: "登录失败", message: "IM登录失败，请稍后重试")
        })
    }
    
    // MARK: - 提示框
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true, completion: nil)
    }
}

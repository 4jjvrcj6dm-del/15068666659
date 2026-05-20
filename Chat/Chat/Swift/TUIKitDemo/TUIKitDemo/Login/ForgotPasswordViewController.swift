//
//  ForgotPasswordViewController.swift
//  TUIKitDemo
//
//  密码找回页面 - 通过用户名和手机号验证
//

import UIKit
import TIMAppKit
import TIMCommon
import TUICore

class ForgotPasswordViewController: UIViewController {
    
    // MARK: - UI 组件
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = TUISwift.tuiDemoDynamicImage("public_login_logo_img", defaultImage: UIImage.safeImage("public_login_logo"))
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "找回密码"
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.textColor = TUISwift.timCommonDynamicColor("form_title_color", defaultColor: "#000000")
        label.textAlignment = .center
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "请输入用户名和注册时填写的手机号"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.gray
        label.textAlignment = .center
        return label
    }()
    
    private let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "请输入用户名"
        textField.borderStyle = .none
        textField.backgroundColor = TUISwift.timCommonDynamicColor("form_bg_color", defaultColor: "#F3F4F5")
        textField.layer.cornerRadius = 10
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftViewMode = .always
        textField.font = UIFont.systemFont(ofSize: 16)
        return textField
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
    
    private let newPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "请输入新密码 (6-20位)"
        textField.borderStyle = .none
        textField.backgroundColor = TUISwift.timCommonDynamicColor("form_bg_color", defaultColor: "#F3F4F5")
        textField.layer.cornerRadius = 10
        textField.isSecureTextEntry = true
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftViewMode = .always
        textField.font = UIFont.systemFont(ofSize: 16)
        return textField
    }()
    
    private let confirmPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "请确认新密码"
        textField.borderStyle = .none
        textField.backgroundColor = TUISwift.timCommonDynamicColor("form_bg_color", defaultColor: "#F3F4F5")
        textField.layer.cornerRadius = 10
        textField.isSecureTextEntry = true
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftViewMode = .always
        textField.font = UIFont.systemFont(ofSize: 16)
        return textField
    }()
    
    private lazy var resetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("重置密码", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = TUISwift.timCommonDynamicColor("primary_theme_color", defaultColor: "#147AFF")
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(resetButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("返回登录", for: .normal)
        button.setTitleColor(TUISwift.timCommonDynamicColor("primary_theme_color", defaultColor: "#147AFF"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(backToLogin), for: .touchUpInside)
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
        view.addSubview(subtitleLabel)
        view.addSubview(usernameTextField)
        view.addSubview(phoneTextField)
        view.addSubview(newPasswordTextField)
        view.addSubview(confirmPasswordTextField)
        view.addSubview(resetButton)
        view.addSubview(backButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        phoneTextField.translatesAutoresizingMaskIntoConstraints = false
        newPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        confirmPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Logo
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            logoImageView.widthAnchor.constraint(equalToConstant: 120),
            logoImageView.heightAnchor.constraint(equalToConstant: 80),
            
            // 标题
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 30),
            
            // 副标题
            subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            
            // 用户名输入框
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            usernameTextField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 30),
            usernameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // 手机号输入框
            phoneTextField.leadingAnchor.constraint(equalTo: usernameTextField.leadingAnchor),
            phoneTextField.trailingAnchor.constraint(equalTo: usernameTextField.trailingAnchor),
            phoneTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 16),
            phoneTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // 新密码输入框
            newPasswordTextField.leadingAnchor.constraint(equalTo: usernameTextField.leadingAnchor),
            newPasswordTextField.trailingAnchor.constraint(equalTo: usernameTextField.trailingAnchor),
            newPasswordTextField.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 16),
            newPasswordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // 确认密码输入框
            confirmPasswordTextField.leadingAnchor.constraint(equalTo: usernameTextField.leadingAnchor),
            confirmPasswordTextField.trailingAnchor.constraint(equalTo: usernameTextField.trailingAnchor),
            confirmPasswordTextField.topAnchor.constraint(equalTo: newPasswordTextField.bottomAnchor, constant: 16),
            confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // 重置按钮
            resetButton.leadingAnchor.constraint(equalTo: usernameTextField.leadingAnchor),
            resetButton.trailingAnchor.constraint(equalTo: usernameTextField.trailingAnchor),
            resetButton.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 30),
            resetButton.heightAnchor.constraint(equalToConstant: 50),
            
            // 返回按钮
            backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backButton.topAnchor.constraint(equalTo: resetButton.bottomAnchor, constant: 20),
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
    
    @objc private func resetButtonClicked() {
        dismissKeyboard()
        
        guard let username = usernameTextField.text, !username.isEmpty else {
            showAlert(title: "提示", message: "请输入用户名")
            return
        }
        
        guard let phone = phoneTextField.text, !phone.isEmpty else {
            showAlert(title: "提示", message: "请输入手机号")
            return
        }
        
        guard let newPassword = newPasswordTextField.text, !newPassword.isEmpty else {
            showAlert(title: "提示", message: "请输入新密码")
            return
        }
        
        guard let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty else {
            showAlert(title: "提示", message: "请确认新密码")
            return
        }
        
        // 验证密码匹配
        guard newPassword == confirmPassword else {
            showAlert(title: "提示", message: "两次输入的密码不一致")
            return
        }
        
        // 调用密码重置（异步）
        UserManager.shared.resetPassword(username: username, phone: phone, newPassword: newPassword) { [weak self] success, message in
            DispatchQueue.main.async {
                if success {
                    self?.showAlert(title: "重置成功", message: "密码重置成功，请使用新密码登录") { [weak self] in
                        self?.navigationController?.popViewController(animated: true)
                    }
                } else {
                    self?.showAlert(title: "重置失败", message: message)
                }
            }
        }
    }
    
    // MARK: - 提示框
    
    private func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true, completion: nil)
    }
}

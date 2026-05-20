//
//  RegisterViewController.swift
//  TUIKitDemo
//
//  用户注册页面
//

import UIKit
import TIMAppKit
import TIMCommon
import TUICore

class RegisterViewController: UIViewController {
    
    // MARK: - UI 组件
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = TUISwift.tuiDemoDynamicImage("public_login_logo_img", defaultImage: UIImage.safeImage("public_login_logo"))
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "注册账号"
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.textColor = TUISwift.timCommonDynamicColor("form_title_color", defaultColor: "#000000")
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
        textField.placeholder = "请输入手机号码"
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
        textField.placeholder = "请输入密码 (6-20位)"
        textField.borderStyle = .none
        textField.backgroundColor = TUISwift.timCommonDynamicColor("form_bg_color", defaultColor: "#F3F4F5")
        textField.layer.cornerRadius = 10
        textField.isSecureTextEntry = true
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftViewMode = .always
        textField.font = UIFont.systemFont(ofSize: 16)
        return textField
    }()
    
    private lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("注册", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = TUISwift.timCommonDynamicColor("primary_theme_color", defaultColor: "#147AFF")
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(registerButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("已有账号? 登录", for: .normal)
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
        setupNavigation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - UI 设置
    
    private func setupNavigation() {
        title = "注册"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage.safeImage("nav_back"),
            style: .plain,
            target: self,
            action: #selector(backToLogin)
        )
    }
    
    private func setupUI() {
        view.backgroundColor = TUISwift.timCommonDynamicColor("controller_bg_color", defaultColor: "#FFFFFF")
        
        view.addSubview(logoImageView)
        view.addSubview(titleLabel)
        view.addSubview(usernameTextField)
        view.addSubview(phoneTextField)
        view.addSubview(passwordTextField)
        view.addSubview(registerButton)
        view.addSubview(backButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        phoneTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Logo
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            logoImageView.widthAnchor.constraint(equalToConstant: 120),
            logoImageView.heightAnchor.constraint(equalToConstant: 80),
            
            // 标题
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20),
            
            // 用户名输入框
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            usernameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            usernameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // 手机号输入框
            phoneTextField.leadingAnchor.constraint(equalTo: usernameTextField.leadingAnchor),
            phoneTextField.trailingAnchor.constraint(equalTo: usernameTextField.trailingAnchor),
            phoneTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 16),
            phoneTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // 密码输入框
            passwordTextField.leadingAnchor.constraint(equalTo: usernameTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: usernameTextField.trailingAnchor),
            passwordTextField.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 16),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // 注册按钮
            registerButton.leadingAnchor.constraint(equalTo: usernameTextField.leadingAnchor),
            registerButton.trailingAnchor.constraint(equalTo: usernameTextField.trailingAnchor),
            registerButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
            registerButton.heightAnchor.constraint(equalToConstant: 50),
            
            // 返回登录按钮
            backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backButton.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: 20),
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
    
    @objc private func registerButtonClicked() {
        dismissKeyboard()
        
        guard let username = usernameTextField.text, !username.isEmpty else {
            showAlert(title: "提示", message: "请输入用户名")
            return
        }
        
        guard let phone = phoneTextField.text, !phone.isEmpty else {
            showAlert(title: "提示", message: "请输入手机号码")
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            showAlert(title: "提示", message: "请输入密码")
            return
        }
        
        // 调用注册（异步）
        UserManager.shared.register(phone: phone, username: username, password: password) { [weak self] success, message in
            DispatchQueue.main.async {
                if success {
                    self?.showAlert(title: "注册成功", message: "恭喜您注册成功，现在可以使用用户名 \(username) 登录了") { [weak self] in
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            self?.navigationController?.popViewController(animated: true)
                        }
                    }
                } else {
                    self?.showAlert(title: "注册失败", message: message)
                }
            }
        }
    }
    
    // MARK: - 提示框
    
    private func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "确定", style: .default) { [weak self] _ in
            completion?()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

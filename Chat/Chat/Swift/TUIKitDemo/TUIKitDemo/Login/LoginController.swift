//
//  LoginController.swift
//  TUIKitDemo
//
//  登录页面 - 支持用户名密码登录
//

import Foundation
import TIMAppKit
import TIMCommon
import TUIChat
import TUIContact
import TUICore
import UIKit

class LoginController: UIViewController {
    @IBOutlet var user: UITextField!
    @IBOutlet var logView: UIImageView!
    @IBOutlet var loginButton: UIButton!

    private var changeStyleView: UIView?
    private var changeSkinView: UIView?
    private var changeLanguageView: UIView?
    
    // MARK: - 用户名密码登录UI
    private let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "请输入用户名"
        textField.borderStyle = .none
        textField.backgroundColor = TUISwift.timCommonDynamicColor("form_bg_color", defaultColor: "#FFFFFF")
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.systemGray5.cgColor
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftViewMode = .always
        textField.font = UIFont.systemFont(ofSize: 16)
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "请输入密码"
        textField.borderStyle = .none
        textField.backgroundColor = TUISwift.timCommonDynamicColor("form_bg_color", defaultColor: "#FFFFFF")
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.systemGray5.cgColor
        textField.isSecureTextEntry = true
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftViewMode = .always
        textField.font = UIFont.systemFont(ofSize: 16)
        return textField
    }()
    
    private lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("注册账号", for: .normal)
        button.setTitleColor(TUISwift.timCommonDynamicColor("primary_theme_color", defaultColor: "#147AFF"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(onRegister), for: .touchUpInside)
        return button
    }()
    
    private lazy var forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("忘记密码", for: .normal)
        button.setTitleColor(UIColor.gray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.addTarget(self, action: #selector(onForgotPassword), for: .touchUpInside)
        return button
    }()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)

        view.backgroundColor = TUISwift.timCommonDynamicColor("controller_bg_color", defaultColor: "#F3F4F5")
        logView.image = TUISwift.tuiDemoDynamicImage("public_login_logo_img", defaultImage: UIImage.safeImage("public_login_logo"))
        loginButton.backgroundColor = TUISwift.timCommonDynamicColor("primary_theme_color", defaultColor: "#147AFF")
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTap)))
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.setTitle(NSLocalizedString("login", comment: ""), for: .normal)

        changeStyleView = createOptionalView(title: NSLocalizedString("ChangeStyle", comment: ""),
                                             leftIcon: TUISwift.tuiDemoDynamicImage("", defaultImage: UIImage.safeImage("icon_style")),
                                             rightIcon: TUISwift.tuiDemoDynamicImage("login_drop_img", defaultImage: UIImage.safeImage("icon_drop_arraw")))
        changeStyleView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onChangeStyle)))

        changeSkinView = createOptionalView(title: NSLocalizedString("ChangeSkin", comment: ""),
                                          leftIcon: UIImage.safeImage("icon_skin"),
                                          rightIcon: UIImage.safeImage("icon_drop_arraw"))
        changeSkinView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onChangeSkin)))

        changeLanguageView = createOptionalView(title: NSLocalizedString("CurrentLanguage", comment: ""),
                                               leftIcon: UIImage.safeImage("icon_language"),
                                               rightIcon: UIImage.safeImage("icon_drop_arraw"))
        changeLanguageView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onChangeLanguage)))

        if let changeStyleView = changeStyleView, let changeSkinView = changeSkinView, let changeLanguageView = changeLanguageView {
            view.addSubview(changeStyleView)
            view.addSubview(changeSkinView)
            view.addSubview(changeLanguageView)
        }
        
        // 添加用户名密码登录UI
        view.addSubview(usernameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(registerButton)
        view.addSubview(forgotPasswordButton)
        
        // 隐藏原有的用户ID输入框
        user.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupConstraints()
    }

    private func setupConstraints() {
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        forgotPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // 用户名输入框 - 在logo下方
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            usernameTextField.topAnchor.constraint(equalTo: logView.bottomAnchor, constant: 50),
            usernameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // 密码输入框
            passwordTextField.leadingAnchor.constraint(equalTo: usernameTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: usernameTextField.trailingAnchor),
            passwordTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 16),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // 登录按钮 - 移到密码框下方
            loginButton.leadingAnchor.constraint(equalTo: usernameTextField.leadingAnchor),
            loginButton.trailingAnchor.constraint(equalTo: usernameTextField.trailingAnchor),
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            
            // 注册账号按钮 - 登录按钮下方左侧
            registerButton.leadingAnchor.constraint(equalTo: loginButton.leadingAnchor),
            registerButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20),
            registerButton.widthAnchor.constraint(equalToConstant: 100),
            registerButton.heightAnchor.constraint(equalToConstant: 30),
            
            // 忘记密码按钮 - 登录按钮下方右侧
            forgotPasswordButton.trailingAnchor.constraint(equalTo: loginButton.trailingAnchor),
            forgotPasswordButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20),
            forgotPasswordButton.widthAnchor.constraint(equalToConstant: 80),
            forgotPasswordButton.heightAnchor.constraint(equalToConstant: 30),
        ])
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.changeLanguageView?.mm_right(20)
            if #available(iOS 11.0, *) {
                self.changeLanguageView?.mm_y = 10 + self.view.mm_safeAreaTopGap
            } else {
                self.changeLanguageView?.mm_y = 10
            }

            if TUIStyleSelectViewController.isClassicEntrance() {
                self.changeSkinView?.isHidden = false
                self.changeSkinView?.mm_right(20 + (self.changeLanguageView?.mm_w ?? 0) + 20)
                self.changeSkinView?.mm_y = self.changeLanguageView?.mm_y ?? 0
                self.changeStyleView?.mm_right(40 + (self.changeSkinView?.mm_w ?? 0) + (self.changeLanguageView?.mm_w ?? 0) + 20)
                self.changeStyleView?.mm_y = self.changeLanguageView?.mm_y ?? 0
            } else {
                self.changeSkinView?.isHidden = true
                self.changeStyleView?.mm_right(20 + (self.changeLanguageView?.mm_w ?? 0) + 20)
                self.changeStyleView?.mm_y = self.changeLanguageView?.mm_y ?? 0
            }
        }
    }
    
    // MARK: - 按钮事件
    
    @objc func onRegister() {
        let registerVC = RegisterViewController()
        navigationController?.pushViewController(registerVC, animated: true)
    }
    
    @objc func onForgotPassword() {
        let forgotVC = ForgotPasswordViewController()
        navigationController?.pushViewController(forgotVC, animated: true)
    }

    @objc func onTap() {
        view.endEditing(true)
    }

    @objc func onChangeLanguage() {
        let vc = TUILanguageSelectController()
        vc.delegate = AppDelegate.sharedInstance
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc func onChangeStyle() {
        let vc = TUIStyleSelectViewController()
        vc.delegate = AppDelegate.sharedInstance as? TUIStyleSelectControllerDelegate
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc func onChangeSkin() {
        let vc = TUIThemeSelectController()
        vc.delegate = AppDelegate.sharedInstance
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func login(_ sender: Any) {
        view.endEditing(true)
        
        // 用户名密码登录
        guard let username = usernameTextField.text, !username.isEmpty else {
            showAlert(title: "提示", message: "请输入用户名")
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            showAlert(title: "提示", message: "请输入密码")
            return
        }
        
        // 调用用户管理器登录（异步）
        UserManager.shared.login(username: username, password: password) { [weak self] success, message, userId in
            DispatchQueue.main.async {
                if success, let userId = userId {
                    let userSig = GenerateTestUserSig.genTestUserSig(identifier: userId)
                    self?.loginIM(userId: userId, userSig: userSig)
                } else {
                    self?.showAlert(title: "登录失败", message: message)
                }
            }
        }
    }

    func loginIM(userId: String, userSig: String) {
        if userId.isEmpty || userSig.isEmpty {
            TUITool.hideToastActivity()
            alertText(NSLocalizedString("TipsLoginErrorWithUserIdfailed", comment: ""))
            return
        }
        TCLoginModel.sharedInstance.saveLoginedInfo(userID: userId, userSig: userSig)
        let delegate = UIApplication.shared.delegate as? AppDelegate
        let message = String(format: NSLocalizedString("TipsLoginErrorFormat", comment: ""), -1, "Please check whether the SDKAPPID and SECRETKEY are correctly configured (GenerateTestUserSig.h)")
        delegate?.loginSDK(userId, userSig: userSig, succ: { [weak self] in
            TUITool.hideToastActivity()
            self?.navigationController?.popViewController(animated: true)
        }, fail: { [weak self] code, _ in
            TUITool.hideToastActivity()
            DispatchQueue.main.async {
                self?.alertText(message)
            }
        })
    }

    func alertText(_ str: String) {
        let alert = UIAlertController(title: str, message: nil, preferredStyle: .alert)
        alert.tuitheme_addAction(UIAlertAction(title: NSLocalizedString("confirm", comment: ""), style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true, completion: nil)
    }

    func createOptionalView(title: String, leftIcon: UIImage?, rightIcon: UIImage?) -> UIView {
        let contentView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 40))

        let label = UILabel()
        label.text = title
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textColor = .gray
        label.isUserInteractionEnabled = true
        contentView.addSubview(label)

        let leftIconView = UIImageView()
        leftIconView.image = leftIcon
        leftIconView.isUserInteractionEnabled = true
        contentView.addSubview(leftIconView)

        let rightIconView = UIImageView()
        rightIconView.image = rightIcon
        rightIconView.isUserInteractionEnabled = true
        contentView.addSubview(rightIconView)

        leftIconView.mm_width(18.0).mm_height(18.0)
        leftIconView.mm_x = 0
        leftIconView.mm_centerY = 0.5 * (contentView.mm_h - leftIconView.mm_h)

        label.sizeToFit()
        label.mm_x = leftIconView.frame.maxX + 5.0
        label.mm_centerY = leftIconView.mm_centerY
        rightIconView.mm_width(10.0).mm_height(7.0)
        rightIconView.mm_x = label.frame.maxX + 5.0
        rightIconView.mm_centerY = leftIconView.mm_centerY

        contentView.mm_w = rightIconView.frame.maxX

        return contentView
    }
}

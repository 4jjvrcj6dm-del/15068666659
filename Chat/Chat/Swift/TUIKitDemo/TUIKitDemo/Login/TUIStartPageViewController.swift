// TUIStartPageViewController.swift
// TUIKitDemo
//
// Created by Tencent on 2023/8/1.
// Copyright © 2023 Tencent. All rights reserved.

import SnapKit
import TIMAppKit
import TIMCommon
import TUICore
import UIKit

class TUIStartPageViewController: UIViewController {
    private let containerLogoView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let mainLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 35)
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = TUISwift.timCommonDynamicColor("launch_page_color", defaultColor: "#F3F4F5")
        view.addSubview(containerLogoView)
        containerLogoView.addSubview(logoImageView)
        containerLogoView.addSubview(mainLabel)
        
        logoImageView.image = TUISwift.timCommonDynamicImage("launch_page_logo_img", defaultImage: UIImage.safeImage(TUISwift.tuiDemoImagePath("launch_page_logo")))
        mainLabel.text = NSLocalizedString("TUIStartPageTitle", comment: "")
        
        containerLogoView.snp.makeConstraints { make in
            make.center.equalTo(view)
            make.width.equalTo(view)
        }
        
        logoImageView.snp.makeConstraints { make in
            make.top.equalTo(containerLogoView.snp.top)
            make.centerX.equalTo(containerLogoView)
            make.width.equalTo(160)
            make.height.equalTo(80)
        }
        
        mainLabel.sizeToFit()
        mainLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(10)
            make.width.equalTo(mainLabel.frame.size.width)
            make.height.equalTo(mainLabel.frame.size.height)
            make.bottom.equalTo(containerLogoView.snp.bottom)
            make.centerX.equalTo(logoImageView)
        }
        
        // 延迟跳转到登录页面
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.navigateToLogin()
        }
    }
    
    private func navigateToLogin() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = windowScene.delegate as? UIWindowSceneDelegate else {
            return
        }
        
        let loginVC = (UIApplication.shared.delegate as? AppDelegate)?.getLoginController()
        if let loginVC = loginVC {
            UIView.transition(with: sceneDelegate.window!!, duration: 0.3, options: .transitionCrossDissolve) {
                sceneDelegate.window??.rootViewController = loginVC
            }
        }
    }
}

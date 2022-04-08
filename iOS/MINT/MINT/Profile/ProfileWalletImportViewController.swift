//
//  ProfileWalletImportViewController.swift
//  MINT
//
//  Created by choymoon on 2022/04/01.
//

import UIKit

import web3swift

class ProfileWalletImportViewController: UIViewController {
    
    private let tapView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let infoContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .background
        view.layer.cornerRadius = 25
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()

    private let indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.5)
        view.layer.cornerRadius = 2.5
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .rubikOne(size: 28)
        label.text = "Wallet Connect"
        label.textColor = .lightMain
        return label
    }()
    
    private let walletNameLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.medium, size: 16)
        label.textColor = .white
        label.text = "지갑 이름"
        return label
    }()
    
    private let walletNameTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .label
        textField.layer.cornerRadius = 12
        textField.backgroundColor = .lightBackground
        textField.textColor = .white
        textField.textAlignment = .left
        textField.font = .pretendard(.bold, size: 16)
        textField.attributedPlaceholder = NSAttributedString(string: "  지갑 이름을 입력해주세요 :)",
                                                             attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        textField.leftViewMode = .always
        textField.tintColor = .main
        textField.keyboardType = .emailAddress
        return textField
    }()
    
    private let privateKeyLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.medium, size: 16)
        label.textColor = .white
        label.text = "보안키 / Private Key"
        return label
    }()
    
    private let privateKeyTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .label
        textField.layer.cornerRadius = 12
        textField.backgroundColor = .lightBackground
        textField.textColor = .white
        textField.textAlignment = .left
        textField.font = .pretendard(.bold, size: 16)
        textField.attributedPlaceholder = NSAttributedString(string: "  보안키를 입력해주세요 :)",
                                                             attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        textField.leftViewMode = .always
        textField.tintColor = .main
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.medium, size: 16)
        label.textColor = .white
        label.text = "비밀번호"
        return label
    }()
    
    private let passwordCautionLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.black, size: 11)
        label.textColor = .pointYellow
        label.text = "일회성 비밀번호로서, 앱에서 연결이 끊기면 비밀번호는 없어집니다 :)"
        return label
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .label
        textField.layer.cornerRadius = 12
        textField.backgroundColor = .lightBackground
        textField.textColor = .white
        textField.textAlignment = .left
        textField.font = .pretendard(.bold, size: 16)
        textField.attributedPlaceholder = NSAttributedString(string: "  지갑 비밀번호를 입력해주세요 :)",
                                                             attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        textField.leftViewMode = .always
        textField.tintColor = .main
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let importButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .main
        button.layer.cornerRadius = 15
        button.setTitle("지갑 연결", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        button.titleLabel?.font = .pretendard(.black, size: 16)
        button.setImage(UIImage(named: "ic_link"), for: .normal)
        button.tintColor = .white
        button.semanticContentAttribute = .forceRightToLeft
        button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 15, bottom: 5, right: -5)
        return button
    }()
    
    private lazy var tapGesture: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeView))
        return tap
    }()
    
    private lazy var pan: UIPanGestureRecognizer = {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(containerPanned(_:)))
        pan.maximumNumberOfTouches = 1
        return pan
    }()
    
    private let userManager = UserManager.shared
}

extension ProfileWalletImportViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateViews(with: false)
    }
}

extension ProfileWalletImportViewController {
    
    private func configureViews() {
        self.view.backgroundColor = .clear

        self.view.addSubview(tapView)
        tapView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        tapView.addGestureRecognizer(tapGesture)
        
        self.view.addSubview(infoContainerView)
        infoContainerView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.75)
        }
        infoContainerView.transform = CGAffineTransform(translationX: 0, y: self.view.bounds.height * 0.75)
        infoContainerView.addGestureRecognizer(pan)
        
        infoContainerView.addSubview(indicatorView)
        indicatorView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(5)
            make.top.equalToSuperview().offset(10)
        }
        
        infoContainerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(indicatorView.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
        }
        
        infoContainerView.addSubview(walletNameLabel)
        walletNameLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
        }
        
        infoContainerView.addSubview(walletNameTextField)
        walletNameTextField.snp.makeConstraints { make in
            make.top.equalTo(walletNameLabel.snp.bottom).offset(4)
            make.left.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
        }
        
        infoContainerView.addSubview(privateKeyLabel)
        privateKeyLabel.snp.makeConstraints { make in
            make.top.equalTo(walletNameTextField.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
        }
        let aster1 = UIImageView(image: UIImage.init(named: "ic_asterik")?.withTintColor((.pointRed ?? .white), renderingMode: .alwaysOriginal))
        infoContainerView.addSubview(aster1)
        aster1.snp.makeConstraints { make in
            make.centerY.equalTo(privateKeyLabel)
            make.left.equalTo(privateKeyLabel.snp.right).offset(4)
            make.width.equalTo(8)
            make.height.equalTo(8)
        }
        
        infoContainerView.addSubview(privateKeyTextField)
        privateKeyTextField.snp.makeConstraints { make in
            make.top.equalTo(privateKeyLabel.snp.bottom).offset(4)
            make.left.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
        }
        
        infoContainerView.addSubview(passwordLabel)
        passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(privateKeyTextField.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
        }
        let aster2 = UIImageView(image: UIImage.init(named: "ic_asterik")?.withTintColor((.pointRed ?? .white), renderingMode: .alwaysOriginal))
        infoContainerView.addSubview(aster2)
        aster2.snp.makeConstraints { make in
            make.centerY.equalTo(passwordLabel)
            make.left.equalTo(passwordLabel.snp.right).offset(4)
            make.width.equalTo(8)
            make.height.equalTo(8)
        }
        
        infoContainerView.addSubview(passwordCautionLabel)
        passwordCautionLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordLabel.snp.bottom).offset(2)
            make.left.equalToSuperview().offset(20)
        }
        
        infoContainerView.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordCautionLabel.snp.bottom).offset(4)
            make.left.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
        }
        
        infoContainerView.addSubview(importButton)
        importButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-20)
            make.height.equalTo(50)
        }
        importButton.addTarget(self, action: #selector(importWallet), for: .touchUpInside)
    }
}

extension ProfileWalletImportViewController {
    
    @objc private func importWallet() {
        self.view.endEditing(true)
        
        guard let privateKey = privateKeyTextField.text, let password = passwordTextField.text, let walletName = walletNameTextField.text else { return }
        
        if privateKey.isEmpty {
            ToastAlert().show(title: "보안키를 입력해주세요..  :(", duration: 0.5, isTop: true)
        } else if password.isEmpty {
            ToastAlert().show(title: "비밀번호를 입력해주세요..  :(", duration: 0.5, isTop: true)
        } else {
            ToastAlert().show(title: "지갑 연결중...", labelColor: .pointYellow, isTop: true)
            importButton.isEnabled = false
            if walletName.isEmpty {
                userManager.importUserWallet(privateKey: privateKey, password: password) { result in
                    if result {
                        ToastAlert().show(title: "연결 완료 :)", labelColor: .main, isTop: true)
                        self.animateViews(with: true)
                    } else {
                        self.importButton.isEnabled = true
                        ToastAlert().show(title: "보안키 혹은 비밀번호를 확인해주세요..  :(", isTop: true)
                    }
                }
            } else {
                userManager.importUserWallet(privateKey: privateKey, password: password, walletName: walletName) { result in
                    if result {
                        ToastAlert().show(title: "연결 완료 :)", labelColor: .main, isTop: true)
                        self.animateViews(with: true)
                    } else {
                        self.importButton.isEnabled = true
                        ToastAlert().show(title: "보안키 혹은 비밀번호를 확인해주세요..  :(", isTop: true)
                    }
                }
            }
        }
    }
    
    @objc private func closeView() {
        self.animateViews(with: true)
    }
    
    private func animateViews(with isDismissing: Bool, isButtonAction: Bool = false) {
        if isDismissing {
            UIView.animate(withDuration: 0.33, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.2, options: .curveEaseInOut) {
                self.view.backgroundColor = .darkGray.withAlphaComponent(0)
                self.infoContainerView.transform = CGAffineTransform(translationX: 0, y: self.view.bounds.height * 0.75)
            } completion: { finished in
                if finished {
                    self.dismiss(animated: false, completion: nil)
                }
            }
        } else {
            UIView.animate(withDuration: 0.33, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.2, options: .curveEaseInOut) {
                self.view.backgroundColor = .darkGray.withAlphaComponent(0.55)
                self.infoContainerView.transform = CGAffineTransform(translationX: 0, y: 0)
            }
        }
    }
    
    @objc func containerPanned(_ sender: UIPanGestureRecognizer) {
        if sender.state == .ended {
            if infoContainerView.transform.ty >= (infoContainerView.bounds.height * 0.25) {
                animateViews(with: true)
            } else {
                animateViews(with: false)
            }
        } else {
            let transition = sender.translation(in: infoContainerView)
            let velocity = sender.velocity(in: infoContainerView)
             
            // check up or down
            if abs(velocity.y) > abs(velocity.x) {
                if velocity.y < 0 {
                    if self.infoContainerView.transform.ty <= 0 {
                        self.infoContainerView.transform.ty = 0
                        sender.setTranslation(.zero, in: infoContainerView)
                    } else {
                        if infoContainerView.transform.ty - transition.y <= 0 {
                            self.infoContainerView.transform.ty = 0
                            sender.setTranslation(.zero, in: infoContainerView)
                        } else {
                            infoContainerView.transform.ty += transition.y
                            sender.setTranslation(.zero, in: infoContainerView)
                        }
                    }
                } else {
                    if self.infoContainerView.transform.ty < 0 {
                        self.infoContainerView.transform.ty = 0
                        sender.setTranslation(.zero, in: infoContainerView)
                    } else {
                        self.infoContainerView.transform.ty += transition.y
                        sender.setTranslation(.zero, in: infoContainerView)
                    }
                }
            }
        }
    }
}


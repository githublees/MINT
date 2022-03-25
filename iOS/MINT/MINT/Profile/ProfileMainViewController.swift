//
//  ProfileMainViewController.swift
//  MINT
//
//  Created by choymoon on 2022/03/22.
//

import UIKit

class ProfileMainViewController: UIViewController {
        
    private let navTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Profile"
        label.textColor = .lightMain
        label.font = .rubikOne(size: 32)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
}

extension ProfileMainViewController {
    
    private func configureViews() {
        self.view.backgroundColor = .background
        
        self.view.addSubview(navTitleLabel)
        
        navTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(20)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(20)
        }
    }
}

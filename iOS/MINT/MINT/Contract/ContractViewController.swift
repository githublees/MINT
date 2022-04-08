//
//  ContractViewController.swift
//  MINT
//
//  Created by choymoon on 2022/04/07.
//

import UIKit

import Moya

class ContractViewController: UIViewController {

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightBackground
        view.layer.cornerRadius = 25
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "토지 거래"
        label.font = .pretendard(.black, size: 28)
        label.textColor = .white
        return label
    }()
    
    private let planetLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.bold, size: 16)
        label.text = "행성 이름"
        label.textColor = .lightMain
        return label
    }()
    
    private let tilePlanetLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.black, size: 18)
        label.text = " "
        label.textColor = .white
        return label
    }()
    
    private let tileLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.bold, size: 16)
        label.text = "토지 이름"
        label.textColor = .lightMain
        return label
    }()
    
    private let tileIdLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.black, size: 18)
        label.text = "id"
        label.textColor = .white
        return label
    }()
    
    private let walletLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.bold, size: 16)
        label.text = "구매자 지갑 주소"
        label.textColor = .lightMain
        return label
    }()
    
    private let walletAddressLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.black, size: 11.5)
        label.text = "wallet"
        label.textColor = .white
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.bold, size: 16)
        label.text = "토지 가격"
        label.textColor = .lightMain
        return label
    }()
    
    private let tilePriceLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.black, size: 18)
        label.text = "price"
        label.textColor = .white
        return label
    }()
    
    private let balanceLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.bold, size: 16)
        label.text = "지갑 잔액"
        label.textColor = .lightMain
        return label
    }()
    
    private let walletBalanceLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.black, size: 18)
        label.text = "balance ETH"
        label.textColor = .white
        return label
    }()
    
    private let gasLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.black, size: 14)
        label.text = "Gas 요금은 추천에 의해 자동으로 책정됩니다 :)"
        label.textColor = .white
        return label
    }()
    
    private let buyButton: UIButton = {
        let button = UIButton()
        button.setTitle("구매하기", for: .normal)
        button.layer.cornerRadius = 12
        button.backgroundColor = .main
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        button.titleLabel?.font = .pretendard(.black, size: 18)
        return button
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("취소하기", for: .normal)
        button.layer.cornerRadius = 12
        button.backgroundColor = .pointRed
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        button.titleLabel?.font = .pretendard(.black, size: 18)
        return button
    }()
    
    private let tileInfo: PlanetTile
    private let planetInfo: Planet
    private let contractNetworkService = MoyaProvider<ContractNetworkService>()
    private let userManager = UserManager.shared
    
    init(tileInfo: PlanetTile, planetInfo: Planet) {
        self.tileInfo = tileInfo
        self.planetInfo = planetInfo
        super.init(nibName: nil, bundle: nil)
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overFullScreen
        self.tilePlanetLabel.text = planetInfo.name
        self.tileIdLabel.text = tileInfo.tileId
        self.tilePriceLabel.text = "\(tileInfo.price) ETH"
        getWalletInfo()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ContractViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
}

extension ContractViewController {
    
    private func configureViews() {
        self.view.backgroundColor = .darkGray.withAlphaComponent(0.75)
        
        self.view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.left.equalTo(self.view.safeAreaLayoutGuide).offset(20)
            make.center.equalToSuperview()
        }
        
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(20)
        }
        
        let lineView = UIView()
        lineView.backgroundColor = .lightGray
        lineView.layer.cornerRadius = 0.5
        containerView.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.left.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(1)
        }
        
        containerView.addSubview(planetLabel)
        planetLabel.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(20)
        }
        
        containerView.addSubview(tilePlanetLabel)
        tilePlanetLabel.snp.makeConstraints { make in
            make.top.equalTo(planetLabel.snp.bottom).offset(4)
            make.left.equalToSuperview().offset(20)
        }
        
        containerView.addSubview(tileLabel)
        tileLabel.snp.makeConstraints { make in
            make.top.equalTo(tilePlanetLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(20)
        }
        
        containerView.addSubview(tileIdLabel)
        tileIdLabel.snp.makeConstraints { make in
            make.top.equalTo(tileLabel.snp.bottom).offset(4)
            make.left.equalToSuperview().offset(20)
        }
        
        containerView.addSubview(walletLabel)
        walletLabel.snp.makeConstraints { make in
            make.top.equalTo(tileIdLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(20)
        }
        
        containerView.addSubview(walletAddressLabel)
        walletAddressLabel.snp.makeConstraints { make in
            make.top.equalTo(walletLabel.snp.bottom).offset(4)
            make.left.equalToSuperview().offset(20)
        }
        
        containerView.addSubview(balanceLabel)
        balanceLabel.snp.makeConstraints { make in
            make.top.equalTo(walletAddressLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(20)
        }
        
        containerView.addSubview(walletBalanceLabel)
        walletBalanceLabel.snp.makeConstraints { make in
            make.top.equalTo(balanceLabel.snp.bottom).offset(4)
            make.left.equalToSuperview().offset(20)
        }
        
        let lineView2 = UIView()
        lineView2.backgroundColor = .lightGray
        lineView2.layer.cornerRadius = 0.5
        containerView.addSubview(lineView2)
        lineView2.snp.makeConstraints { make in
            make.top.equalTo(balanceLabel).offset(4)
            make.width.equalTo(1)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(walletBalanceLabel)
        }
        
        containerView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(walletAddressLabel.snp.bottom).offset(10)
            make.left.equalTo(lineView2.snp.right).offset(20)
        }
        
        containerView.addSubview(tilePriceLabel)
        tilePriceLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(4)
            make.left.equalTo(lineView2.snp.right).offset(20)
        }
        
        let lineView3 = UIView()
        lineView3.backgroundColor = .lightGray
        lineView3.layer.cornerRadius = 0.5
        containerView.addSubview(lineView3)
        lineView3.snp.makeConstraints { make in
            make.top.equalTo(walletBalanceLabel.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(1)
        }
        
        containerView.addSubview(gasLabel)
        gasLabel.snp.makeConstraints { make in
            make.top.equalTo(lineView3.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(20)
        }
        
        containerView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-20)
            make.left.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(45)
        }
        cancelButton.addTarget(self, action: #selector(cancelContract), for: .touchUpInside)
        
        containerView.addSubview(buyButton)
        buyButton.snp.makeConstraints { make in
            make.bottom.equalTo(cancelButton.snp.top).offset(-10)
            make.left.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(45)
            make.top.equalTo(gasLabel.snp.bottom).offset(30)
        }
        buyButton.addTarget(self, action: #selector(buyButtonTapped), for: .touchUpInside)
    }
    
    @objc private func cancelContract() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func buyButtonTapped() {
        userManager.buyTile(galaxy: planetInfo.galaxy,
                            planet: planetInfo.name,
                            tile: tileInfo.tileId,
                            price: tileInfo.price) { result in
            print(result)
        }
    }
}

extension ContractViewController {
    
    private func getWalletInfo() {
        guard let walletInfo = userManager.walletInfo() else {
            ToastAlert().show(title: "지갑 정보가 없습니다.")
            return
        }
        
        walletAddressLabel.text = walletInfo.address
        userManager.getWalletBalnce(completion: { balanceLabel in
            DispatchQueue.main.sync {
                self.walletBalanceLabel.text = balanceLabel + " ETH"
            }
        })
    }
}

//
//  PlanetTileCell.swift
//  MINT
//
//  Created by choymoon on 2022/04/04.
//

import UIKit

class PlanetTileCell: UICollectionViewCell {
    
    private let tileIdLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.black, size: 18)
        label.textColor = .main
        return label
    }()
    
    private let tileSizeLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.medium, size: 15)
        label.textColor = .white
        return label
    }()
    
    private let tilePriceLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.medium, size: 15)
        label.textColor = .white
        return label
    }()
    
    private let etherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_ethereum")?.withTintColor(.white, renderingMode: .alwaysTemplate)
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let ownerLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.black, size: 10)
        label.textColor = .lightestMain
        return label
    }()
    
    private let favButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ic_star")?.withTintColor(.white, renderingMode: .alwaysOriginal),
                        for: .normal)
        button.setImage(UIImage(named: "ic_star_selected")?.withTintColor((.pointYellow ?? .white), renderingMode: .alwaysOriginal),
                        for: .selected)
        return button
    }()
    
    private let cartButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ic_cart_add")?.withTintColor(.white, renderingMode: .alwaysOriginal),
                        for: .normal)
        button.setImage(UIImage(named: "ic_cart_added")?.withTintColor((.lightMain ?? .white), renderingMode: .alwaysOriginal),
                        for: .selected)
        return button
    }()
    
    private let purchaseButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 12
        button.backgroundColor = .lightMain
        button.setTitle("구매", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        return button
    }()
    
    private let userManager = UserManager.shared
    public var delegate: PlanetTileCellDelegate?
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var tileInfo: PlanetTile?
    
    public func setTileInfo(info: PlanetTile) {
        self.tileInfo = info
        tileIdLabel.text = info.tileId
        tilePriceLabel.text = "가격 : \(info.price) ETH"
        tileSizeLabel.text = "크기 : \(info.area)000 km2"
        
        if let owner = info.buyerAddress {
            ownerLabel.text = "소유자 : \(owner)"
        } else {
            ownerLabel.text = "소유자 : -"
        }
        
        if userManager.cartContains(info: info) {
            cartButton.isSelected = true
        } else {
            cartButton.isSelected = false
        }
        
        if userManager.listContains(tileId: info.tileId) {
            favButton.isSelected = true
        } else {
            favButton.isSelected = false
        }
    }
    
    private func configureViews() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 12
        self.backgroundColor = .lightBackground
        
        self.addSubview(tileIdLabel)
        tileIdLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(10)
        }
        
        self.addSubview(ownerLabel)
        ownerLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        self.addSubview(tilePriceLabel)
        tilePriceLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.bottom.equalTo(ownerLabel.snp.top).offset(-4)
        }
        
        self.addSubview(tileSizeLabel)
        tileSizeLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.bottom.equalTo(tilePriceLabel.snp.top).offset(4)
        }
        
        self.addSubview(etherImageView)
        etherImageView.snp.makeConstraints { make in
            make.left.equalTo(tilePriceLabel.snp.right).offset(4)
            make.top.equalTo(tilePriceLabel).offset(4)
            make.bottom.equalTo(tilePriceLabel).offset(-4)
            make.width.equalTo(12)
        }
        
        let stackView = UIStackView(arrangedSubviews: [favButton, cartButton])
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.distribution = .fillEqually
        self.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(45)
            make.width.equalTo(95)
        }
        
        favButton.addTarget(self, action: #selector(favButtonTapped), for: .touchUpInside)
        cartButton.addTarget(self, action: #selector(cartButtonTapped), for: .touchUpInside)
        
        self.addSubview(purchaseButton)
        purchaseButton.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(2)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(35)
            make.width.equalTo(95)
        }
        purchaseButton.addTarget(self, action: #selector(purchaseTapped), for: .touchUpInside)
    }
    
    @objc private func favButtonTapped() {
        guard let info = self.tileInfo else { return }
        delegate?.tileSelected(with: info.tileId)
        
        switch favButton.isSelected {
        case true:
            userManager.removeFavoriteTile(tileId: info.tileId) { result in
                switch result {
                case .needWalletId:
                    ToastAlert().show(title: "찜 기능을 이용 하려면\n지갑 등록이 필요합니다..  :(", lines: 2)
                case .success:
                    ToastAlert().show(title: "찜 삭제를 완료하였습니다 :)", labelColor: .main)
                case .error(let error):
                    ToastAlert().show(title: "찜 등록에 문제가 생겼습니다..  :(\nError : \(error.localizedDescription)", lines: 2)
                case .failure(let message):
                    ToastAlert().show(title: "찜 등록에 문제가 생겼습니다..  :(\nError : \(message)", lines: 2)
                }
            }
        case false:
            UserManager.shared.registerFavoriteTile(tileId: info.tileId) { result in
                switch result {
                case .needWalletId:
                    ToastAlert().show(title: "찜 기능을 이용 하려면\n지갑 등록이 필요합니다..  :(", lines: 2)
                case .success:
                    ToastAlert().show(title: "찜 등록을 완료하였습니다 :)", labelColor: .main)
                case .error(let error):
                    ToastAlert().show(title: "찜 등록에 문제가 생겼습니다..  :(\nError : \(error.localizedDescription)", lines: 2)
                case .failure(let message):
                    ToastAlert().show(title: "찜 등록에 문제가 생겼습니다..  :(\nError : \(message)", lines: 2)
                }
            }
        }
    }
    
    @objc private func cartButtonTapped() {
        guard let info = self.tileInfo else { return }
        delegate?.tileSelected(with: info.tileId)
        
        if let _ = info.buyerAddress {
            ToastAlert().show(title: "개인간 거래는 현재 준비중에 있습니다.\n조금만 기다려주세요 :)", labelColor: .pointYellow, textColor: .darkGray, lines: 2)
        } else {
            if userManager.cartContains(info: info) {
                userManager.removeFromCart(tileId: info.tileId)
                cartButton.isSelected = false
                ToastAlert().show(title: "카트에서 제거되었습니다 :)", labelColor: .main, duration: 0.5)
            } else {
                userManager.addToCart(info: info)
                cartButton.isSelected = true
                ToastAlert().show(title: "카트에 추가되었습니다 :)", labelColor: .main, duration: 0.5)
            }
        }
    }
    
    @objc private func purchaseTapped() {
        guard let info = self.tileInfo else { return }
        delegate?.tileSelected(with: info.tileId)
        
        guard let _ = userManager.walletId else {
            ToastAlert().show(title: "토지를 구매 하려면\n지갑 등록이 필요합니다..  :(", lines: 2)
            return
        }
        
        if let _ = info.buyerAddress {
            ToastAlert().show(title: "앱 내부 거래는 현재 준비중에 있습니다.\n조금만 기다려주세요 :)", labelColor: .pointYellow, textColor: .darkGray, lines: 2)
        } else {
            ToastAlert().show(title: "앱 내부 거래는 현재 준비중에 있습니다.\n조금만 기다려주세요 :)", labelColor: .pointYellow, textColor: .darkGray, lines: 2)
        }
    }
}

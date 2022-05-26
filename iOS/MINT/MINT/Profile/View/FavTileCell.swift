//
//  FavTileCell.swift
//  MINT
//
//  Created by choymoon on 2022/04/08.
//

import UIKit

import Lottie
import Moya

class FavTileCell: UICollectionViewCell {
    
    private let planetAnimationView: AnimationView = {
        let view = AnimationView()
        view.backgroundColor = .clear
        view.loopMode = .loop
        return view
    }()
    
    private let planetTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .rubikOne(size: 12)
        label.textColor = .white
        return label
    }()
    
    private let tileTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.black, size: 20)
        label.textColor = .main
        label.numberOfLines = 0
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
    
    private let favButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ic_star")?.withTintColor(.white, renderingMode: .alwaysOriginal),
                        for: .normal)
        button.setImage(UIImage(named: "ic_star_selected")?.withTintColor((.pointYellow ?? .white), renderingMode: .alwaysOriginal),
                        for: .selected)
        return button
    }()
    
    private let tileNetworkService = MoyaProvider<TileNetworkService>()
    private let userManager = UserManager.shared
    private var indexPath: IndexPath = IndexPath()
    public var delegate: FavTileCellDelegate?
    public var tileInfo: PlanetTile?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        planetTitleLabel.text = " "
        tileTitleLabel.text = " "
        tilePriceLabel.text = "- ETH"
        self.planetAnimationView.animation = nil
    }
    
    public func setCellInfo(tileId: String, indexPath: IndexPath) {
        self.indexPath = indexPath
        
        DispatchQueue.global(qos: .userInteractive).async {
            self.tileNetworkService.request(.getTileInfo(tileId: tileId)) { result in
                switch result {
                case .success(let response):
                    do {
                        let info = try JSONDecoder().decode(PlanetTile.self, from: response.data)
                        DispatchQueue.main.async {
                            self.setCell(tileInfo: info)
                        }
                    } catch {
                        print(error)
                    }
                case .failure(let err):
                    print(err)
                }
            }
        }
    }
    
    public func setCell(tileInfo: PlanetTile) {
        self.tileInfo = tileInfo
        let planetTitle = getPlanetTitle(tileId: tileInfo.tileId)
        
        OperationQueue().addOperation {
            let animation = Animation.named("planet_" + planetTitle.lowercased(), animationCache: LRUAnimationCache.sharedCache)
            DispatchQueue.main.async {
                self.planetAnimationView.animation = animation
                self.planetAnimationView.play(completion: nil)
            }
        }
        planetTitleLabel.text = planetTitle
        tileTitleLabel.text = tileInfo.tileId
        tilePriceLabel.text = "\(tileInfo.price) ETH"
        if userManager.listContains(tileId: tileInfo.tileId) {
            favButton.isSelected = true
        } else {
            favButton.isSelected = false
        }
    }
    
    private func configureViews() {
        self.backgroundColor = .lightBackground
        self.layer.cornerRadius = 12
        self.clipsToBounds = true
        
        self.addSubview(planetAnimationView)
        planetAnimationView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.left.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-5)
            make.width.equalTo(planetAnimationView.snp.height)
        }
        
        self.addSubview(planetTitleLabel)
        planetTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalTo(planetAnimationView.snp.right).offset(4)
        }
        
        self.addSubview(tileTitleLabel)
        tileTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(planetTitleLabel.snp.bottom)
            make.left.equalTo(planetAnimationView.snp.right).offset(4)
        }
        
        self.addSubview(tilePriceLabel)
        tilePriceLabel.snp.makeConstraints { make in
            make.left.equalTo(planetAnimationView.snp.right).offset(4)
            make.bottom.equalToSuperview().offset(-5)
        }
        
        self.addSubview(etherImageView)
        etherImageView.snp.makeConstraints { make in
            make.left.equalTo(tilePriceLabel.snp.right).offset(4)
            make.top.equalTo(tilePriceLabel).offset(4)
            make.bottom.equalTo(tilePriceLabel).offset(-4)
            make.width.equalTo(12)
        }
        
        self.addSubview(favButton)
        favButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.right.equalToSuperview().offset(-10)
            make.width.equalTo(favButton.snp.height)
        }
        favButton.addTarget(self, action: #selector(favButtonTapped), for: .touchUpInside)
    }
    
    private func getPlanetTitle(tileId: String) -> String {
        switch tileId.prefix(tileId.count - 6) {
        case "TG":
            return "TEEGARDEN_B"
        case "KepB":
            return "KEPLER_22B"
        case "PrxB":
            return "PROXIMA_B"
        case "KepC":
            return "KEPLER_1649C"
        case "RB":
            return "ROSS_128B"
        default:
            return ""
        }
    }
    
    @objc private func favButtonTapped() {
        guard let info = self.tileTitleLabel.text else { return }
        
        delegate?.setOnDelete(true)
        userManager.removeFavoriteTile(tileId: info) { result in
            switch result {
            case .needWalletId:
                ToastAlert().show(title: "찜 기능을 이용 하려면\n지갑 등록이 필요합니다..  :(", lines: 2, isTop: true)
            case .success:
                self.delegate?.deleteCell(at: self.indexPath)
                ToastAlert().show(title: "찜 삭제를 완료하였습니다 :)", labelColor: .main, isTop: true)
            case .error(let error):
                ToastAlert().show(title: "찜 등록에 문제가 생겼습니다..  :(\nError : \(error.localizedDescription)", lines: 2, isTop: true)
            case .failure(let message):
                ToastAlert().show(title: "찜 등록에 문제가 생겼습니다..  :(\nError : \(message)", lines: 2, isTop: true)
            }
        }
    }
}

protocol FavTileCellDelegate {
    
    func setOnDelete(_ value: Bool)
    func deleteCell(at indexPath: IndexPath)
}

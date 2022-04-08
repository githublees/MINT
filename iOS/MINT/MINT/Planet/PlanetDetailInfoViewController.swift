//
//  PlanetDetailInfoViewController.swift
//  MINT
//
//  Created by choymoon on 2022/03/25.
//

import UIKit

import Lottie

class PlanetDetailInfoViewController: UIViewController {
    
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
    
    private let planetTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .rubikOne(size: 28)
        label.textColor = .main
        return label
    }()
    
    private let planetContentLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.regular, size: 14)
        label.textColor = .lightestMain
        return label
    }()
    
    private let massLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.semiBold, size: 16)
        label.textColor = .white
        return label
    }()
    
    private let diameterLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.semiBold, size: 16)
        label.textColor = .white
        return label
    }()
    
    private let galaxyLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.semiBold, size: 16)
        label.textColor = .white
        return label
    }()
    
    private let totalCellLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.semiBold, size: 16)
        label.textColor = .white
        return label
    }()
    
    private let buyButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .main
        button.layer.cornerRadius = 15
        button.setTitle("토지 구매하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        button.titleLabel?.font = .pretendard(.black, size: 16)
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
    
    // Variables
    private let mass: String
    private let diameter: String
    private let galaxy: String
    private let totalCell: String
    private let planet: Planet
    
    public var delegate: PlanetViewDelegate?
    
    init(planet: Planet) {
        self.planet = planet
        mass = "\(planet.mass)"
        diameter = "\(planet.diameter)"
        galaxy = "\(planet.galaxy)"
        totalCell = "\(planet.totalCell)"
        super.init(nibName: nil, bundle: nil)
        planetTitleLabel.text = planet.name.uppercased()
        
        let newContents = planet.content.split(separator: " ")
        
        var resultContent = ""
        for str in newContents {
            if str == "<br>" || str == "<br>\r" {
                resultContent += "\n"
            } else {
                resultContent += String(str)
                resultContent += " "
            }
        }
        
        self.planetContentLabel.text = resultContent
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        tapView.removeGestureRecognizer(tapGesture)
    }
}

extension PlanetDetailInfoViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateViews(with: false)
    }
}

extension PlanetDetailInfoViewController {
    
    private func configureViews() {
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
            make.height.equalToSuperview().multipliedBy(0.5)
        }
        infoContainerView.transform = CGAffineTransform(translationX: 0, y: self.view.bounds.height * 0.5)
        infoContainerView.addGestureRecognizer(pan)
        
        infoContainerView.addSubview(indicatorView)
        indicatorView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(5)
            make.top.equalToSuperview().offset(10)
        }
        
        infoContainerView.addSubview(planetTitleLabel)
        planetTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(indicatorView.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(20)
        }
        
        infoContainerView.addSubview(planetContentLabel)
        planetContentLabel.snp.makeConstraints { make in
            make.top.equalTo(planetTitleLabel.snp.bottom).offset(4)
            make.left.equalToSuperview().offset(20)
        }
        
        galaxyLabel.text = "소속 은하 : " + self.galaxy
        diameterLabel.text = "행성 둘레 : " + self.diameter + " Earth"
        massLabel.text = "행성 질량 : " + self.mass + " Earth"
        totalCellLabel.text = "행성 토지 : " + self.totalCell + " 개"
        
        infoContainerView.addSubview(galaxyLabel)
        galaxyLabel.snp.makeConstraints { make in
            make.top.equalTo(planetContentLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
        }
        
        infoContainerView.addSubview(diameterLabel)
        diameterLabel.snp.makeConstraints { make in
            make.top.equalTo(galaxyLabel.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(20)
        }
        
        infoContainerView.addSubview(massLabel)
        massLabel.snp.makeConstraints { make in
            make.top.equalTo(diameterLabel.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(20)
        }
        
        infoContainerView.addSubview(totalCellLabel)
        totalCellLabel.snp.makeConstraints { make in
            make.top.equalTo(massLabel.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(20)
        }
        
        infoContainerView.addSubview(buyButton)
        buyButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-20)
            make.height.equalTo(45)
        }
        
        buyButton.addTarget(self, action: #selector(closeAndOpenTileVC), for: .touchUpInside)
    }
}

extension PlanetDetailInfoViewController {
    
    @objc private func closeView() {
        self.animateViews(with: true)
    }
    
    @objc private func closeAndOpenTileVC() {
        self.animateViews(with: true, isButtonAction: true)
    }
    
    private func animateViews(with isDismissing: Bool, isButtonAction: Bool = false) {
        if isDismissing {
            UIView.animate(withDuration: 0.33, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.2, options: .curveEaseInOut) {
                self.view.backgroundColor = .darkGray.withAlphaComponent(0)
                self.infoContainerView.transform = CGAffineTransform(translationX: 0, y: self.view.bounds.height * 0.5)
            } completion: { finished in
                if finished {
                    self.dismiss(animated: false) {
                        if isButtonAction {
                            self.delegate?.showPlanetTileViewController(planet: self.planet)
                        }
                    }
                }
            }
        } else {
            UIView.animate(withDuration: 0.33, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.2, options: .curveEaseInOut) {
                self.view.backgroundColor = .darkGray.withAlphaComponent(0.55)
                self.infoContainerView.transform = CGAffineTransform(translationX: 0, y: 0)
            } completion: { _ in
                
            }
        }
    }
}

extension PlanetDetailInfoViewController {
    
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

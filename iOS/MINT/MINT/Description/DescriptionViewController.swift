//
//  DescriptionViewController.swift
//  MINT
//
//  Created by choymoon on 2022/04/08.
//

import UIKit

class DescriptionViewController: UIViewController {

    private let containerScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ic_close"), for: .normal)
        button.tintColor = .lightMain
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .rubikOne(size: 42)
        label.text = "MINT"
        label.textColor = .main
        return label
    }()
    
    private let fullNameLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.medium, size: 20)
        label.textColor = .white
        let bold = UIFont.pretendard(.black, size: 22)
        let attributedText = NSMutableAttributedString(string: "Ministry of INterstellar Trade")
        attributedText.addAttribute(.font, value: bold, range: ("Ministry of INterstellar Trade" as NSString).range(of: "M") )
        attributedText.addAttribute(.font, value: bold, range: ("Ministry of INterstellar Trade" as NSString).range(of: "IN") )
        attributedText.addAttribute(.font, value: bold, range: ("Ministry of INterstellar Trade" as NSString).range(of: "T") )
        attributedText.addAttribute(.foregroundColor, value: UIColor.main!, range: ("Ministry of INterstellar Trade" as NSString).range(of: "M") )
        attributedText.addAttribute(.foregroundColor, value: UIColor.main!, range: ("Ministry of INterstellar Trade" as NSString).range(of: "IN") )
        attributedText.addAttribute(.foregroundColor, value: UIColor.main!, range: ("Ministry of INterstellar Trade" as NSString).range(of: "T") )
        label.attributedText = attributedText
        return label
    }()
    
    private let phraseLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.black, size: 11.5)
        label.text = "Buy and own a planet where future humans can settle!"
        label.textColor = .lightestMain
        return label
    }()
    
    private let askLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.semiBold, size: 16)
        label.textColor = .white
        let bold = UIFont.pretendard(.black, size: 16)
        let attributedText = NSMutableAttributedString(string: "Why MINT?")
        attributedText.addAttribute(.font, value: bold, range: ("Why MINT?" as NSString).range(of: "MINT") )
        attributedText.addAttribute(.foregroundColor, value: UIColor.main!, range: ("Why MINT?" as NSString).range(of: "MINT") )
        label.attributedText = attributedText
        return label
    }()
    
    private let hawingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let hawkingLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.bold, size: 12)
        label.numberOfLines = 0
        label.text = DescriptionContent.hawking.rawValue
        return label
    }()
    
    private let muskImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let muskLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.bold, size: 12)
        label.numberOfLines = 0
        label.text = DescriptionContent.musk.rawValue
        return label
    }()
    
    private let partOneTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.black, size: 16)
        label.numberOfLines = 0
        label.text = "인류의 멸종"
        return label
    }()
    
    private let partOneImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let partOneLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.black, size: 11)
        label.numberOfLines = 0
        label.text = DescriptionContent.partOne.rawValue
        return label
    }()
    
    private let partTwoTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.black, size: 16)
        label.numberOfLines = 0
        label.text = "새로운 거주지 탐사"
        return label
    }()
    
    private let partTwoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let partTwoLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.black, size: 11)
        label.numberOfLines = 0
        label.text = DescriptionContent.partTwo.rawValue
        return label
    }()
    
    private let partThreeTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.black, size: 16)
        label.numberOfLines = 0
        label.text = "다행성 종족"
        return label
    }()
    
    private let partThreeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let partThreeLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.black, size: 11)
        label.numberOfLines = 0
        label.text = DescriptionContent.partThree.rawValue
        return label
    }()
    
    private let partFourTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.black, size: 16)
        label.numberOfLines = 0
        label.text = "51개의 유사 지구"
        return label
    }()
    
    private let partFourImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let partFourLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.black, size: 11)
        label.numberOfLines = 0
        label.text = DescriptionContent.partFour.rawValue
        return label
    }()
    
    private let partFiveImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let partFiveLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.black, size: 11)
        label.numberOfLines = 0
        label.text = DescriptionContent.partFive.rawValue
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.black, size: 11)
        label.numberOfLines = 0
        label.text = DescriptionContent.content.rawValue
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
}

extension DescriptionViewController {
    
    private func configureViews() {
        self.view.backgroundColor = .background
        
        self.view.addSubview(containerScrollView)
        containerScrollView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.left.equalTo(self.view.safeAreaLayoutGuide)
            make.right.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(self.view.safeAreaLayoutGuide).priority(500)
        }
        
        self.view.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(10)
            make.right.equalTo(self.view.safeAreaLayoutGuide).offset(-20)
            make.width.equalTo(45)
            make.height.equalTo(45)
        }
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        
        containerScrollView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(20)
        }
        
        let lineView1 = UIView()
        lineView1.backgroundColor = .darkGray
        lineView1.layer.cornerRadius = 0.5
        containerScrollView.addSubview(lineView1)
        lineView1.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.left.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(1)
        }
        
        containerScrollView.addSubview(fullNameLabel)
        fullNameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalTo(lineView1.snp.bottom).offset(4)
        }
        
        containerScrollView.addSubview(phraseLabel)
        phraseLabel.snp.makeConstraints { make in
            make.top.equalTo(fullNameLabel.snp.bottom).offset(2)
            make.left.equalToSuperview().offset(20)
        }
        
        containerScrollView.addSubview(askLabel)
        askLabel.snp.makeConstraints { make in
            make.top.equalTo(phraseLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        containerScrollView.addSubview(hawingImageView)
        hawingImageView.snp.makeConstraints { make in
            make.top.equalTo(askLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(hawingImageView.snp.width).multipliedBy(0.6)
        }
        hawingImageView.kf.setImage(with: URL(string: "https://www.thedailypost.kr/news/photo/201904/70078_60301_441.jpg"))
        
        containerScrollView.addSubview(hawkingLabel)
        hawkingLabel.snp.makeConstraints { make in
            make.top.equalTo(hawingImageView.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
        }
        
        containerScrollView.addSubview(muskImageView)
        muskImageView.snp.makeConstraints { make in
            make.top.equalTo(hawkingLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(muskImageView.snp.width).multipliedBy(0.6)
        }
        muskImageView.kf.setImage(with: URL(string: "https://cdn.eyesmag.com/content/uploads/posts/2020/12/09/tesla-elon-musk-moves-to-texas-1-5b119051-2c23-449b-b554-7445558ebf62.jpg"))
        
        containerScrollView.addSubview(muskLabel)
        muskLabel.snp.makeConstraints { make in
            make.top.equalTo(muskImageView.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
        }
        
        containerScrollView.addSubview(partOneTitleLabel)
        partOneTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(muskLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        containerScrollView.addSubview(partOneImageView)
        partOneImageView.snp.makeConstraints { make in
            make.top.equalTo(partOneTitleLabel.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(partOneImageView.snp.width).multipliedBy(0.6)
        }
        partOneImageView.kf.setImage(with: URL(string: "https://i.ytimg.com/vi/Eyai5v70akQ/maxresdefault.jpg"))
        
        containerScrollView.addSubview(partOneLabel)
        partOneLabel.snp.makeConstraints { make in
            make.top.equalTo(partOneImageView.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
        }
        
        containerScrollView.addSubview(partTwoTitleLabel)
        partTwoTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(partOneLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        containerScrollView.addSubview(partTwoImageView)
        partTwoImageView.snp.makeConstraints { make in
            make.top.equalTo(partTwoTitleLabel.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(partTwoImageView.snp.width).multipliedBy(0.6)
        }
        partTwoImageView.kf.setImage(with: URL(string: "https://www.sciencetimes.co.kr/wp-content/uploads/2019/12/15.jpg"))
        
        containerScrollView.addSubview(partTwoLabel)
        partTwoLabel.snp.makeConstraints { make in
            make.top.equalTo(partTwoImageView.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
        }
        
        containerScrollView.addSubview(partThreeTitleLabel)
        partThreeTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(partTwoLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        containerScrollView.addSubview(partThreeImageView)
        partThreeImageView.snp.makeConstraints { make in
            make.top.equalTo(partThreeTitleLabel.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(partThreeImageView.snp.width).multipliedBy(0.6)
        }
        partThreeImageView.kf.setImage(with: URL(string: "https://img.principlesofknowledge.kr/images/2017/06/dw.jpg"))
        
        containerScrollView.addSubview(partThreeLabel)
        partThreeLabel.snp.makeConstraints { make in
            make.top.equalTo(partThreeImageView.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
        }
        
        containerScrollView.addSubview(partFourTitleLabel)
        partFourTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(partThreeLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        containerScrollView.addSubview(partFourImageView)
        partFourImageView.snp.makeConstraints { make in
            make.top.equalTo(partFourTitleLabel.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(partFourImageView.snp.width).multipliedBy(0.6)
        }
        partFourImageView.kf.setImage(with: URL(string: "https://cdn.pixabay.com/photo/2018/04/17/14/48/sun-3327664_1280.jpg"))
        
        containerScrollView.addSubview(partFourLabel)
        partFourLabel.snp.makeConstraints { make in
            make.top.equalTo(partFourImageView.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
        }
        
        containerScrollView.addSubview(partFiveImageView)
        partFiveImageView.snp.makeConstraints { make in
            make.top.equalTo(partFourLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(partFiveImageView.snp.width).multipliedBy(0.6)
        }
        partFiveImageView.kf.setImage(with: URL(string: "https://blog.kakaocdn.net/dn/cGnN6m/btqwsHizN3g/lSuiVVfVB1Kh6Z5MhUq0ik/img.jpg"))
        
        containerScrollView.addSubview(partFiveLabel)
        partFiveLabel.snp.makeConstraints { make in
            make.top.equalTo(partFiveImageView.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
        }
        
        containerScrollView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(partFiveLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    @objc private func close() {
        self.dismiss(animated: true, completion: nil)
    }
}

enum DescriptionContent: String {
    case hawking = """
    \"인류 멸망을 원치 않는다면 향후 200년 안에 지구를 떠나야 한다.\"
    - 천재 과학자 스티븐 호킹의 유언
    """
    
    case musk = """
    "언젠가 찾아올 인류 최후의 날의 대안은 우주 문명을 건설하고
    인류가 다행성 거주 종이 되는 것\"
    - 일론 머스크 (민간 우주 탐사 기업 스페이스 X의 CEO)-
    """
    
    case partOne = """
    스티븐 호킹은 인류가 외계 행성에 영구 거주할 수 있도록 지금 준비에
    나서야 한다고 말해왔습니다.
    인류란 존재는 머지않아 멸종에 가까운 대재앙의 희생물이 될 것으로
    판단했기 때문입니다.
    
    대표적 예가 소행성의 충돌 같은 것이지만,
    호킹 박사는 이 외에도 인공지능(AI)과 기후변화, 핵전쟁, 변종 바이러스,
    인구폭발 등도 잠재적 위협이 될 것으로 봤습니다.
    """
    
    case partTwo = """
    2016년 4월, 호킹은 일명 '브레이크스루 스타샷 (Breakthrough
    starshot)'프로젝트를 발표했습니다.
    지구와 가까운 항성계인 프록시마 계와 프록시마 B를 탐사하기 위해
    초소형 우주선을 띄우는 것이 이 프로젝트의 목적입니다.
    
    복사압을 이용하여 광속의 15%~20%의 속도로 2~30년만에 프록시마에
    도달하여 4년에 걸친 탐사를 통해 프록시마의 환경, 생명체 거주 가능성,
    대기 등을 확인하려는 계획을 가지고 있습니다.
    
    이 프로젝트는 NASA에서 진행되어 2036년 발사된다는 구체적인 계획까지
    완성된 상태입니다.
    """
    
    case partThree = """
    최초로 민간 유인 우주 왕복선 발사에 성공한 우주 탐사 기업 스페이스 X의
    CEO 일론 머스크는 '다행성종족'(multi-planetary species)이라는
    개념을 제시했습니다.
    
    다행성 종족이란 여러 행성에 거주하는 생명체를 일컫습니다.
    머스크는 미래와 인류의 지속가능성에 대해 고민하며 인간이 궁극적으로
    다른 행성으로 이주할 수 있는 다행성 종족이 돼야 한다고 강조해왔습니다.
    
    그는 실제로 2030년 경 화성 유인 탐사를 목표로 로켓 개발과
    우주 탐사에 박차를 가하고 있습니다.
    """
    
    case partFour = """
    미국 항공우주국 NASA는 2022년 3월 22일자로 태양계 너머에서 확인된
    외계 행성만 5000개를 넘어섰다고 밝혔습니다.
    
    그 중 인간이 살아갈 수 있는 환경을 지닌 제 2의 지구가 되어줄 '유사 지구'
    후보로 거론되고 있는 외계 행성 역시 현재까지 51개나 되며,
    매일 새롭게 발견되고 있습니다.
    """
    
    case partFive = """
    이처럼 지구는 더이상 유일한 거주지로서의 안정성을 보장해주지 못하고,
    인류는 타행성으로의 이주를 바라보고 있습니다.
    
    빠르게 발달하고 있는 우주 기술은 그리 멀지 않은 시점에
    제 2의 지구로의 이주를 가능하게 할 것으로 기대됩니다.
    """
    
    case content = """
    우주 부동산 거래 플랫폼, MINT
    
    우주 부동산 거래 플랫폼 MINT는 이러한 미래 인류의 행성 이주에 대비해
    여러 유사 지구의 가상 부동산 거래를 중개합니다.
    
    당신은 MINT를 통해 향후 거주하게 될 행성의 토지를 선점할 수 있습니다.
    
    거래는 이더리움(ethereum) 기반의 NFT를 이용해 영구히 기록됩니다.
    
    당신은 해당 토지에 대한 전적인 소유권을 가지게 되며,
    해당 사실을 공적으로 인정받을 수 있습니다.
    
    마음에 드는 토지를 구매하고
    각종 건물 및 시설의 건축 계획을 미리 세워보세요!
    
    
    자료 출처

    https:ko.wikipedia.org/wiki/%EC%8A%A4%ED%83%80%EC%83%B7
    https:youtu.be/IXJnJl_I1XI
    https:www.joongang.co.kr/article/22456045#home
    hhttps:www.sedaily.com/NewsVIew/263K08FUSB
    https:www.hani.co.kr/arti/science/science_general/783860.html
    """
}

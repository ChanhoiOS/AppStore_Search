//
//  DetailView.swift
//  AppStore_KAKAOBANK
//
//  Created by 이찬호 on 2023/03/20.
//

import UIKit
import Then
import SnapKit
import Kingfisher

class DetailView: UIViewController {
    
    var mainScrollView: UIScrollView!
    var infoScrollView: UIScrollView!
    var screenScrollView: UIScrollView!
    var contentView: UIView!
    var infoContentView: UIView!
    var screenContentView: UIView!
    var mainStackView: UIStackView!
    var infoStackView: UIStackView!
    var screenStackView: UIStackView!
    var titleView: UIView!
    var infoView: UIView!
    var infoColumnView: UIView!
    var functionView: UIView!
    var screenView: UIView!
    var screenColumnView: UIView!
    var singleScreenImage: UIImageView!
    var descriptionView: UIView!
    var appIconImageView: UIImageView!
    var appTitle: UILabel!
    var appSubTitle: UILabel!
    var infoTitle: UILabel!
    var infoScoreData: UILabel!
    var previewLabel: UILabel!
    var developer: UIImageView!
    
    var newFunction: UILabel!
    var functionTitle: UILabel!
    var functionSubtitle: UILabel!
    var moreFunction: UIButton!
    
    
    var searchData: SearchResult?
    var infoTitleArr = ["평가", "연령", "차트", "개발자", "언어"]
    var moreDescription = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setMainView()
        setInfolDetailView()
        setScreenDetailView()
    }
    
    func setMainView() {
        setMainScrollView()
        setMainStack()
        setTitleView()
        setInfoView()
        setFunctionView()
        setScreenView()
    }
    
    func setMainScrollView() {
        mainScrollView = UIScrollView()
            .then {
                self.view.addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
                $0.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
                $0.showsVerticalScrollIndicator = false
            }
            .then {
                contentView = UIView()
                $0.addSubview(contentView)
                contentView.translatesAutoresizingMaskIntoConstraints = false
                contentView.snp.makeConstraints { make in
                    make.top.equalToSuperview().offset(-44)
                    make.bottom.equalToSuperview()
                    make.left.right.equalTo(self.view)
                }
            }
    }
    
    func setMainStack() {
        mainStackView = UIStackView()
            .then {
                contentView.addSubview($0)
                $0.axis = .vertical
                $0.spacing = 2
                $0.distribution = .equalSpacing
                $0.isLayoutMarginsRelativeArrangement = true
                
            }
            .then {
                $0.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
            }
    }
    
    func setTitleView() {
        titleView = UIView()
            .then {
                $0.snp.makeConstraints { make in
                    make.height.equalTo(150)
                }
            }.then {
                appIconImageView = UIImageView()
                appIconImageView.layer.cornerRadius = 15
                appIconImageView.layer.masksToBounds = true
                $0.addSubview(appIconImageView)
                appIconImageView.snp.makeConstraints { make in
                    make.top.equalToSuperview().offset(10)
                    make.left.equalToSuperview().offset(30)
                    make.height.width.equalTo(100)
                }
                if let thumbnail = searchData?.artworkUrl100 {
                    appIconImageView.kf.setImage(with: URL(string: thumbnail))
                }
            } .then {
                appTitle = UILabel()
                $0.addSubview(appTitle)
                appTitle.text = searchData?.trackName ?? ""
                appTitle.font = UIFont(name: "Pretendard-Bold", size: 24)
                appTitle.snp.makeConstraints { make in
                    make.left.equalTo(appIconImageView.snp.right).offset(20)
                    make.top.equalToSuperview().offset(10)
                }
            }.then {
                appSubTitle = UILabel()
                $0.addSubview(appSubTitle)
                
                if let genres = searchData?.genres {
                    appSubTitle.text = genres[0]
                }
                appTitle.font = UIFont(name: "Pretendard-Regular", size: 16)
                appSubTitle.textColor = UIColor(red: 139.0/255.0, green: 149.0/255.0, blue: 161.0/255.0, alpha: 1.0)
                appSubTitle.snp.makeConstraints { make in
                    make.left.equalTo(appIconImageView.snp.right).offset(20)
                    make.top.equalTo(appTitle.snp.bottom).offset(10)
                }
            }
           

        mainStackView.addArrangedSubview(titleView)
    }

    func setInfoView() {
        infoView = UIView()
            .then {
                $0.snp.makeConstraints { make in
                    make.height.equalTo(100)
                }
            }
            .then {
                let topGrayView = UIView()
                    
                $0.addSubview(topGrayView)
                topGrayView.backgroundColor = UIColor(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1.0)
                topGrayView.snp.makeConstraints { make in
                    make.left.equalToSuperview().offset(20)
                    make.right.equalToSuperview().offset(-20)
                    make.top.equalToSuperview().offset(1)
                    make.height.equalTo(0.5)
                }
                
                let bottomgrayView = UIView()
                    
                $0.addSubview(bottomgrayView)
                bottomgrayView.backgroundColor = UIColor(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1.0)
                bottomgrayView.snp.makeConstraints { make in
                    make.left.equalToSuperview().offset(20)
                    make.right.equalToSuperview().offset(-20)
                    make.bottom.equalToSuperview().offset(-1)
                    make.height.equalTo(0.5)
                }
            }
        mainStackView.addArrangedSubview(infoView)
    }
    
    func setFunctionView() {
        functionView = UIView()
            .then {
                functionTitle = UILabel()
                functionTitle.text = "새로운 기능"
                $0.addSubview(functionTitle)
               
                functionTitle.font = UIFont(name: "Pretendard-Bold", size: 24)
                
                functionTitle.snp.makeConstraints { make in
                    make.left.equalToSuperview().offset(20)
                    make.top.equalToSuperview().offset(20)
                }
                
                functionSubtitle = UILabel()
                $0.addSubview(functionSubtitle)
                
                let version = searchData?.version ?? ""
                functionSubtitle.text = "버전 " + version
                functionSubtitle.snp.makeConstraints { make in
                    make.left.equalToSuperview().offset(20)
                    make.top.equalTo(functionTitle.snp.bottom).offset(40)
                }
                moreFunction = UIButton()
                $0.addSubview(moreFunction)
                moreFunction.snp.makeConstraints { make in
                    make.top.equalToSuperview().offset(20)
                    make.right.equalToSuperview().offset(-10)
                }
                moreFunction.setTitle("더보기", for: .normal)
                moreFunction.setTitleColor(UIColor.blue, for: .normal)
                moreFunction.addTarget(self, action: #selector(setMoreInfoDescription), for: .touchUpInside)
            }
            .then {
                newFunction = UILabel()
                $0.addSubview(newFunction)
                
                var releaseNotes = searchData?.releaseNotes ?? ""
                if releaseNotes.count > 20 {
                    releaseNotes = "\(releaseNotes.prefix(20))"
                }
                newFunction.text = releaseNotes
                newFunction.numberOfLines = 0
                
                newFunction.snp.makeConstraints { make in
                    make.left.equalToSuperview().offset(20)
                    make.right.equalToSuperview().offset(-20)
                    make.top.equalTo(functionSubtitle.snp.bottom).offset(40)
                    //make.bottom.equalToSuperview().offset(0)
                }
            }
            .then {
                let bottomgrayView = UIView()
                    
                $0.addSubview(bottomgrayView)
                bottomgrayView.backgroundColor = UIColor(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1.0)
                bottomgrayView.snp.makeConstraints { make in
                    make.left.equalToSuperview().offset(20)
                    make.right.equalToSuperview().offset(-20)
                    make.top.equalTo(newFunction.snp.bottom).offset(30)
                    make.bottom.equalToSuperview()
                    make.height.equalTo(0.5)
                }
            }
        
        mainStackView.addArrangedSubview(functionView)
    }
    
    func setScreenView() {
        screenView = UIView()
            .then {
                $0.snp.makeConstraints { make in
                    make.height.equalTo(700)
                }
            }
            .then {
                previewLabel = UILabel()
                $0.addSubview(previewLabel)
                previewLabel.text = "미리보기"
                previewLabel.font = UIFont(name: "Pretendard-Bold", size: 24)
                
                previewLabel.snp.makeConstraints { make in
                    make.left.equalToSuperview().offset(20)
                    make.top.equalToSuperview().offset(20)
                    make.height.equalTo(30)
                }
            }
        mainStackView.addArrangedSubview(screenView)
    }
}

extension DetailView {
    func setInfolDetailView() {
        setInfoScrollView()
        setInfoStackView()
        setInfoColumnView()
    }
    
    func setInfoScrollView() {
        infoScrollView = UIScrollView()
            .then {
                infoView.addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
                $0.snp.makeConstraints { make in
                    make.top.equalToSuperview()
                    make.left.right.equalToSuperview()
                    make.bottom.equalToSuperview()
                }
                $0.showsHorizontalScrollIndicator = false
            }
            .then {
                infoContentView = UIView()
                $0.addSubview(infoContentView)
                infoContentView.translatesAutoresizingMaskIntoConstraints = false
                infoContentView.snp.makeConstraints { make in
                    make.top.bottom.equalToSuperview()
                    make.left.right.equalToSuperview()
                }
            }
    }
    
    func setInfoStackView() {
        infoStackView = UIStackView()
            .then {
                infoContentView.addSubview($0)
                $0.axis = .horizontal
                $0.spacing = 0
                $0.distribution = .equalSpacing
                $0.isLayoutMarginsRelativeArrangement = true
            }
            .then {
                $0.snp.makeConstraints { make in
                    make.top.equalToSuperview()
                    make.left.right.equalToSuperview()
                    make.bottom.equalToSuperview()
                }
            }
    }
    
    func setInfoColumnView() {
        for i in 0..<5 {
            infoColumnView = UIView()
                .then {
                    $0.snp.makeConstraints { make in
                        make.width.equalTo(100)
                    }
                    $0.backgroundColor = .white
                }
                .then {
                    infoTitle = UILabel()
                
                    infoTitle.text = infoTitleArr[i]
                    infoTitle.font = UIFont.systemFont(ofSize: 12)
                    infoTitle.textColor = .gray
                    $0.addSubview(infoTitle)
                    
                    infoTitle.snp.makeConstraints { make in
                        make.centerX.equalToSuperview()
                        make.top.equalToSuperview().offset(20)
                    }
                }.then {
                    infoScoreData = UILabel()
                    infoScoreData.font = UIFont.systemFont(ofSize: 11)
                    $0.addSubview(infoScoreData)
                    
                    if i == 0 {
                        let rating = searchData?.averageUserRating ?? 0
                        let roundRating = round(rating)
                        infoScoreData.text = "\(roundRating)"
                    } else if i == 1 {
                        infoScoreData.text = searchData?.contentAdvisoryRating
                    } else if i == 2 {
                        infoScoreData.text = searchData?.sellerName
                    } else if i == 3 {
                        infoScoreData.isHidden = true
                        developer = UIImageView()
                        $0.addSubview(developer)
                        developer.image = UIImage(named: "person.crop.square")
                        
                        developer.snp.makeConstraints { make in
                            make.centerX.equalToSuperview()
                            make.top.equalTo(infoTitle.snp.bottom).offset(10)
                            make.width.height.equalTo(24)
                        }
                    } else if i == 4 {
                        let language = searchData?.languageCodesISO2A?[0] ?? "KO"
                        infoScoreData.text = language
                    }
                    
                    infoScoreData.snp.makeConstraints { make in
                        make.centerX.equalToSuperview()
                        make.top.equalTo(infoTitle.snp.bottom).offset(10)
                    }
                }
            infoStackView.addArrangedSubview(infoColumnView)
        }
    }
}

extension DetailView {
    func setScreenDetailView() {
        setScreenScrollView()
        setScreenStackView()
        setScreenColumnView()
    }
    
    func setScreenScrollView() {
        screenScrollView = UIScrollView()
            .then {
                screenView.addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
                $0.isPagingEnabled = true
                $0.snp.makeConstraints { make in
                    make.top.equalTo(previewLabel.snp.bottom).offset(20)
                    make.left.right.equalToSuperview()
                    make.bottom.equalToSuperview()
                }
                $0.showsHorizontalScrollIndicator = false
            }
            .then {
                screenContentView = UIView()
                $0.addSubview(screenContentView)
                screenContentView.translatesAutoresizingMaskIntoConstraints = false
                screenContentView.snp.makeConstraints { make in
                    make.top.bottom.equalToSuperview()
                    make.left.right.equalToSuperview()
                }
            }
    }
    
    func setScreenStackView() {
        screenStackView = UIStackView()
            .then {
                screenContentView.addSubview($0)
                $0.axis = .horizontal
                $0.spacing = 2
                $0.distribution = .equalSpacing
                $0.isLayoutMarginsRelativeArrangement = true
            }
            .then {
                $0.snp.makeConstraints { make in
                    make.top.equalToSuperview()
                    make.left.right.equalToSuperview()
                    make.bottom.equalToSuperview()
                }
            }
    }
    
    func setScreenColumnView() {
        let count = searchData?.screenshotUrls?.count ?? 0
        
        for i in 0..<count {
            screenColumnView = UIView()
                .then {
                    $0.snp.makeConstraints { make in
                        make.width.equalTo(250)
                        make.height.equalTo(550)
                    }
                }
                .then {
                    singleScreenImage = UIImageView()
                    singleScreenImage.layer.cornerRadius = 15
                    singleScreenImage.layer.masksToBounds = true
                    $0.addSubview(singleScreenImage)
                    
                    singleScreenImage.snp.makeConstraints { make in
                        make.top.equalToSuperview().offset(20)
                        make.bottom.equalToSuperview()
                        make.left.equalToSuperview().offset(20)
                        make.right.equalToSuperview().offset(-20)
                    }
                    if let screen = searchData?.screenshotUrls {
                        singleScreenImage.kf.setImage(with: URL(string: screen[i]))
                    }
                }
            screenStackView.addArrangedSubview(screenColumnView)
        }
    }
    
    
}

extension DetailView {
   
}


extension DetailView {
    @objc func setMoreInfoDescription() {
        newFunction.text = searchData?.releaseNotes ?? ""
        moreFunction.isHidden = true
    }
}

extension DetailView {
    
}

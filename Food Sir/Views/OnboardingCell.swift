//
//  PageCell.swift
//  Food Sir
//
//  Created by Arvids Gargurnis on 17/04/2018.
//  Copyright © 2018 Arvids Gargurnis. All rights reserved.
//

import UIKit

class OnboardingCell: UICollectionViewCell {
    
    var onboardingScreen: OnboardingScreen? {
        didSet {
            guard let onboardingScreen = onboardingScreen else {
                return
            }
            
            //titleImageView.text = onboardingScreen.onboardHeaderText
            
            let imageName = onboardingScreen.imageName
            let titleImageName = onboardingScreen.onboardTitleImageName
            
            imageView.image = UIImage(named: imageName)
            titleImageView.image = UIImage(named: titleImageName)
            
            let color = UIColor(white: 0.2, alpha: 1)
            let attributedText = NSMutableAttributedString(string: onboardingScreen.onboardHeaderText, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium), NSAttributedStringKey.foregroundColor: color])
            
            attributedText.append(NSAttributedString(string: "\n\n\(onboardingScreen.onboardBodyText)", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: color]))
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            let length = attributedText.string.count
            
            attributedText.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: length))
            
            textView.attributedText = attributedText
        }
    }
    
//    let titleView: UITextView = {
//        let title = UITextView()
//        title.text = "Share"
//        title.textAlignment = .center
//        title.font = UIFont.boldSystemFont(ofSize: 18)
//        title.contentInset = UIEdgeInsetsMake(15, 0, 0, 0)
//        title.isEditable = false
//        title.backgroundColor = .white
//        return title
//    }()
    
    let titleImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "letterS")
        iv.contentMode = .scaleAspectFit
        //iv.clipsToBounds = true
        return iv
    }()
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "page1")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.text = "Sample text for now"
        tv.isEditable = false
        tv.contentInset = UIEdgeInsetsMake(15, 0, 0, 0)
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(imageView)
        addSubview(textView)
        addSubview(titleImageView)
        
        _ = titleImageView.anchor(safeAreaLayoutGuide.topAnchor, left: safeAreaLayoutGuide.leftAnchor, bottom: imageView.topAnchor, right: safeAreaLayoutGuide.rightAnchor, topConstant: 5, leftConstant: 0, bottomConstant: 5, rightConstant: 0, widthConstant: 0, heightConstant: 30)
        
        _ = imageView.anchor(titleImageView.bottomAnchor, left: safeAreaLayoutGuide.leftAnchor, bottom: textView.topAnchor, right: safeAreaLayoutGuide.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        _ = textView.anchor(nil, left: safeAreaLayoutGuide.leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: safeAreaLayoutGuide.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 170)
        
//        addConstraintsWithFormat(format: "H:|[v0]|", views: titleView)
//        addConstraintsWithFormat(format: "V:|[v0(60)][v1][v2(160)]|", views: titleView, imageView, textView)
//        addConstraintsWithFormat(format: "H:|[v0]|", views: imageView)
//        addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: textView)
        
    }
    
}

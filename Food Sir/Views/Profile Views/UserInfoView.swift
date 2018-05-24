//
//  UserInfoView.swift
//  Food Sir
//
//  Created by Arvids Gargurnis on 22/05/2018.
//  Copyright © 2018 Arvids Gargurnis. All rights reserved.
//

import UIKit

class UserInfoView: UIView {
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "profilePic")
        iv.layer.cornerRadius = 50
        iv.layer.masksToBounds = true
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let profileNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .left
        
        let attributedText = NSMutableAttributedString(string: "Arvids Gargurnis", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18)])
        attributedText.append(NSAttributedString(string: "\n Plymouth, Uk", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.rgb(red: 155, green: 161, blue: 171)]))
        
        label.attributedText = attributedText
        
        return label
    }()
    
    let postCountLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        
        let attributedText = NSMutableAttributedString(string: "100", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18)])
        attributedText.append(NSAttributedString(string: "\n Posts", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.rgb(red: 155, green: 161, blue: 171)]))
        
        label.attributedText = attributedText
        
        return label
    }()
    
    let placeCountLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        
        let attributedText = NSMutableAttributedString(string: "6", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18)])
        attributedText.append(NSAttributedString(string: "\n Places", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.rgb(red: 155, green: 161, blue: 171)]))
        
        label.attributedText = attributedText
        
        return label
    }()
    
    let badgeCountLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        
        let attributedText = NSMutableAttributedString(string: "9", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18)])
        attributedText.append(NSAttributedString(string: "\n Badges", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.rgb(red: 155, green: 161, blue: 171)]))
        
        label.attributedText = attributedText
        
        return label
    }()
    
    let followerCountLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        
        let attributedText = NSMutableAttributedString(string: "47", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 20)])
        attributedText.append(NSAttributedString(string: "\n Followers", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16), NSAttributedStringKey.foregroundColor: UIColor.rgb(red: 155, green: 161, blue: 171)]))
        
        label.attributedText = attributedText
        
        return label
    }()
    
    let labelStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        return sv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .appGray
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(profileImageView)
        addSubview(profileNameLabel)
        addSubview(labelStackView)
        labelStackView.addArrangedSubview(postCountLabel)
        labelStackView.addArrangedSubview(placeCountLabel)
        labelStackView.addArrangedSubview(badgeCountLabel)
        labelStackView.addArrangedSubview(followerCountLabel)
        
        _ = profileImageView.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, topConstant: 20, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 100, heightConstant: 100)
        
        _ = profileNameLabel.anchor(self.topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: nil, topConstant: 10, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 500, heightConstant: 100)
        
        _ = labelStackView.anchor(profileImageView.bottomAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 10, leftConstant: 5, bottomConstant: 10, rightConstant: 10, widthConstant: 0, heightConstant: 0)
        
    }
    
}

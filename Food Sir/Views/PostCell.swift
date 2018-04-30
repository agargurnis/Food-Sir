//
//  PostCell.swift
//  Food Sir
//
//  Created by Arvids Gargurnis on 29/04/2018.
//  Copyright © 2018 Arvids Gargurnis. All rights reserved.
//

import UIKit

class PostCell: UICollectionViewCell {
    
    var inspirationController: InspirationController?
    
    var post: Post? {
        didSet {
            if let name = post?.profileName, let userLocation = post?.userLocation {
                let attributedText = NSMutableAttributedString(string: name, attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
                attributedText.append(NSAttributedString(string: "\n\(userLocation)", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12), NSAttributedStringKey.foregroundColor: UIColor.rgb(red: 155, green: 161, blue: 171)]))
                profileNameLabel.attributedText = attributedText
            }
            
            if let descriptionText = post?.postDescriptionText {
                descriptionTextView.text = descriptionText
            }
            if let profileImageName = post?.profileImageName {
                profileImageView.image = UIImage(named: profileImageName)
            }
            if let postImageName = post?.postImageName {
                postImageView.image = UIImage(named: postImageName)
            }
            if let numberOfLikes = post?.numberOfLikes {
                likeLabel.text = String(numberOfLikes)
            }
            if let numberOfComments = post?.numberOfComments {
                commentLabel.text = String(numberOfComments)
            }
            if let numberOfShares = post?.numberOfShares {
                shareLabel.text = String(numberOfShares)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let postBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let profileNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .right
        //label.backgroundColor = .blue
        return label
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "loginCarrot")
        imageView.layer.cornerRadius = 25
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let descriptionTextView: UITextView = {
        let textView = UITextView()
        //textView.backgroundColor = .red
        textView.text = "Eating some fresh salmon that got caught only a few hours ago. #Scotland "
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.isScrollEnabled = false
        return textView
    }()
    
    let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "salmon")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let likeLabel: UILabel = {
        let label = UILabel()
        label.text = "32K"
        label.font = UIFont.systemFont(ofSize: 10)
        //label.textColor = UIColor.rgb(red: 155, green: 161, blue: 171)
        return label
    }()
    
    let commentLabel: UILabel = {
        let label = UILabel()
        label.text = "522"
        label.font = UIFont.systemFont(ofSize: 10)
        //label.textColor = UIColor.rgb(red: 155, green: 161, blue: 171)
        return label
    }()
    
    let shareLabel: UILabel = {
        let label = UILabel()
        label.text = "2k"
        label.font = UIFont.systemFont(ofSize: 10)
        //label.textColor = UIColor.rgb(red: 155, green: 161, blue: 171)
        return label
    }()
    // the 2 below probably should be in a stack view
    let buttonContainer: UIView = {
        let view = UIView()
        //view.backgroundColor = .lightGray
        return view
    }()
    
    let profileContainer: UIView = {
        let view = UIView()
        //view.backgroundColor = .red
        return view
    }()
    
    lazy var likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "blankBulb"), for: .normal)
        button.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        return button
    }()

    let commentButton: UIButton = PostCell.buttonForTitle(imageName: "commentCloud")
    let shareButton: UIButton = PostCell.buttonForTitle(imageName: "friendShare")
    
    static func buttonForTitle(imageName: String) -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(named: imageName), for: .normal)
        return button
    }
    
    @objc func handleLike() {
        likeButton.setImage(UIImage(named: "bulbOn"), for: .normal)
    }
    
    func setupViews() {
        
        addSubview(postBackgroundView)
        addSubview(descriptionTextView)
        addSubview(postImageView)
        addSubview(profileContainer)
        profileContainer.addSubview(profileNameLabel)
        profileContainer.addSubview(profileImageView)
        addSubview(buttonContainer)
        buttonContainer.addSubview(likeButton)
        buttonContainer.addSubview(likeLabel)
        buttonContainer.addSubview(commentButton)
        buttonContainer.addSubview(commentLabel)
        buttonContainer.addSubview(shareButton)
        buttonContainer.addSubview(shareLabel)
    
        _ = postBackgroundView.anchor(safeAreaLayoutGuide.topAnchor, left: safeAreaLayoutGuide.leftAnchor, bottom: nil, right: safeAreaLayoutGuide.rightAnchor, topConstant: -37, leftConstant: 5, bottomConstant: 0, rightConstant: 5, widthConstant: 0, heightConstant: 400)
        
        _ = descriptionTextView.anchor(postBackgroundView.topAnchor, left: postBackgroundView.leftAnchor, bottom: nil, right: postBackgroundView.rightAnchor, topConstant: 5, leftConstant: 5, bottomConstant: 5, rightConstant: 5, widthConstant: 0, heightConstant: 50)
        
        _ = postImageView.anchor(descriptionTextView.topAnchor, left: postBackgroundView.leftAnchor, bottom: nil, right: postBackgroundView.rightAnchor, topConstant: 55, leftConstant: 10, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 280)
        
        _ = profileContainer.anchor(postImageView.bottomAnchor, left: buttonContainer.rightAnchor, bottom: nil, right: postBackgroundView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 60)
        
        _ = profileImageView.anchor(profileContainer.topAnchor, left: nil, bottom: profileContainer.bottomAnchor, right: profileContainer.rightAnchor, topConstant: 5, leftConstant: 0, bottomConstant: 5, rightConstant: 0, widthConstant: 50, heightConstant: 0)
        
        _ = profileNameLabel.anchor(profileContainer.topAnchor, left: profileContainer.leftAnchor, bottom: profileContainer.bottomAnchor, right: profileImageView.leftAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 5, widthConstant: 0, heightConstant: 0)
        
        _ = buttonContainer.anchor(postImageView.bottomAnchor, left: postBackgroundView.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 120, heightConstant: 60)
        
        _ = likeLabel.anchor(likeButton.centerYAnchor, left: likeButton.centerXAnchor, bottom: nil, right: nil, topConstant: -30, leftConstant: -9, bottomConstant: 0, rightConstant: 0, widthConstant: 36, heightConstant: 0)
        
        _ = likeButton.anchor(buttonContainer.topAnchor, left: buttonContainer.leftAnchor, bottom: buttonContainer.bottomAnchor, right: nil, topConstant: 17, leftConstant: 3, bottomConstant: 7, rightConstant: 0, widthConstant: 36, heightConstant: 0)
        
        _ = commentLabel.anchor(commentButton.centerYAnchor, left: commentButton.centerXAnchor, bottom: nil, right: nil, topConstant: -30, leftConstant: -9, bottomConstant: 0, rightConstant: 0, widthConstant: 36, heightConstant: 0)
        
        _ = commentButton.anchor(buttonContainer.topAnchor, left: likeButton.rightAnchor, bottom: buttonContainer.bottomAnchor, right: nil, topConstant: 17, leftConstant: 3, bottomConstant: 7, rightConstant: 0, widthConstant: 36, heightConstant: 0)
        
        _ = shareLabel.anchor(shareButton.centerYAnchor, left: shareButton.centerXAnchor, bottom: nil, right: nil, topConstant: -28, leftConstant: -4, bottomConstant: 0, rightConstant: 0, widthConstant: 36, heightConstant: 0)
        
        _ = shareButton.anchor(buttonContainer.topAnchor, left: commentButton.rightAnchor, bottom: buttonContainer.bottomAnchor, right: nil, topConstant: 15, leftConstant: 3, bottomConstant: 7, rightConstant: 0, widthConstant: 38, heightConstant: 0)
    }
    
    
}

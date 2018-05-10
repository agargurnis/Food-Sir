//
//  ImageCell.swift
//  Food Sir
//
//  Created by Arvids Gargurnis on 02/05/2018.
//  Copyright © 2018 Arvids Gargurnis. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {
    
    weak var delegate: PostCellDelegte?
    
    var descriptionTextHeight: NSLayoutConstraint?
    
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
        return label
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "loginCarrot")
        imageView.layer.cornerRadius = 22
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Eating some fresh salmon that got caught only a few hours ago. #Scotland "
        textView.font = UIFont.systemFont(ofSize: 13)
        textView.sizeToFit()
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
    
    let imageShadowView: UIView = {
        let shadowView = UIView()
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowRadius = 2
        shadowView.layer.shadowOpacity = 0.6
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 3)
        return shadowView
    }()
    
    let profileShadowView: UIView = {
        let shadowView = UIView()
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowRadius = 2
        shadowView.layer.shadowOpacity = 0.6
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 1)
        return shadowView
    }()
    
    let likeButtonLabel: UILabel = {
        let label = UILabel()
        label.text = "32K"
        label.font = UIFont.systemFont(ofSize: 8)
        return label
    }()
    
    let commentButtonLabel: UILabel = {
        let label = UILabel()
        label.text = "522"
        label.font = UIFont.systemFont(ofSize: 8)
        return label
    }()
    
    let groceryButtonLabel: UILabel = {
        let label = UILabel()
        label.text = "2k"
        label.font = UIFont.systemFont(ofSize: 8)
        return label
    }()
    
    let buttonContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    let profileContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "blankBulbOff"), for: .normal)
        button.addTarget(self, action: #selector(handleLikeButton), for: .touchUpInside)
        return button
    }()
    
    lazy var commentButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "blankCommentCloud"), for: .normal)
        button.addTarget(self, action: #selector(handleCommentButton), for: .touchUpInside)
        return button
    }()
    
    lazy var groceryButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "recipeList"), for: .normal)
        button.addTarget(self, action: #selector(handleGroceryButton), for: .touchUpInside)
        return button
    }()
    
    @objc func handleLikeButton() {
        likeButton.setImage(UIImage(named: "blankBulbOn"), for: .normal)
    }
    
    @objc func handleCommentButton() {
        delegate?.scrollToCell(cellIndex: 0)
    }

    @objc func handleGroceryButton() {
        delegate?.scrollToCell(cellIndex: 2)
    }
    
    func setupViews() {
        
        addSubview(postBackgroundView)
        addSubview(descriptionTextView)
        addSubview(profileContainer)
        addSubview(profileShadowView)
        profileShadowView.addSubview(profileImageView)
        profileContainer.addSubview(profileNameLabel)
        profileContainer.addSubview(profileShadowView)
        addSubview(buttonContainer)
        buttonContainer.addSubview(likeButton)
        buttonContainer.addSubview(likeButtonLabel)
        buttonContainer.addSubview(commentButton)
        buttonContainer.addSubview(commentButtonLabel)
        buttonContainer.addSubview(groceryButton)
        buttonContainer.addSubview(groceryButtonLabel)
        addSubview(imageShadowView)
        imageShadowView.addSubview(postImageView)
        
        // round corners on input textfields
        
        
        _ = postBackgroundView.anchor(safeAreaLayoutGuide.topAnchor, left: safeAreaLayoutGuide.leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: safeAreaLayoutGuide.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        _ = descriptionTextView.anchor(postBackgroundView.topAnchor, left: postBackgroundView.leftAnchor, bottom: nil, right: postBackgroundView.rightAnchor, topConstant: 5, leftConstant: 10, bottomConstant: 5, rightConstant: 10, widthConstant: 0, heightConstant: 0)
        
        _ = imageShadowView.anchor(descriptionTextView.bottomAnchor, left: postBackgroundView.leftAnchor, bottom: nil, right: postBackgroundView.rightAnchor, topConstant: 5, leftConstant: 15, bottomConstant: 0, rightConstant: 15, widthConstant: 0, heightConstant: 280)
        
        _ = postImageView.anchor(descriptionTextView.bottomAnchor, left: postBackgroundView.leftAnchor, bottom: nil, right: postBackgroundView.rightAnchor, topConstant: 5, leftConstant: 15, bottomConstant: 0, rightConstant: 15, widthConstant: 0, heightConstant: 280)
        
        _ = profileContainer.anchor(postImageView.bottomAnchor, left: buttonContainer.rightAnchor, bottom: nil, right: postBackgroundView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 15, widthConstant: 0, heightConstant: 60)
        
        _ = profileShadowView.anchor(profileContainer.topAnchor, left: nil, bottom: profileContainer.bottomAnchor, right: profileContainer.rightAnchor, topConstant: 8, leftConstant: 0, bottomConstant: 8, rightConstant: 0, widthConstant: 44, heightConstant: 0)
        
        _ = profileImageView.anchor(profileContainer.topAnchor, left: nil, bottom: profileContainer.bottomAnchor, right: profileContainer.rightAnchor, topConstant: 8, leftConstant: 0, bottomConstant: 8, rightConstant: 0, widthConstant: 44, heightConstant: 0)
        
        _ = profileNameLabel.anchor(profileContainer.topAnchor, left: profileContainer.leftAnchor, bottom: profileContainer.bottomAnchor, right: profileImageView.leftAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 5, widthConstant: 0, heightConstant: 0)
        
        _ = buttonContainer.anchor(postImageView.bottomAnchor, left: postBackgroundView.leftAnchor, bottom: nil, right: nil, topConstant: 3, leftConstant: 15, bottomConstant: 0, rightConstant: 0, widthConstant: 120, heightConstant: 60)
        
        _ = likeButtonLabel.anchor(likeButton.centerYAnchor, left: likeButton.centerXAnchor, bottom: nil, right: nil, topConstant: -26, leftConstant: -3, bottomConstant: 0, rightConstant: 0, widthConstant: 32, heightConstant: 0)
        
        _ = likeButton.anchor(buttonContainer.topAnchor, left: buttonContainer.leftAnchor, bottom: buttonContainer.bottomAnchor, right: nil, topConstant: 16, leftConstant: 7, bottomConstant: 14, rightConstant: 0, widthConstant: 25, heightConstant: 0)
        
        _ = commentButtonLabel.anchor(commentButton.centerYAnchor, left: commentButton.centerXAnchor, bottom: nil, right: nil, topConstant: -26, leftConstant: -1, bottomConstant: 0, rightConstant: 0, widthConstant: 32, heightConstant: 0)
        
        _ = commentButton.anchor(buttonContainer.topAnchor, left: likeButton.rightAnchor, bottom: buttonContainer.bottomAnchor, right: nil, topConstant: 18, leftConstant: 11, bottomConstant: 15, rightConstant: 0, widthConstant: 27, heightConstant: 0)
        
        _ = groceryButtonLabel.anchor(groceryButton.centerYAnchor, left: groceryButton.centerXAnchor, bottom: nil, right: nil, topConstant: -26, leftConstant: -1, bottomConstant: 0, rightConstant: 0, widthConstant: 32, heightConstant: 0)
        
        _ = groceryButton.anchor(buttonContainer.topAnchor, left: commentButton.rightAnchor, bottom: buttonContainer.bottomAnchor, right: nil, topConstant: 16, leftConstant: 12, bottomConstant: 14, rightConstant: 0, widthConstant: 25, heightConstant: 0)
    }
    
}

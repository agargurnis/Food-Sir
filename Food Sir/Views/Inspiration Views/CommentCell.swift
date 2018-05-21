//
//  CommentCell.swift
//  Food Sir
//
//  Created by Arvids Gargurnis on 05/05/2018.
//  Copyright © 2018 Arvids Gargurnis. All rights reserved.
//

import UIKit

class CommentCell: UICollectionViewCell {
    
    var bubbleWidthAnchor: NSLayoutConstraint?
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.text = "Comments"
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.backgroundColor = .clear
        tv.textColor = .black
        tv.isEditable = false
        return tv
    }()
    
    let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = .appGray
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profilePic")
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(bubbleView)
        bubbleView.addSubview(textView)
        addSubview(profileImageView)
        
        _ = bubbleView.anchor(self.topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 5, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 300)
        bubbleWidthAnchor?.isActive = true
        
        _ = textView.anchor(bubbleView.topAnchor, left: bubbleView.leftAnchor, bottom: nil, right: bubbleView.rightAnchor, topConstant: 0, leftConstant: 5, bottomConstant: 0, rightConstant: 5, widthConstant: 0, heightConstant: 0)
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        _ = profileImageView.anchor(nil, left: self.leftAnchor, bottom: self.bottomAnchor, right: nil, topConstant: 0, leftConstant: 5, bottomConstant: 2, rightConstant: 0, widthConstant: 32, heightConstant: 32)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

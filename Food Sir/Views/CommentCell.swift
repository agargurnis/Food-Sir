//
//  CommentCell.swift
//  Food Sir
//
//  Created by Arvids Gargurnis on 02/05/2018.
//  Copyright © 2018 Arvids Gargurnis. All rights reserved.
//

import UIKit

class CommentCell: UICollectionViewCell, UITextFieldDelegate {
    
    weak var delegate: InspirationControllerDelegte?
    
    var commentCellController: CommentCellController?
    
    let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.setTitleColor(.appOrange, for: .normal)
        return button
    }()
    
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter comment..."
        textField.borderStyle = .roundedRect
        textField.delegate = self
        textField.backgroundColor = .white
        return textField
    }()
    
    let bottomSeperatorLine: UIView = {
        let seperatorLine = UIView()
        seperatorLine.backgroundColor = UIColor.rgb(red: 220, green: 220, blue: 220)
        return seperatorLine
    }()
    
    let topSeperatorLine: UIView = {
        let seperatorLine = UIView()
        seperatorLine.backgroundColor = UIColor.rgb(red: 220, green: 220, blue: 220)
        return seperatorLine
    }()
    
    let titleView: UITextView = {
        let tv = UITextView()
        tv.text = "Comments"
        tv.textAlignment = .center
        tv.font = UIFont.boldSystemFont(ofSize: 16)
        tv.backgroundColor = .clear
        tv.textColor = .black
        tv.isEditable = false
        return tv
    }()
    
    let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(bubbleView)
        bubbleView.addSubview(inputTextField)
        inputTextField.addSubview(sendButton)
        bubbleView.addSubview(bottomSeperatorLine)
        bubbleView.addSubview(topSeperatorLine)
        bubbleView.addSubview(titleView)
        
        _ = bubbleView.anchor(safeAreaLayoutGuide.topAnchor, left: safeAreaLayoutGuide.leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: safeAreaLayoutGuide.rightAnchor, topConstant: 0, leftConstant: 5, bottomConstant: 0, rightConstant: 5, widthConstant: 0, heightConstant: 0)
        
        _ = inputTextField.anchor(nil, left: bubbleView.leftAnchor, bottom: bubbleView.bottomAnchor, right: bubbleView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 40)
        
        _ = sendButton.anchor(inputTextField.topAnchor, left: nil, bottom: inputTextField.bottomAnchor, right: inputTextField.rightAnchor, topConstant: 2, leftConstant: 0, bottomConstant: 2, rightConstant: 5, widthConstant: 50, heightConstant: 0)
        
        _ = bottomSeperatorLine.anchor(nil, left: safeAreaLayoutGuide.leftAnchor, bottom: inputTextField.topAnchor, right: safeAreaLayoutGuide.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        
        _ = titleView.anchor(bubbleView.topAnchor, left: bubbleView.leftAnchor, bottom: nil, right: bubbleView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 30)
        
        _ = topSeperatorLine.anchor(titleView.bottomAnchor, left: bubbleView.leftAnchor, bottom: nil, right: bubbleView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

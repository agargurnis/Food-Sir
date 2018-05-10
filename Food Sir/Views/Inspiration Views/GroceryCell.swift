//
//  GroceryCell.swift
//  Food Sir
//
//  Created by Arvids Gargurnis on 02/05/2018.
//  Copyright © 2018 Arvids Gargurnis. All rights reserved.
//

import UIKit

class GroceryCell: UICollectionViewCell {
    
    let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    let topSeperatorLine: UIView = {
        let seperatorLine = UIView()
        seperatorLine.backgroundColor = UIColor.rgb(red: 220, green: 220, blue: 220)
        return seperatorLine
    }()
    
    let titleView: UITextView = {
        let tv = UITextView()
        tv.text = "Ingredient List"
        tv.textAlignment = .center
        tv.font = UIFont.boldSystemFont(ofSize: 16)
        tv.backgroundColor = .clear
        tv.textColor = .black
        tv.isEditable = false
        return tv
    }()
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.text = "1 Kg of tomatoes"
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.backgroundColor = .clear
        tv.textColor = .white
        tv.isEditable = false
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(bubbleView)
        bubbleView.addSubview(textView)
        bubbleView.addSubview(titleView)
        bubbleView.addSubview(topSeperatorLine)
        
        _ = bubbleView.anchor(safeAreaLayoutGuide.topAnchor, left: safeAreaLayoutGuide.leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: safeAreaLayoutGuide.rightAnchor, topConstant: 0, leftConstant: 5, bottomConstant: 0, rightConstant: 5, widthConstant: 0, heightConstant: 0)
        
        _ = textView.anchor(bubbleView.topAnchor, left: bubbleView.leftAnchor, bottom: bubbleView.bottomAnchor, right: bubbleView.rightAnchor, topConstant: 10, leftConstant: 20, bottomConstant: 10, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        
        _ = titleView.anchor(bubbleView.topAnchor, left: bubbleView.leftAnchor, bottom: nil, right: bubbleView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 30)
        
        _ = topSeperatorLine.anchor(titleView.bottomAnchor, left: bubbleView.leftAnchor, bottom: nil, right: bubbleView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

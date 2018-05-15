//
//  CommentViewCell.swift
//  Food Sir
//
//  Created by Arvids Gargurnis on 05/05/2018.
//  Copyright © 2018 Arvids Gargurnis. All rights reserved.
//

import UIKit
import Firebase

class CommentViewCell: UICollectionViewCell, UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    weak var delegate: PostCellDelegte?
    
    var postId: String?
    var comments = [Comment]()
    let commentCellId = "commentCellId"
    var postComments: [String: AnyObject]?
    
    lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.setTitleColor(.appOrange, for: .normal)
        button.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        return button
    }()
    
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter comment..."
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
        tv.isUserInteractionEnabled = false
        tv.textAlignment = .center
        tv.font = UIFont.boldSystemFont(ofSize: 16)
        tv.backgroundColor = .clear
        tv.textColor = .black
        tv.isEditable = false
        return tv
    }()
    
    lazy var commentCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        cv.contentInset = UIEdgeInsetsMake(8, 0, 8, 0)
        return cv
    }()
    
    let commentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = false
        return view
    }()
    
    @objc func handleSend() {
        if let postID = postId {
            let ref = Database.database().reference().child("posts").child(postID).child("comments")
            let childRef = ref.childByAutoId()
            let userId = Auth.auth().currentUser!.uid
            let timestamp: Double = Double(NSDate().timeIntervalSince1970)
            
            let userRef = Database.database().reference().child("users").child(userId)
            userRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    if let userProfileImageUrl = dictionary["profileImageUrl"] as? String {
                        let values: [String: Any] = ["text": self.inputTextField.text!, "userId": userId, "timestamp": timestamp, "userProfileImageUrl": userProfileImageUrl]
                        
                        childRef.updateChildValues(values)
                        self.inputTextField.text = nil
                    }
                }
            }, withCancel: nil)
            
            DispatchQueue.main.async {
                self.delegate?.updateLabels(forPost: postID)
            }
        }
    }
    
    func observeComments(forPost: String) {
        let ref = Database.database().reference().child("posts").child(forPost).child("comments")
        ref.observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let comment = Comment()
                comment.userId = dictionary["userId"] as? String
                comment.text = dictionary["text"] as? String
                comment.timestamp = dictionary["timestamp"] as? Double
                comment.userProfileImageUrl = dictionary["userProfileImageUrl"] as? String

                self.comments.append(comment)

                DispatchQueue.main.async {
                    self.commentCollectionView.reloadData()
                }
            }

        }, withCancel: nil)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commentCollectionView.register(CommentCell.self, forCellWithReuseIdentifier: commentCellId)
        
        addSubview(commentView)
        commentView.addSubview(inputTextField)
        commentView.addSubview(sendButton)
        commentView.addSubview(bottomSeperatorLine)
        commentView.addSubview(topSeperatorLine)
        commentView.addSubview(titleView)
        commentView.addSubview(commentCollectionView)
        
        _ = commentView.anchor(safeAreaLayoutGuide.topAnchor, left: safeAreaLayoutGuide.leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: safeAreaLayoutGuide.rightAnchor, topConstant: 0, leftConstant: 5, bottomConstant: 0, rightConstant: 5, widthConstant: 0, heightConstant: 0)
        
        _ = inputTextField.anchor(nil, left: commentView.leftAnchor, bottom: commentView.bottomAnchor, right: sendButton.leftAnchor, topConstant: 0, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 40)
        
        _ = sendButton.anchor(bottomSeperatorLine.bottomAnchor, left: nil, bottom: commentView.bottomAnchor, right: commentView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 5, widthConstant: 50, heightConstant: 0)
        
        _ = bottomSeperatorLine.anchor(nil, left: safeAreaLayoutGuide.leftAnchor, bottom: inputTextField.topAnchor, right: safeAreaLayoutGuide.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        
        _ = titleView.anchor(commentView.topAnchor, left: commentView.leftAnchor, bottom: nil, right: commentView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 30)
        
        _ = topSeperatorLine.anchor(titleView.bottomAnchor, left: commentView.leftAnchor, bottom: nil, right: commentView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        
        _ = commentCollectionView.anchor(topSeperatorLine.bottomAnchor, left: commentView.leftAnchor, bottom: bottomSeperatorLine.topAnchor, right: commentView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        DispatchQueue.main.async {
            if let postID = self.postId {
                self.observeComments(forPost: postID)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: commentCellId, for: indexPath) as! CommentCell
        let comment = comments[indexPath.item]
        if let commentText = comment.text, let commentPictureUrl = comment.userProfileImageUrl {
            cell.textView.text = commentText
            cell.bubbleWidthAnchor?.constant = estimateFrameForText(text: commentText).width + 32
            cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: commentPictureUrl)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        
        if let text = comments[indexPath.item].text {
            height = estimateFrameForText(text: text).height + 20
        }
        
        return CGSize(width: frame.width - 10, height: floor(height))
    }
    
    func estimateFrameForText(text: String) -> CGRect {
        let size = CGSize(width: frame.width - 95, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

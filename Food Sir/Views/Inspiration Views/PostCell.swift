//
//  PostCell.swift
//  Food Sir
//
//  Created by Arvids Gargurnis on 29/04/2018.
//  Copyright © 2018 Arvids Gargurnis. All rights reserved.
//

import UIKit
import Firebase

protocol PostCellDelegte: class {
    func scrollToCell(cellIndex: Int)
    func updateLabels(forPost: String)
}

class PostCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, PostCellDelegte {
    
    var cellId = "cellId"
    var imageCellId = "imageCellId"
    var commentViewCellId = "commentViewCellId"
    var groceryCellId = "groceryCellId"
    var user: User?
    
    var commentViewCell: CommentViewCell = {
        let cell = CommentViewCell()
        return cell
    }()
    
    var imageCell: ImageCell = {
        let cell = ImageCell()
        return cell
    }()
    
    var groceryCell: GroceryCell = {
        let cell = GroceryCell()
        return cell
    }()
    
    var inspirationController: InspirationController?
    
    var post: Post? {
        didSet {
            self.postCollectionView.reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    lazy var postCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.isPagingEnabled = true
        return cv
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func scrollToCell(cellIndex: Int) {
        DispatchQueue.main.async {
            let cellsIndex = NSIndexPath(item: cellIndex, section: 0)
            self.postCollectionView.scrollToItem(at: cellsIndex as IndexPath, at: [], animated: true)
            self.postCollectionView.layoutIfNeeded()
        }
    }
    
    func updateLabels(forPost: String) {
        let ref = Database.database().reference().child("posts").child(forPost)
        ref.observe(.value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                if let likeCount = dictionary["likes"] as? [String] {
                    self.imageCell.likeButtonLabel.text = String(likeCount.count)
                    //print(likeCount.count)
                } else {
                    self.imageCell.likeButtonLabel.text = "0"
                }
                if let commentCount = dictionary["comments"] as? [String: AnyObject] {
                    self.imageCell.commentButtonLabel.text = String(commentCount.count)
                    //print(commentCount.count)
                } else {
                    self.imageCell.commentButtonLabel.text = "0"
                }
            }
        }, withCancel: nil)
    }
    
    func setupViews() {
        
        addSubview(postCollectionView)
        
        postCollectionView.register(CommentViewCell.self, forCellWithReuseIdentifier: commentViewCellId)
        postCollectionView.register(ImageCell.self, forCellWithReuseIdentifier: imageCellId)
        postCollectionView.register(GroceryCell.self, forCellWithReuseIdentifier: groceryCellId)
        
        postCollectionView.dataSource = self
        postCollectionView.delegate = self
        
        _ = postCollectionView.anchor(safeAreaLayoutGuide.topAnchor, left: safeAreaLayoutGuide.leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: safeAreaLayoutGuide.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        DispatchQueue.main.async {
            let startingIndex = NSIndexPath(item: 1, section: 0)
            self.postCollectionView.scrollToItem(at: startingIndex as IndexPath, at: [], animated: false)
            self.postCollectionView.layoutIfNeeded()
        }
    }
    
    func setupImageCell() {
        if let name = self.post?.userName, let userLocation = self.post?.userLocation {
            let attributedText = NSMutableAttributedString(string: name, attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 12)])
            attributedText.append(NSAttributedString(string: "\n\(userLocation)", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 10), NSAttributedStringKey.foregroundColor: UIColor.rgb(red: 155, green: 161, blue: 171)]))
            self.imageCell.profileNameLabel.attributedText = attributedText
        }
        if let postId = self.post?.postId {
            self.imageCell.postId = postId
        }
        if let descriptionText = self.post?.postDescriptionText {
            self.imageCell.descriptionTextView.text = descriptionText
        }
        if let userProfileImageUrl = self.post?.userProfileImageUrl {
            self.imageCell.profileImageView.loadImageUsingCacheWithUrlString(urlString: userProfileImageUrl)
        }
        if let postImageUrl = self.post?.postImageUrl {
            self.imageCell.postImageView.loadImageUsingCacheWithUrlString(urlString: postImageUrl)
        }
        if let likeCount = self.post?.likes?.count {
            self.imageCell.likeButtonLabel.text = String(likeCount)
        } else {
            self.imageCell.likeButtonLabel.text = "0"
        }
        if let commentCount = self.post?.comments?.count {
            self.imageCell.commentButtonLabel.text = String(commentCount)
        } else {
            self.imageCell.commentButtonLabel.text = "0"
        }
        if let numberOfItems = self.post?.ingredientList?.count {
            self.imageCell.groceryButtonLabel.text = String(numberOfItems)
        }
        if let likesArray = self.post?.likes {
            self.imageCell.likes = likesArray
        }
    }
    
    func setupGroceryCell() {
        if let postId = self.post?.postId {
            self.groceryCell.postId = postId
        }
        if let itemList = self.post?.ingredientList {
            self.groceryCell.listLabel.attributedText = self.groceryCell.createBulletedList(fromStringArray: itemList, font: UIFont.systemFont(ofSize: 16))
        }
    }
    
    func setupCommentViewCell() {
        if let postId = self.post?.postId {
            self.commentViewCell.postId = postId
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            commentViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: commentViewCellId, for: indexPath) as! CommentViewCell
            setupCommentViewCell()
            commentViewCell.delegate = self
            return commentViewCell
        } else if indexPath.item == 1 {
            imageCell = collectionView.dequeueReusableCell(withReuseIdentifier: imageCellId, for: indexPath) as! ImageCell
            setupImageCell()
            imageCell.delegate = self
            return imageCell
        } else {
            groceryCell = collectionView.dequeueReusableCell(withReuseIdentifier: groceryCellId, for: indexPath) as! GroceryCell
            setupGroceryCell()
            return groceryCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width, height: self.frame.height)
    }
    
}

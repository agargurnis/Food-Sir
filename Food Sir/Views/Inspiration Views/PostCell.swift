//
//  PostCell.swift
//  Food Sir
//
//  Created by Arvids Gargurnis on 29/04/2018.
//  Copyright © 2018 Arvids Gargurnis. All rights reserved.
//

import UIKit

protocol PostCellDelegte: class {
    func scrollToCell(cellIndex: Int)
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
            DispatchQueue.main.async {
                if let name = self.post?.userName, let userLocation = self.post?.userLocation {
                    let attributedText = NSMutableAttributedString(string: name, attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 12)])
                    attributedText.append(NSAttributedString(string: "\n\(userLocation)", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 10), NSAttributedStringKey.foregroundColor: UIColor.rgb(red: 155, green: 161, blue: 171)]))
                    self.imageCell.profileNameLabel.attributedText = attributedText
                }
                
                if let postId = self.post?.postId {
                    self.commentViewCell.postId = postId
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
                if let numberOfLikes = self.post?.timestamp {
                    self.imageCell.likeButtonLabel.text = "1"
                }
                if let numberOfComments = self.post?.timestamp {
                    self.imageCell.commentButtonLabel.text = "2"
                }
                if let numberOfItems = self.post?.ingredientList?.count {
                    self.imageCell.groceryButtonLabel.text = String(numberOfItems)
                }
            }
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            commentViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: commentViewCellId, for: indexPath) as! CommentViewCell
            return commentViewCell
        } else if indexPath.item == 1 {
            imageCell = collectionView.dequeueReusableCell(withReuseIdentifier: imageCellId, for: indexPath) as! ImageCell
            imageCell.delegate = self
            return imageCell
        } else {
            groceryCell = collectionView.dequeueReusableCell(withReuseIdentifier: groceryCellId, for: indexPath) as! GroceryCell
            return groceryCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width, height: self.frame.height)
    }
    
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
////        if let postDescriptionText = imageCell.descriptionTextView.text {
////
////            let height = estimateFrameForText(text: postDescriptionText).height
////            imageCell.descriptionTextHeight?.constant = CGFloat(height) - 20
////            print(imageCell.descriptionTextHeight?.constant)
////
////            DispatchQueue.main.async {
////                self.postCollectionView.layoutIfNeeded()
////            }
////        }
////
//        return CGSize(width: self.frame.width, height: self.frame.height)
//    }
//
//    func estimateFrameForText(text: String) -> CGRect {
//        let size = CGSize(width: frame.width - 95, height: 1000)
//        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
//        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13)], context: nil)
//    }
}

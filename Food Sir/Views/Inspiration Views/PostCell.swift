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
                if let name = self.post?.profileName, let userLocation = self.post?.userLocation {
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
                if let profileImageName = self.post?.profileImageName {
                    self.imageCell.profileImageView.image = UIImage(named: profileImageName)
                }
                if let postImageName = self.post?.postImageName {
                    self.imageCell.postImageView.image = UIImage(named: postImageName)
                }
                if let numberOfLikes = self.post?.numberOfLikes {
                    self.imageCell.likeButtonLabel.text = String(numberOfLikes)
                }
                if let numberOfComments = self.post?.numberOfComments {
                    self.imageCell.commentButtonLabel.text = String(numberOfComments)
                }
                if let numberOfItems = self.post?.numberOfItems {
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
            //commentCell.delegate = inspirationController
            return commentViewCell
        } else if indexPath.item == 1 {
            imageCell = collectionView.dequeueReusableCell(withReuseIdentifier: imageCellId, for: indexPath) as! ImageCell
            imageCell.delegate = self
            return imageCell
        } else {
            groceryCell = collectionView.dequeueReusableCell(withReuseIdentifier: groceryCellId, for: indexPath) as! GroceryCell
            //groceryCell.delegate = inspirationController
            return groceryCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //        if let postDescriptionText = posts[indexPath.item].postDescriptionText {
        //
        //            //let knownHeight: CGFloat = 8+....
        //            let rect = NSString(string: postDescriptionText).boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14)], context: nil)
        //
        //            return CGSize(width: view.frame.width, height: rect.height + 100)
        //        }
        
        return CGSize(width: self.frame.width, height: self.frame.height)
    }
    
}

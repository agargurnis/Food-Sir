//
//  CommentCollectionView.swift
//  Food Sir
//
//  Created by Arvids Gargurnis on 23/05/2018.
//  Copyright © 2018 Arvids Gargurnis. All rights reserved.
//

import UIKit
import Firebase

class CommentCollectionViewCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    let cellId = "cellId"
    var commentPosts = [Post]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
        loadPosts()
    }
    
    lazy var commentCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(CommentCollectionViewCellCell.self, forCellWithReuseIdentifier: cellId)
        cv.backgroundColor = .appGray
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    func loadPosts() {
        let userId = Auth.auth().currentUser!.uid
        let ref = Database.database().reference().child("comments")
        
        ref.observe(.value) { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                for child in dictionary {
                    let commentPost = Post()
                    let postId = child.key
                    
                    let commentChildRef = Database.database().reference().child("comments").child(postId)
                    commentChildRef.observe(.childAdded, with: { (snapshot) in
                        if let dictionary = snapshot.value as? [String: AnyObject] {
                            if userId == dictionary["userId"] as? String {
                                
                                let postChildRef = Database.database().reference().child("posts").child(postId)
                                postChildRef.observe(.value, with: { (snapshot) in
                                    if let dict = snapshot.value as? [String: AnyObject] {
                                        commentPost.postImageUrl = dict["postImageUrl"] as? String
                                        
                                        self.commentPosts.append(commentPost)
                                        
                                        DispatchQueue.main.async {
                                            self.commentCollectionView.reloadData()
                                        }
                                    }
                                })
                            }
                        }
                    })
                }
            }
        }
    }
    
    func setupCell() {
        addSubview(commentCollectionView)
        
        _ = commentCollectionView.anchor(self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sqaure = (frame.width / 4) - 5
        return CGSize(width: sqaure, height: sqaure)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return commentPosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CommentCollectionViewCellCell
        cell.commentPost = commentPosts[indexPath.item]
        return cell
    }
}

class CommentCollectionViewCellCell: UICollectionViewCell {
    
    var commentPost: Post? {
        didSet {
            if let postImageUrl = commentPost?.postImageUrl {
                self.imageView.loadImageUsingCacheWithUrlString(urlString: postImageUrl)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "curry")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    func setupCell() {
        addSubview(imageView)
        
        _ = imageView.anchor(self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
}


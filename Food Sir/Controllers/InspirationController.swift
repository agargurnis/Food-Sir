//
//  InspirationController.swift
//  Food Sir
//
//  Created by Arvids Gargurnis on 27/04/2018.
//  Copyright © 2018 Arvids Gargurnis. All rights reserved.
//

import UIKit
import Firebase

class InspirationController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let postCellId = "postCellId"
    var posts = [Post]()
    
    let backgroundView: UIView = {
        let iv = UIView()
        iv.backgroundColor = .appGray
        return iv
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        //navigationController?.hidesBarsOnSwipe = true
    }
    
    func loadPosts() {
        let ref = Database.database().reference().child("posts")
        ref.observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let post = Post()

                post.postId = snapshot.key
                post.comments = dictionary["comments"] as? [String: AnyObject]
                post.ingredientList = dictionary["ingredientList"] as? [String]
                post.postDescriptionText = dictionary["postDescriptionText"] as? String
                post.userName = dictionary["userName"] as? String
                post.userLocation = dictionary["userLocation"] as? String
                post.userProfileImageUrl = dictionary["userProfileImageUrl"] as? String
                post.timestamp = dictionary["timestamp"] as? Double
                post.postImageUrl = dictionary["postImageUrl"] as? String
                post.likes = dictionary["likes"] as? [String]
                
                self.posts.append(post)
            }
            
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }, withCancel: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPosts()
        
        collectionView?.keyboardDismissMode = .onDrag
        //collectionView?.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0)
        collectionView?.backgroundView = backgroundView
        collectionView?.alwaysBounceVertical = true
        collectionView?.register(PostCell.self, forCellWithReuseIdentifier: postCellId)
                
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let postCell = collectionView.dequeueReusableCell(withReuseIdentifier: postCellId, for: indexPath) as! PostCell
        
        postCell.post = posts[indexPath.item]
        postCell.inspirationController = self
        
        return postCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        var postHeight: CGFloat = 400
        
        if let text = posts[indexPath.item].postDescriptionText {
            height = estimateFrameForText(text: text).height
            postHeight = height + 370
        }
        
        return CGSize(width: view.frame.width, height: floor(postHeight))
    }
    
    func estimateFrameForText(text: String) -> CGRect {
        let size = CGSize(width: view.frame.width - 20, height: 400)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13)], context: nil)
    }
    
    
    
    
   
}

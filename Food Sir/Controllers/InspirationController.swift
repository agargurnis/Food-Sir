//
//  InspirationController.swift
//  Food Sir
//
//  Created by Arvids Gargurnis on 27/04/2018.
//  Copyright © 2018 Arvids Gargurnis. All rights reserved.
//

import UIKit


class InspirationController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let postCellId = "postCellId"
    var posts = [Post]()
    
    let backgroundView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "gradientBackground")
        return iv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let postSalmon = Post()
        postSalmon.profileName = "Arvids Gargurnis"
        postSalmon.userLocation = "Pymouth, UK"
        postSalmon.postDescriptionText = "Eating some fresh salmon that got caught only a few hours ago. #Scotland "
        postSalmon.profileImageName = "profilePic"
        postSalmon.postImageName = "salmon"
        postSalmon.numberOfLikes = 732
        postSalmon.numberOfComments = 212
        postSalmon.numberOfShares = 76
        
        let postBurger = Post()
        postBurger.profileName = "Arvids Gargurnis"
        postBurger.userLocation = "Pymouth, UK"
        postBurger.postDescriptionText = "Just made these lovely burgers. #Homemade #Delicious "
        postBurger.profileImageName = "profilePic"
        postBurger.postImageName = "burgers"
        postBurger.numberOfLikes = 468
        postBurger.numberOfComments = 112
        postBurger.numberOfShares = 23
        
        let postCurry = Post()
        postCurry.profileName = "Arvids Gargurnis"
        postCurry.userLocation = "Pymouth, UK"
        postCurry.postDescriptionText = "The curry from hell, so spicy that it will blow off your socks! #TurnUpTheHeat "
        postCurry.profileImageName = "profilePic"
        postCurry.postImageName = "curry"
        postCurry.numberOfLikes = 973
        postCurry.numberOfComments = 420
        postCurry.numberOfShares = 99
        
        posts.append(postSalmon)
        posts.append(postBurger)
        posts.append(postCurry)
        
        //navigationController?.isNavigationBarHidden = true
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
        
//        if let postDescriptionText = posts[indexPath.item].postDescriptionText {
//
//            //let knownHeight: CGFloat = 8+....
//            let rect = NSString(string: postDescriptionText).boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14)], context: nil)
//
//            return CGSize(width: view.frame.width, height: rect.height + 100)
//        }
        
        return CGSize(width: view.frame.width, height: 400)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
   
}

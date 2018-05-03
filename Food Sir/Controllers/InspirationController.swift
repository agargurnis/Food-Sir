//
//  InspirationController.swift
//  Food Sir
//
//  Created by Arvids Gargurnis on 27/04/2018.
//  Copyright © 2018 Arvids Gargurnis. All rights reserved.
//

import UIKit

protocol InspirationControllerDelegte: class {
    
}

class InspirationController: UICollectionViewController, UICollectionViewDelegateFlowLayout, InspirationControllerDelegte {
    
    let postCellId = "postCellId"
    var posts = [Post]()
    
    let backgroundView: UIView = {
        let iv = UIView()
        iv.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        return iv
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnSwipe = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let postSalmon = Post()
        postSalmon.profileName = "Arvids Gargurnis"
        postSalmon.userLocation = "Plymouth, UK"
        postSalmon.postDescriptionText = "Eating some fresh salmon that got caught only a few hours ago. #Scotland "
        postSalmon.profileImageName = "profilePic"
        postSalmon.postImageName = "salmon"
        postSalmon.numberOfLikes = 11
        postSalmon.numberOfComments = 7
        postSalmon.numberOfItems = 8
        
        let postBurger = Post()
        postBurger.profileName = "Arvids Gargurnis"
        postBurger.userLocation = "Plymouth, UK"
        postBurger.postDescriptionText = "Just made these lovely burgers. #Homemade #Delicious "
        postBurger.profileImageName = "profilePic"
        postBurger.postImageName = "burgers"
        postBurger.numberOfLikes = 18
        postBurger.numberOfComments = 2
        postBurger.numberOfItems = 5
        
        let postCurry = Post()
        postCurry.profileName = "Arvids Gargurnis"
        postCurry.userLocation = "Plymouth, UK"
        postCurry.postDescriptionText = "The curry from hell, so spicy that it will blow off your socks! #TurnUpTheHeat "
        postCurry.profileImageName = "profilePic"
        postCurry.postImageName = "curry"
        postCurry.numberOfLikes = 3
        postCurry.numberOfComments = 1
        postCurry.numberOfItems = 11
        
        posts.append(postSalmon)
        posts.append(postBurger)
        posts.append(postCurry)
        
        collectionView?.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0)
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
        return CGSize(width: view.frame.width, height: 400)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
   
}

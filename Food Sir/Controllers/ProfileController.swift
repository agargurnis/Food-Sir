//
//  ProfileController.swift
//  Food Sir
//
//  Created by Arvids Gargurnis on 28/04/2018.
//  Copyright © 2018 Arvids Gargurnis. All rights reserved.
//

import UIKit

class ProfileController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    let postCellId = "postCellId"
    let mapCellId = "mapCellId"
    let commentCellId = "commentCellId"
    let recipeCellId = "recipeCellId"
    let profileMapView = ProfileMapViewCell()
    var tabBarTopAnchorConstant: NSLayoutConstraint?
    var mapViewIsSelected = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    var profileInfoContainer: UserInfoView = {
        let view = UserInfoView()
        return view
    }()
    
//    var badgeContainer: BadgeBarView = {
//        let bbv = BadgeBarView()
//        return bbv
//    }()
    
    lazy var postTabBar: PostTabBar = {
        let ptb = PostTabBar()
        ptb.profileController = self
        return ptb
    }()
    
    let seperatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .appGray
        return view
    }()
    
    lazy var slidingCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: postCellId)
        cv.register(ProfileMapViewCell.self, forCellWithReuseIdentifier: mapCellId)
        cv.register(CommentCollectionViewCell.self, forCellWithReuseIdentifier: commentCellId)
        cv.register(RecipeCollectionViewCell.self, forCellWithReuseIdentifier: recipeCellId)
        cv.contentInset = UIEdgeInsetsMake(5, 0, 0, 0)
        cv.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 0, 0)
        cv.backgroundColor = .appGray
        cv.isPrefetchingEnabled = false
        cv.showsHorizontalScrollIndicator = false
        cv.isPagingEnabled = true
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(profileInfoContainer)
//        view.addSubview(badgeContainer)
//        view.addSubview(seperatorLine)
        view.addSubview(postTabBar)
        view.addSubview(slidingCollectionView)
        
        _ = profileInfoContainer.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 200)
        
//        _ = badgeContainer.anchor(profileInfoContainer.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
        
//        _ = seperatorLine.anchor(badgeContainer.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 5)
        
        tabBarTopAnchorConstant = postTabBar.anchor(profileInfoContainer.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50).first
        
        _ = slidingCollectionView.anchor(postTabBar.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    func expandCollectionView() {
        mapViewIsSelected = true
        tabBarTopAnchorConstant?.constant = -200
        slidingCollectionView.collectionViewLayout.invalidateLayout()
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.slidingCollectionView.layoutIfNeeded()
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func shrinkCollectionView() {
        mapViewIsSelected = false
        tabBarTopAnchorConstant?.constant = 0
        slidingCollectionView.collectionViewLayout.invalidateLayout()
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.slidingCollectionView.layoutIfNeeded()
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func scrollToMenuIndex(menuIndex: Int) {
        if menuIndex == 3 {
            expandCollectionView()
        } else {
            shrinkCollectionView()
        }
        
        let indexPath = NSIndexPath(item: menuIndex, section: 0)
        slidingCollectionView.scrollToItem(at: indexPath as IndexPath, at: [], animated: true)

    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        postTabBar.horizontalBarLeftAnchorConstraint?.constant = scrollView.contentOffset.x / 4
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.pointee.x / view.frame.width
        
        if index == 3 {
            expandCollectionView()
        } else {
            shrinkCollectionView()
        }
        
        let indexPath = NSIndexPath(item: Int(index), section: 0)
        postTabBar.tabBarCollectionView.selectItem(at: indexPath as IndexPath, animated: true, scrollPosition: [])

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier: String
        print(indexPath.item)
        if indexPath.item == 1 {
            identifier = commentCellId
        } else if indexPath.item == 2 {
            identifier = recipeCellId
        } else if indexPath.item == 3 {
            identifier = mapCellId
        } else {
            identifier = postCellId
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        slidingCollectionView.sizeToFit()
        
        return CGSize(width: view.frame.width, height: slidingCollectionView.frame.height - 5)
    }
}

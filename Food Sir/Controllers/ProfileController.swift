////
////  ProfileController.swift
////  Food Sir
////
////  Created by Arvids Gargurnis on 28/04/2018.
////  Copyright © 2018 Arvids Gargurnis. All rights reserved.
////
//
//import UIKit
//
//class ProfileController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.navigationController?.isNavigationBarHidden = true
//    }
//
//    var profileInfoContainer: UIView = {
//        let view = UIView()
//        view.backgroundColor = .red
//        return view
//    }()
//
//    var badgeContainer: UIView = {
//        let view = UIView()
//        view.backgroundColor = .yellow
//        return view
//    }()
//
//    lazy var postContainer: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        cv.backgroundColor = .white
//        cv.dataSource = self
//        cv.delegate = self
//    }()
//
//    var postTabBar: UICollectionView = {
//        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        view.backgroundColor = .green
//        return view
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        view.addSubview(profileInfoContainer)
//        view.addSubview(badgeContainer)
//        view.addSubview(postTabBar)
//        view.addSubview(postContainer)
//
//        _ = profileInfoContainer.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 200)
//
//        _ = badgeContainer.anchor(profileInfoContainer.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
//
//        _ = postTabBar.anchor(badgeContainer.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
//
//        _ = postContainer.anchor(postTabBar.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
//    }
//
//}

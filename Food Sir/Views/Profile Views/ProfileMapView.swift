//
//  ProfileMapView.swift
//  Food Sir
//
//  Created by Arvids Gargurnis on 23/05/2018.
//  Copyright © 2018 Arvids Gargurnis. All rights reserved.
//

import UIKit
import MapKit

class ProfileMapViewCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    
    let cellId = "cellId"
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.backgroundColor = .white
        return cell
    }

    let mapView = MKMapView()
    
    lazy var resultTableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .appGray
        tv.delegate = self
        tv.dataSource = self
        tv.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    func setupCell() {
        addSubview(mapView)
        addSubview(resultTableView)
        
        _ = mapView.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: -5, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: self.frame.height / 2)
        
        _ = resultTableView.anchor(mapView.bottomAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


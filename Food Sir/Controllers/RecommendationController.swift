//
//  RecommendationController.swift
//  Food Sir
//
//  Created by Arvids Gargurnis on 18/05/2018.
//  Copyright © 2018 Arvids Gargurnis. All rights reserved.
//

import UIKit
import MapKit

class RecommendationController: UIViewController, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, CLLocationManagerDelegate {
    
    let cellId = "cellId"
    var sheetInMotion = false
    let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    var bottomSheetHeightConstant: NSLayoutConstraint?
    let locationManager = CLLocationManager()
    var mapItemArray = [MKMapItem]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        return map
    }()
    
    var customSearchBar: UIView = {
        let view = UIView()
        view.backgroundColor = .appGray
        return view
    }()
    
    lazy var bottomSheet: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(wasDragged(pan:))))
        view.isUserInteractionEnabled = true
        return view
    }()
    
    var placeSearchTextField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.layer.borderWidth = 0.5
        tf.layer.borderColor = UIColor.rgb(red: 240, green: 240, blue: 240).cgColor
        tf.placeholder = "Restuarant"
        tf.backgroundColor = .white
        tf.layer.cornerRadius = 14
        tf.layer.masksToBounds = true
        return tf
    }()
    
    var citySearchTextField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.layer.borderWidth = 0.5
        tf.layer.borderColor = UIColor.rgb(red: 240, green: 240, blue: 240).cgColor
        tf.placeholder = "City"
        tf.backgroundColor = .white
        tf.layer.cornerRadius = 14
        tf.layer.masksToBounds = true
        return tf
    }()
    
    lazy var searchButton: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.setImage(UIImage(named: "searchIcon"), for: .normal)
        button.tintColor = .appOrange
        button.addTarget(self, action: #selector(handleSearch), for: .touchUpInside)
        return button
    }()
    
    lazy var resultTableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .appGray
        tv.delegate = self
        tv.dataSource = self
        tv.register(MapItemCell.self, forCellReuseIdentifier: cellId)
        return tv
    }()
    
    @objc func wasDragged(pan: UIPanGestureRecognizer) {
        let direction = pan.velocity(in: view).y
        
        if direction > 0 && self.bottomSheetHeightConstant?.constant == 360 && sheetInMotion == false {
            sheetInMotion = true
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.bottomSheetHeightConstant?.constant = 160
                self.view.layoutIfNeeded()
            }, completion: { (finished: Bool) in
                self.sheetInMotion = false
            })
        } else if direction < 0 && self.bottomSheetHeightConstant?.constant == 160 && sheetInMotion == false {
            sheetInMotion = true
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.bottomSheetHeightConstant?.constant = 360
                self.view.layoutIfNeeded()
            }, completion: { (finished: Bool) in
                self.sheetInMotion = false
            })
        } else if direction > 0  && self.bottomSheetHeightConstant?.constant == 160 && sheetInMotion == false {
            sheetInMotion = true
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.bottomSheetHeightConstant?.constant = 50
                self.view.layoutIfNeeded()
            }, completion: { (finished: Bool) in
                self.sheetInMotion = false
            })
        } else if direction < 0 && self.bottomSheetHeightConstant?.constant == 50 && sheetInMotion == false {
            sheetInMotion = true
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.bottomSheetHeightConstant?.constant = 160
                self.view.layoutIfNeeded()
            }, completion: { (finished: Bool) in
                self.sheetInMotion = false
            })
        }
    }
    
    private func observeKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            let keyboardFrameSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as! CGRect).size
            let keyboardDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey]) as! Double
            
            bottomSheetHeightConstant?.constant = keyboardFrameSize.height
            UIView.animate(withDuration: keyboardDuration) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            let keyboardDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey]) as! Double
            
            bottomSheetHeightConstant?.constant = 160
            UIView.animate(withDuration: keyboardDuration) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }

    func setupLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        if let userLocation = locationManager.location?.coordinate {
            
            let region = MKCoordinateRegion(center: userLocation, span: span)
            mapView.setRegion(region, animated: true)
            mapView.showsUserLocation = true
        }
    }
    
    @objc func handleSearch() {

        hideKeyboard()
        mapItemArray.removeAll()
        UIApplication.shared.beginIgnoringInteractionEvents()

        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        self.view.addSubview(activityIndicator)
        
        let searchRequest = MKLocalSearchRequest()
        if let placeText = placeSearchTextField.text, let cityText = citySearchTextField.text {
            searchRequest.naturalLanguageQuery = "\(placeText), \(cityText)"
        }
       
        let activeSearch = MKLocalSearch(request: searchRequest)
        activeSearch.start { (result, error) in
            if error != nil {
                print(error ?? "")
            }
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            let annotations = self.mapView.annotations
            self.mapView.removeAnnotations(annotations)
            
            for item in (result?.mapItems)! {
                print(item)
                
                let searchCoordinate = item.placemark.coordinate
                let resultLong = searchCoordinate.longitude
                let resultLat = searchCoordinate.latitude
                
                let annotation = MKPointAnnotation()
                annotation.title = item.placemark.name
                annotation.subtitle = item.placemark.title
                annotation.coordinate = searchCoordinate
                self.mapView.addAnnotation(annotation)
                
                let searchRegionCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(resultLat, resultLong)
                let searchRegion = MKCoordinateRegionMake(searchRegionCoordinate, self.span)
                
                self.mapView.setRegion(searchRegion, animated: true)
                self.mapItemArray.append(item)
                
                DispatchQueue.main.async {
                    self.resultTableView.reloadData()
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if (annotation.isKind(of: MKUserLocation.self)) {
            return nil
        } else {
            let annotationView = MKMarkerAnnotationView()
            annotationView.markerTintColor = .appOrange
            return annotationView
        }

    }
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
////        let span = MKCoordinateSpanMake(0.015,  0.015)
////        let centerLocation = locations[0].coordinate
////        let region = MKCoordinateRegion(center: centerLocation, span: span)
////        mapView.setRegion(region, animated: true)
////        mapView.showsUserLocation = true
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        observeKeyboardNotifications()
        setupLocationManager()
    }
    
    func setupViews() {
        view.addSubview(mapView)
        view.addSubview(bottomSheet)
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        view.addSubview(customSearchBar)
        customSearchBar.addSubview(placeSearchTextField)
        customSearchBar.addSubview(citySearchTextField)
        customSearchBar.addSubview(searchButton)
        
        bottomSheet.addSubview(customSearchBar)
        bottomSheet.addSubview(resultTableView)
        
        _ = mapView.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        _ = bottomSheet.anchor(nil, left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        bottomSheetHeightConstant = bottomSheet.heightAnchor.constraint(equalToConstant: 50)
        bottomSheetHeightConstant?.isActive = true
        
        _ = customSearchBar.anchor(bottomSheet.topAnchor, left: bottomSheet.leftAnchor, bottom: nil, right: bottomSheet.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
        
        _ = placeSearchTextField.anchor(customSearchBar.topAnchor, left: customSearchBar.leftAnchor, bottom: customSearchBar.bottomAnchor, right: nil, topConstant: 11, leftConstant: 5, bottomConstant: 11, rightConstant: 0, widthConstant: 180, heightConstant: 0)
        
        _ = citySearchTextField.anchor(customSearchBar.topAnchor, left: placeSearchTextField.rightAnchor, bottom: customSearchBar.bottomAnchor, right: searchButton.leftAnchor, topConstant: 11, leftConstant: 5, bottomConstant: 11, rightConstant: 5, widthConstant: 0, heightConstant: 0)
        
        _ = searchButton.anchor(customSearchBar.topAnchor, left: nil, bottom: customSearchBar.bottomAnchor, right: customSearchBar.rightAnchor, topConstant: 11, leftConstant: 0, bottomConstant: 11, rightConstant: 5, widthConstant: 28, heightConstant: 0)
      
        _ = resultTableView.anchor(customSearchBar.bottomAnchor, left: bottomSheet.leftAnchor, bottom: bottomSheet.bottomAnchor, right: bottomSheet.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mapItemArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let itemCell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MapItemCell
        
        itemCell.textLabel?.text = mapItemArray[indexPath.item].placemark.title
        //itemCell.detailTextLabel?.text = mapItemArray[indexPath.item].phoneNumber
        
        return itemCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = mapItemArray[indexPath.row]
        
        let searchCoordinate = item.placemark.coordinate
        let resultLong = searchCoordinate.longitude
        let resultLat = searchCoordinate.latitude
        
        let searchRegionCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(resultLat, resultLong)
        let searchRegion = MKCoordinateRegionMake(searchRegionCoordinate, span)
        
        self.mapView.setRegion(searchRegion, animated: true)
    }
    
}

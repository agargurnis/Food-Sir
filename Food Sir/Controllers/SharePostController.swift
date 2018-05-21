//
//  SharePostController.swift
//  Food Sir
//
//  Created by Arvids Gargurnis on 08/05/2018.
//  Copyright © 2018 Arvids Gargurnis. All rights reserved.
//

import UIKit
import Firebase

class SharePostController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        //navigationController?.hidesBarsOnSwipe = true
    }
    
    let backgroundView: UIView = {
        let iv = UIView()
        iv.backgroundColor = .appGray
        return iv
    }()
    
    lazy var mealLocationSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Meal In", "Meal Out"])
        sc.tintColor = .white
        sc.backgroundColor = .appOrange
        sc.selectedSegmentIndex = 0
        sc.addTarget(self, action: #selector(handleMealLocationChange), for: .valueChanged)
        return sc
    }()
    
    let postContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var ingredientTexView: UITextView = {
        let tv = UITextView()
        tv.text = "Please enter a comma seperated list of the ingredients used in the recipe, for example: bread, butter, jam, etc."
        tv.textColor = .lightGray
        tv.backgroundColor = .white
        tv.delegate = self
        tv.isEditable = true
        tv.isScrollEnabled = false
        return tv
    }()
    
    lazy var locationTexView: UITextView = {
        let tv = UITextView()
        tv.text = "Please enter the address of where is the location of the place you had your meal"
        tv.textColor = .lightGray
        tv.backgroundColor = .white
        tv.delegate = self
        tv.isEditable = true
        tv.isScrollEnabled = false
        tv.isHidden = true
        return tv
    }()

    lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Enter description..."
        textView.backgroundColor = .white
        textView.textColor = .lightGray
        textView.delegate = self
        textView.isScrollEnabled = false
        textView.isEditable = true
        textView.textContainer.maximumNumberOfLines = 5
        textView.textContainer.lineBreakMode = .byTruncatingTail
        return textView
    }()
    
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "coveredPlate")
        iv.alpha = 0.7
        iv.contentMode = .scaleAspectFill
        
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectImageView)))
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    lazy var shareButon: UIButton = {
        let button = UIButton()
        button.setTitle("Share", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .appOrange
        button.addTarget(self, action: #selector(saveShareInStorage), for: .touchUpInside)
        return button
    }()
    
    @objc func handleMealLocationChange() {
        if mealLocationSegmentedControl.selectedSegmentIndex == 0 {
            ingredientTexView.isHidden = false
            locationTexView.isHidden = true
        } else {
            ingredientTexView.isHidden = true
            locationTexView.isHidden = false
        }
    }
    
    func saveShareInDatabase(values: [String: Any], completion: () -> ()) {

        let ref = Database.database().reference().child("posts")
        let childRef = ref.childByAutoId()
        childRef.updateChildValues(values)
        
        self.descriptionTextView.text = nil
        self.ingredientTexView.text = nil
        self.locationTexView.text = nil
        
        completion()
    }
    
    @objc func saveShareInStorage() {
        let userId = Auth.auth().currentUser!.uid
        let timestamp: Double = Double(NSDate().timeIntervalSince1970)
        let rawString = ingredientTexView.text.trimmingCharacters(in: .whitespaces)
        let ingredientArray = rawString.components(separatedBy: ",")
        let imageName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("post_images").child("\(imageName).jpg")
        var userName: String?
        var userLocation: String?
        var userProfileImageUrl: String?
        
        let userRef = Database.database().reference().child("users").child(userId)
        userRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                userName = dictionary["name"] as? String
                userLocation = dictionary["location"] as? String
                userProfileImageUrl = dictionary["profileImageUrl"] as? String
            }
        }, withCancel: nil)
        
        if let uploadData = UIImageJPEGRepresentation(imageView.image!, 0.1) {
            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    print(error ?? "")
                    return
                }
                if let postImageUrl = metadata?.downloadURL()?.absoluteString {
                    let values: [String : Any] = ["postDescriptionText": self.descriptionTextView.text!, "userName": userName!, "userLocation": userLocation!, "userProfileImageUrl": userProfileImageUrl!, "timestamp": timestamp, "ingredientList": ingredientArray, "postImageUrl": postImageUrl]
                    self.saveShareInDatabase(values: values) {
                        DispatchQueue.main.async {
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.window?.rootViewController = OnboardingScreenController()
                        }
                    }
                }
            })
        }
    }
    
    @objc func handleSelectImageView() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageFromPicker: UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            imageView.image = selectedImage
            imageView.alpha = 1
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if descriptionTextView.textColor == .lightGray && descriptionTextView.isFirstResponder {
            descriptionTextView.text = nil
            descriptionTextView.textColor = .black
        } else if ingredientTexView.textColor == .lightGray && ingredientTexView.isFirstResponder {
            ingredientTexView.text = nil
            ingredientTexView.textColor = .black
        } else if locationTexView.textColor == .lightGray && locationTexView.isFirstResponder {
            locationTexView.text = nil
            locationTexView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if descriptionTextView.isFirstResponder && descriptionTextView.text.isEmpty || descriptionTextView.text == "" {
            descriptionTextView.textColor = .lightGray
            descriptionTextView.text = "Enter description..."
        } else if ingredientTexView.isFirstResponder && ingredientTexView.text.isEmpty || ingredientTexView.text == "" {
            ingredientTexView.textColor = .lightGray
            ingredientTexView.text = "Please enter a comma seperated list of the ingredients used in the recipe, for example: bread, butter, jam, etc."
        } else if locationTexView.isFirstResponder && locationTexView.text.isEmpty || locationTexView.text == "" {
            locationTexView.textColor = .lightGray
            locationTexView.text = "Please enter a comma seperated list of the ingredients used in the recipe, for example: bread, butter, jam, etc."
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.keyboardDismissMode = .onDrag
        collectionView?.backgroundView = backgroundView
        collectionView?.alwaysBounceVertical = true
        
        collectionView?.addSubview(mealLocationSegmentedControl)
        collectionView?.addSubview(postContainer)
        postContainer.addSubview(imageView)
        postContainer.addSubview(descriptionTextView)
        collectionView?.addSubview(ingredientTexView)
        collectionView?.addSubview(locationTexView)
        collectionView?.addSubview(shareButon)
        
        _ = mealLocationSegmentedControl.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 25, leftConstant: 50, bottomConstant: 0, rightConstant: 50, widthConstant: 0, heightConstant: 30)
        
        _ = postContainer.anchor(mealLocationSegmentedControl.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 15, leftConstant: 10, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 100)
        
        _ = imageView.anchor(postContainer.topAnchor, left: postContainer.leftAnchor, bottom: postContainer.bottomAnchor, right: nil, topConstant: 10, leftConstant: 10, bottomConstant: 10, rightConstant: 0, widthConstant: 80, heightConstant: 0)
        
        _ = descriptionTextView.anchor(postContainer.topAnchor, left: imageView.rightAnchor, bottom: postContainer.bottomAnchor, right: postContainer.rightAnchor, topConstant: 5, leftConstant: 10, bottomConstant: 5, rightConstant: 10, widthConstant: 0, heightConstant: 0)
        
        _ = ingredientTexView.anchor(postContainer.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 15, leftConstant: 10, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 50)
        
        _ = locationTexView.anchor(postContainer.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 15, leftConstant: 10, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 50)
        
        _ = shareButon.anchor(ingredientTexView.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 15, leftConstant: 10, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 30)
    }
    
}

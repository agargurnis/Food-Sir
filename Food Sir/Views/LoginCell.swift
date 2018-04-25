//
//  RegisterCell.swift
//  Food Sir
//
//  Created by Arvids Gargurnis on 24/04/2018.
//  Copyright © 2018 Arvids Gargurnis. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase
import GoogleSignIn

class LoginCell: UICollectionViewCell, FBSDKLoginButtonDelegate, GIDSignInUIDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    weak var delegate: LoginControllerDelegte?
    var profileImageContainerBottomAnchor: NSLayoutConstraint?
    var pickerView: UIViewController?
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        // present
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        // dismiss
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }
        print("successfully logged in using facebook")
        FacebookSignIn()
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out of facebook")
    }
    
    let facebookLoginButton = FBSDKLoginButton()
    let googleLoginButton = GIDSignInButton()
    
    let customLoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(UIImage(named: "whiteButton"), for: .normal)
        button.setTitle("Sign in with Food Sir", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    let orImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "orSlice")
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "signInSlice")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter account name"
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.borderStyle = .roundedRect
        textField.keyboardType = .emailAddress
        return textField
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter email"
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.borderStyle = .roundedRect
        textField.keyboardType = .emailAddress
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter password"
        textField.textContentType = UITextContentType("")
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        return textField
    }()
    
    lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(red: 247/255, green: 154/255, blue: 27/255, alpha: 1)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return button
    }()
    
    let profileImageContainer: UIView = {
        let iv = UIView()
        iv.backgroundColor = .white
        return iv 
    }()
    
    let profileImageLine: UIView = {
        let iv = UIView()
        iv.backgroundColor = .black
        return iv
    }()
    
    let profileImageBackground: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "gradientRect")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profileSlice")
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 45
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        
        return imageView
    }()
    
    @objc func handleRegister() {
        // register on firebase
    }
    
    func FacebookSignIn() {
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else { return }
        let credentials = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
        
        Auth.auth().signIn(with: credentials) { (user, error) in
            if error != nil {
                print(error ?? "")
                return
            }
            print("successs", user ?? "")
        }
    }
    
    func setupFacebookButton() {
        facebookLoginButton.delegate = self
        facebookLoginButton.removeConstraints(facebookLoginButton.constraints)
        facebookLoginButton.readPermissions = ["email", "public_profile"]
        let buttonTitle = NSAttributedString(string: "Sign in with Facebook", attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 13)])
        facebookLoginButton.setAttributedTitle(buttonTitle, for: .normal)
    }
    
    func setupGoogleButton() {
        GIDSignIn.sharedInstance().uiDelegate = self
        googleLoginButton.style = .wide
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupGoogleButton()
        setupFacebookButton()
        observeKeyboardNotifications()
        
        addSubview(orImageView)
        addSubview(googleLoginButton)
        addSubview(facebookLoginButton)
        addSubview(logoImageView)
        addSubview(nameTextField)
        addSubview(emailTextField)
        addSubview(passwordTextField)
        addSubview(registerButton)
        addSubview(customLoginButton)
        addSubview(profileImageContainer)
        
        profileImageContainer.addSubview(profileImageBackground)
        profileImageContainer.addSubview(profileImageLine)
        profileImageContainer.addSubview(profileImageView)
        
        setupSubviewAnchors()
        
    }
    
    private func observeKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardShow() {
        profileImageContainerBottomAnchor?.constant = 0
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc func keyboardHide() {
        profileImageContainerBottomAnchor?.constant = -450
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    func pickerViewController() -> UIViewController {
        var pickerController: UIViewController = UIApplication.shared.keyWindow!.rootViewController!
        while (pickerController.presentedViewController != nil) {
            pickerController = pickerController.presentedViewController!
        }
        return pickerController
    }
    
    @objc func handleSelectProfileImageView() {
        print("clicked")
        let picker = UIImagePickerController()
        pickerView = pickerViewController()
        picker.delegate = self
        picker.allowsEditing = true
        pickerView?.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageFromPicker: UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            profileImageView.image = selectedImage
        }
        
        pickerView?.dismiss(animated: true, completion: {
            self.profileImageContainerBottomAnchor?.constant = 0
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.delegate?.keyboardShow()
                self.nameTextField.becomeFirstResponder()
                self.layoutIfNeeded()
            }, completion: nil)
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        pickerView?.dismiss(animated: true, completion: {
            self.profileImageContainerBottomAnchor?.constant = 0
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.delegate?.keyboardShow()
                self.nameTextField.becomeFirstResponder()
                self.layoutIfNeeded()
            }, completion: nil)
        })
    }
    
    func setupSubviewAnchors() {
        profileImageContainerBottomAnchor = profileImageContainer.anchor(nil, left: safeAreaLayoutGuide.leftAnchor, bottom: orImageView.bottomAnchor, right: safeAreaLayoutGuide.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 450, rightConstant: 0, widthConstant: 0, heightConstant: 250)[1]
        
        _ = profileImageBackground.anchor(profileImageContainer.topAnchor, left: profileImageContainer.leftAnchor, bottom: profileImageView.centerYAnchor, right: profileImageContainer.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        _ = profileImageLine.anchor(profileImageView.centerYAnchor, left: profileImageContainer.leftAnchor, bottom: nil, right: profileImageContainer.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0.5)
        
        _ = profileImageView.anchor(nil, left: nil, bottom: profileImageContainer.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 90, heightConstant: 90)
        profileImageView.centerXAnchor.constraint(equalTo: profileImageContainer.centerXAnchor).isActive = true
        
        _ = logoImageView.anchor(centerYAnchor, left: nil, bottom: nil, right: nil, topConstant: -270, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 100, heightConstant: 100)
        logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        _ = customLoginButton.anchor(logoImageView.bottomAnchor, left: safeAreaLayoutGuide.leftAnchor, bottom: nil, right: safeAreaLayoutGuide.rightAnchor, topConstant: 0, leftConstant: 32, bottomConstant: 0, rightConstant: 32, widthConstant: 0, heightConstant: 40)
        
        _ = googleLoginButton.anchor(customLoginButton.bottomAnchor, left: safeAreaLayoutGuide.leftAnchor, bottom: nil, right: safeAreaLayoutGuide.rightAnchor, topConstant: 16, leftConstant: 29, bottomConstant: 0, rightConstant: 29, widthConstant: 0, heightConstant: 40)
        
        _ = facebookLoginButton.anchor(googleLoginButton.bottomAnchor, left: safeAreaLayoutGuide.leftAnchor, bottom: nil, right: safeAreaLayoutGuide.rightAnchor, topConstant: 16, leftConstant: 32, bottomConstant: 0, rightConstant: 32, widthConstant: 0, heightConstant: 40)
        
        _ = orImageView.anchor(facebookLoginButton.bottomAnchor, left: safeAreaLayoutGuide.leftAnchor, bottom: nil, right: safeAreaLayoutGuide.rightAnchor, topConstant: 12, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 40)
        
        _ = nameTextField.anchor(orImageView.bottomAnchor, left: safeAreaLayoutGuide.leftAnchor, bottom: nil, right: safeAreaLayoutGuide.rightAnchor, topConstant: 12, leftConstant: 32, bottomConstant: 0, rightConstant: 32, widthConstant: 0, heightConstant: 40)
        
        _ = emailTextField.anchor(nameTextField.bottomAnchor, left: safeAreaLayoutGuide.leftAnchor, bottom: nil, right: safeAreaLayoutGuide.rightAnchor, topConstant: 16, leftConstant: 32, bottomConstant: 0, rightConstant: 32, widthConstant: 0, heightConstant: 40)
        
        _ = passwordTextField.anchor(emailTextField.bottomAnchor, left: safeAreaLayoutGuide.leftAnchor, bottom: nil, right: safeAreaLayoutGuide.rightAnchor, topConstant: 16, leftConstant: 32, bottomConstant: 0, rightConstant: 32, widthConstant: 0, heightConstant: 40)
        
        _ = registerButton.anchor(passwordTextField.bottomAnchor, left: safeAreaLayoutGuide.leftAnchor, bottom: nil, right: safeAreaLayoutGuide.rightAnchor, topConstant: 16, leftConstant: 32, bottomConstant: 0, rightConstant: 32, widthConstant: 0, heightConstant: 40)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

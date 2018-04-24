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

class LoginCell: UICollectionViewCell, FBSDKLoginButtonDelegate, GIDSignInUIDelegate {
    
    weak var delegate: LoginControllerDelegte?
    
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
        
        addSubview(orImageView)
        addSubview(googleLoginButton)
        addSubview(facebookLoginButton)
        addSubview(logoImageView)
        addSubview(nameTextField)
        addSubview(emailTextField)
        addSubview(passwordTextField)
        addSubview(registerButton)
        addSubview(customLoginButton)
        
        setupSubviewAnchors()
        
    }
    
    func setupSubviewAnchors() {
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

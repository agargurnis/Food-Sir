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
    
    lazy var customLoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(UIImage(named: "sirButton"), for: .normal)
        button.setTitle("Sign in with Food Sir", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleFoodSirSignIn), for: .touchUpInside)
        return button
    }()
    
    let orImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "orSlice")
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let signInImageView: UIImageView = {
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
        textField.rightViewMode = .always
        textField.isSecureTextEntry = true
        return textField
    }()
    
    lazy var passwordToggle: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.appOrange, for: .normal)
        button.setTitle("Show", for: .normal)
        button.addTarget(self, action: #selector(togglePassword), for: .touchUpInside)
        return button
    }()
    
    lazy var signUpInButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .appOrange
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleSignUpInButton), for: .touchUpInside)
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
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectImage)))
        
        return imageView
    }()
    
    @objc func selectImage() {
        delegate?.handleSelectProfileImageView()
    }
    
    @objc func togglePassword() {
        if passwordTextField.isSecureTextEntry == true {
            passwordTextField.isSecureTextEntry = false
            passwordToggle.setTitle("Hide", for: .normal)
        } else {
            passwordTextField.isSecureTextEntry = true
            passwordToggle.setTitle("Show", for: .normal)
        }
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
        addSubview(signInImageView)
        addSubview(nameTextField)
        addSubview(emailTextField)
        addSubview(passwordTextField)
        addSubview(signUpInButton)
        addSubview(customLoginButton)
        addSubview(profileImageContainer)
        
        passwordTextField.rightView = passwordToggle
        passwordTextField.addSubview(passwordToggle)
        
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
            self.window?.frame = CGRect(x: 0, y: -205, width: (self.window?.frame.width)!, height: (self.window?.frame.height)!)
            self.layoutIfNeeded()
        }, completion: nil)
    }

    @objc func keyboardHide() {
        profileImageContainerBottomAnchor?.constant = -450
        nameTextField.isHidden = false
        profileImageView.isUserInteractionEnabled = true
        signUpInButton.setTitle("Sign Up", for: .normal)
        if profileImageView.image == UIImage(named: "loginCarrot") {
            profileImageView.image = UIImage(named: "profileSlice")
        }
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.window?.frame = CGRect(x: 0, y: 0, width: (self.window?.frame.width)!, height: (self.window?.frame.height)!)
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc func handleSignUpInButton() {
        if signUpInButton.currentTitle == "Sign Up" {
            delegate?.handleRegister()
        } else {
            delegate?.handleLogin()
        }
    }
    
    @objc func handleFoodSirSignIn() {
        nameTextField.isHidden = true
        emailTextField.becomeFirstResponder()
        profileImageView.image = UIImage(named: "loginCarrot")
        profileImageView.isUserInteractionEnabled = false
        signUpInButton.setTitle("Sign In", for: .normal)
    }
    
    func setupSubviewAnchors() {
        _ = passwordToggle.anchor(passwordTextField.topAnchor, left: nil, bottom: passwordTextField.bottomAnchor, right: passwordTextField.rightAnchor, topConstant: 5, leftConstant: 0, bottomConstant: 5, rightConstant: 50, widthConstant: 50, heightConstant: 0)
        
        profileImageContainerBottomAnchor = profileImageContainer.anchor(nil, left: safeAreaLayoutGuide.leftAnchor, bottom: orImageView.bottomAnchor, right: safeAreaLayoutGuide.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 450, rightConstant: 0, widthConstant: 0, heightConstant: 250)[1]
        
        _ = profileImageBackground.anchor(profileImageContainer.topAnchor, left: profileImageContainer.leftAnchor, bottom: profileImageView.centerYAnchor, right: profileImageContainer.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        _ = profileImageLine.anchor(profileImageView.centerYAnchor, left: profileImageContainer.leftAnchor, bottom: nil, right: profileImageContainer.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0.5)
        
        _ = profileImageView.anchor(nil, left: nil, bottom: profileImageContainer.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 90, heightConstant: 90)
        profileImageView.centerXAnchor.constraint(equalTo: profileImageContainer.centerXAnchor).isActive = true
        
        _ = signInImageView.anchor(centerYAnchor, left: nil, bottom: nil, right: nil, topConstant: -270, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 100, heightConstant: 100)
        signInImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        _ = customLoginButton.anchor(signInImageView.bottomAnchor, left: safeAreaLayoutGuide.leftAnchor, bottom: nil, right: safeAreaLayoutGuide.rightAnchor, topConstant: 0, leftConstant: 32, bottomConstant: 0, rightConstant: 32, widthConstant: 0, heightConstant: 40)
        
        _ = googleLoginButton.anchor(customLoginButton.bottomAnchor, left: safeAreaLayoutGuide.leftAnchor, bottom: nil, right: safeAreaLayoutGuide.rightAnchor, topConstant: 16, leftConstant: 29, bottomConstant: 0, rightConstant: 29, widthConstant: 0, heightConstant: 40)
        
        _ = facebookLoginButton.anchor(googleLoginButton.bottomAnchor, left: safeAreaLayoutGuide.leftAnchor, bottom: nil, right: safeAreaLayoutGuide.rightAnchor, topConstant: 16, leftConstant: 32, bottomConstant: 0, rightConstant: 32, widthConstant: 0, heightConstant: 40)
        
        _ = orImageView.anchor(facebookLoginButton.bottomAnchor, left: safeAreaLayoutGuide.leftAnchor, bottom: nil, right: safeAreaLayoutGuide.rightAnchor, topConstant: 12, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 40)
        
        _ = nameTextField.anchor(orImageView.bottomAnchor, left: safeAreaLayoutGuide.leftAnchor, bottom: nil, right: safeAreaLayoutGuide.rightAnchor, topConstant: 12, leftConstant: 32, bottomConstant: 0, rightConstant: 32, widthConstant: 0, heightConstant: 40)
        
        _ = emailTextField.anchor(nameTextField.bottomAnchor, left: safeAreaLayoutGuide.leftAnchor, bottom: nil, right: safeAreaLayoutGuide.rightAnchor, topConstant: 16, leftConstant: 32, bottomConstant: 0, rightConstant: 32, widthConstant: 0, heightConstant: 40)
        
        _ = passwordTextField.anchor(emailTextField.bottomAnchor, left: safeAreaLayoutGuide.leftAnchor, bottom: nil, right: safeAreaLayoutGuide.rightAnchor, topConstant: 16, leftConstant: 32, bottomConstant: 0, rightConstant: 32, widthConstant: 0, heightConstant: 40)
        
        _ = signUpInButton.anchor(passwordTextField.bottomAnchor, left: safeAreaLayoutGuide.leftAnchor, bottom: nil, right: safeAreaLayoutGuide.rightAnchor, topConstant: 16, leftConstant: 32, bottomConstant: 0, rightConstant: 32, widthConstant: 0, heightConstant: 40)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
//  LoginViewController.swift
//  Eventful
//
//  Created by Shawn Miller on 7/24/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import UIKit
import Foundation
import SVProgressHUD


protocol LoginViewControllerDelegate: class {
    func finishLoggingIn()
}



class LoginViewController: UIViewController , LoginViewControllerDelegate{
    //Login Controller Instance
    
   // var loginController: LoginViewController?
    weak var delegate : LoginViewControllerDelegate?
    
    
    
    // each of these creates a compnenet of the screen
    // creates a UILabel
    let nameOfAppLabel : UILabel =  {
        let nameLabel = UILabel()
        let myString = "[Name of App]"
        let myAttribute = [NSFontAttributeName:UIFont(name: "Times New Roman", size: 7.3)!]
        let myAttrString = NSAttributedString(string: myString, attributes: myAttribute)
        nameLabel.attributedText = myAttrString
        return nameLabel
    }()
    // creates a UILabel
    
    
    let welcomeBackLabel : UILabel =  {
        let welcomeLabel = UILabel()
        let myString = "Welcome Back!"
        let myAttribute = [NSFontAttributeName:UIFont(name: "Times New Roman", size: 20.7)!]
        let myAttrString = NSAttributedString(string: myString, attributes: myAttribute)
        welcomeLabel.attributedText = myAttrString
        return welcomeLabel
    }()
    
    // creates a UILabel
    
    
    let goalLabel : UILabel =  {
        let primaryGoalLabel = UILabel()
        let myString = "Use our application to find events"
        let myAttribute = [NSFontAttributeName:UIFont(name: "Times New Roman", size: 7.0)!]
        let myAttrString = NSAttributedString(string: myString, attributes: myAttribute)
        primaryGoalLabel.attributedText = myAttrString
        return primaryGoalLabel
    }()
    // creates a UILabel
    
    
    let emailLabel : UILabel =  {
        let userEmailLabel = UILabel()
        let myString = "Email"
        let myAttribute = [NSFontAttributeName:UIFont(name: "Times New Roman", size: 7.0)!]
        let myAttrString = NSAttributedString(string: myString, attributes: myAttribute)
        userEmailLabel.attributedText = myAttrString
        return userEmailLabel
    }()
    // creates a UITextField
    
    let emailTextField : LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.placeholder = "Email"
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.keyboardType = .emailAddress
        return textField
    }()
    // creates a UILabel
    
    let passwordLabel : UILabel =  {
        let userPasswordLabel = UILabel()
        let myString = "Password"
        let myAttribute = [NSFontAttributeName:UIFont(name: "Times New Roman", size: 7.0)!]
        let myAttrString = NSAttributedString(string: myString, attributes: myAttribute)
        userPasswordLabel.attributedText = myAttrString
        return userPasswordLabel
    }()
    // creates a UITextField
    let passwordTextField : LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.placeholder = "Password"
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.isSecureTextEntry = true
        return textField
    }()
    // creates a UIButton and transitions to a different screen after button is selected
    
    lazy var loginButton: UIButton  = {
        let button = UIButton(type: .system)
        button.backgroundColor = .black
        button.setTitle("LOGIN", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    func handleLogin(){
        if self.emailTextField.text == "" || self.passwordTextField.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter an email and a a password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            
        }else{
            SVProgressHUD.show(withStatus: "Logging in...")
            AuthService.signIn(controller: self, email: emailTextField.text!, password: passwordTextField.text!) { (user) in
                guard user != nil else {
                    // look back here
           
                    print("error: FiRuser dees not exist")
                    return
                }
                print("user is signed in")
                UserService.show(forUID: (user?.uid)!) { (user) in
                    if let user = user {
                        User.setCurrent(user, writeToUserDefaults: true)
                        self.finishLoggingIn()
                }
                    else {
                        print("error: User does not exist!")
                        return
                    }
                }
            }
        }

    }
    
    func finishLoggingIn() {
        print("Finish logging in from LoginController")
        let homeController = HomeViewController()
        self.view.window?.rootViewController = homeController
        self.view.window?.makeKeyAndVisible()
       // SVProgressHUD.dismiss()
        //let homeVC = HomeViewController()
        //present(homeVC, animated: true)
        
    }
    
    //creatas a UILabel
    let signUpLabel: UILabel = {
        let signUp = UILabel()
        let myString = "Don't have an account?"
        let myAttribute = [NSFontAttributeName:UIFont(name: "Times New Roman", size: 10)!]
        let myAttrString = NSAttributedString(string: myString, attributes: myAttribute)
        signUp.attributedText = myAttrString
        return signUp
        
    }()
    
    //will create the signup button
    let signUpButton: UIButton = {
        let signUpButton = UIButton(type: .system)
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        signUpButton.setTitleColor(.black, for: .normal)
        signUpButton.addTarget(self, action: #selector(handleSignUpTransition), for: .touchUpInside)
        return signUpButton
    }()
    
    override func viewDidLoad() {
        // Every view that I add is from the top down imagine a chandeler that you are just hanging things from
        super.viewDidLoad()
        // will add each of the screen elements to the current view
        view.addSubview(nameOfAppLabel)
        view.addSubview(welcomeBackLabel)
        view.addSubview(goalLabel)
        view.addSubview(emailLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordLabel)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(signUpLabel)
        view.addSubview(signUpButton)
        //////////////////////////////////////////////////////////////////////
        
        // All Constraints for Elements in Screen
        // constraints for the nameOfAppLabel
        _ = nameOfAppLabel.anchor(top: view.centerYAnchor, left: nil, bottom: nil, right: nil, paddingTop: -191.3, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 49.7, height: 9.7)
        nameOfAppLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        //constrints for the welcome back label
        _ = welcomeBackLabel.anchor(top: nameOfAppLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 15.7, paddingLeft: 120, paddingBottom: 0, paddingRight: 120, width: 0, height: 12.7)
        
        welcomeBackLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        //constrints for the goal label
        _ = goalLabel.anchor(top: welcomeBackLabel.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 115.3, height: 14)
        
        goalLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        //constrints for the email label
        _ = emailLabel.anchor(top: goalLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 13.7, paddingLeft: 32, paddingBottom: 0, paddingRight: 101, width: 14.3, height: 15)
        //constraints for the the email text field
        
        _ = emailTextField.anchor(top: emailLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 4.7, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 40)
        // constraints for the password label
        
        _ = passwordLabel.anchor(top: emailTextField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 11.3, paddingLeft: 32, paddingBottom: 0, paddingRight: 101, width: 14.3, height: 15)
        //constraints for the the password text field
        _ = passwordTextField.anchor(top: passwordLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 4.7, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 40)
        //constraints for the login button
        _ = loginButton.anchor(top: passwordTextField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 15.3, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 40)
        
        //constraints for signupLabel
        _ = signUpLabel.anchor(top: loginButton.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 6.3, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 10)
        signUpLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        // constraints for signupButton
        
        _ = signUpButton.anchor(top: loginButton.bottomAnchor, left: signUpLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 2)
        //////////////////////////////////////////////////////////////////////
        
        view.backgroundColor = UIColor(r: 255, g: 255 , b: 255)
        
        //////////////////////////////////////////////////////////////////////
        
        observeKeyboardNotifications()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    // will open a new ViewController When login button is selected
    func handleSignUpTransition(){
        let signUpTransition = SignUpViewController()
        present(signUpTransition, animated: true, completion: nil)
    }
    
    // Will move the UI Up on login Screen when keyboard appears
    
    fileprivate func  observeKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
    }
    
    func keyboardWillShow(sender: NSNotification) {
        if let keyboardSize = (sender.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            UIView.animate(withDuration: 0.2, animations: {
                self.view.frame.origin.y = -keyboardHeight
            })
        }
    }
    
    
    // will properly hide keyboard
    func keyboardWillHide(sender: NSNotification) {
        UIView.animate(withDuration: 0.2, animations: {
            self.view.frame.origin.y = 0
        })
    }
    
}


extension UIColor{
    convenience init(r: CGFloat, g: CGFloat, b:CGFloat){
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}


class LeftPaddedTextField: UITextField {
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 12, y: bounds.origin.y, width: bounds.width + 10, height: bounds.height)
    }
    
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 12, y: bounds.origin.y, width: bounds.width + 10, height: bounds.height)
    }
}



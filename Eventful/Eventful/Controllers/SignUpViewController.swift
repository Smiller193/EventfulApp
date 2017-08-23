//
//  SignUpViewController.swift
//  Eventful
//
//  Created by Shawn Miller on 7/25/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import UIKit
import Foundation
import SVProgressHUD



protocol SignUpViewControllerDelegate: class {
    func finishSigningUp()
}

class SignUpViewController: UIViewController, SignUpViewControllerDelegate {
    
    var selectedUserGender: String = ""
    // creates a signup UILabel
    
    
    weak var delegate : SignUpViewControllerDelegate?
    
    let signUp:UILabel = {
        let signUpLabel = UILabel()
        let myString = "Sign Up"
        let myAttribute = [NSFontAttributeName:UIFont(name: "Times New Roman", size: 20)!]
        let myAttrString = NSAttributedString(string: myString, attributes: myAttribute)
        signUpLabel.attributedText = myAttrString
        
        return signUpLabel
    }()
    
    // creates a name UILabel

    let nameLabel: UILabel = {
       let nameLabel = UILabel()
        let myString = "Username"
        let myAttribute = [NSFontAttributeName:UIFont(name: "Times New Roman", size: 15)!]
        let myAttrString = NSAttributedString(string: myString, attributes: myAttribute)
        nameLabel.attributedText = myAttrString
        return nameLabel
    }()
    // creates a name UITextField to hold the name

    let nameTextField : LeftPaddedTextField = {
       let nameText = LeftPaddedTextField()
        nameText.placeholder = "Username"
        nameText.layer.borderColor = UIColor.lightGray.cgColor
        nameText.layer.borderWidth = 1
        return nameText
    }()
    // creates a email UILabel

    let emailLabel: UILabel = {
        let userEmailLabel = UILabel()
        let myString = "Email"
        let myAttribute = [NSFontAttributeName:UIFont(name: "Times New Roman", size: 15)!]
        let myAttrString = NSAttributedString(string: myString, attributes: myAttribute)
        userEmailLabel.attributedText = myAttrString
        return userEmailLabel
    }()
    
    // creates a email UITextField to hold the email
    let emailTextField : LeftPaddedTextField = {
        let emaiilText = LeftPaddedTextField()
        emaiilText.placeholder = "Email"
        emaiilText.layer.borderColor = UIColor.lightGray.cgColor
        emaiilText.layer.borderWidth = 1
        return emaiilText
    }()

    //creates a password UILabel
    
    let passwordLabel: UILabel = {
        let userPasswordLabel = UILabel()
        let myString = "Password"
        let myAttribute = [NSFontAttributeName:UIFont(name: "Times New Roman", size: 15)!]
        let myAttrString = NSAttributedString(string: myString, attributes: myAttribute)
        userPasswordLabel.attributedText = myAttrString
        return userPasswordLabel
    }()
    
    //creates a password UItextield
    let passwordTextField : LeftPaddedTextField = {
        let passwordText = LeftPaddedTextField()
        passwordText.placeholder = "Password"
        passwordText.layer.borderColor = UIColor.lightGray.cgColor
        passwordText.layer.borderWidth = 1
        passwordText.isSecureTextEntry = true
        return passwordText
    }()

    //creates a confirm password UIlabel
    let confirmPasswordLabel: UILabel = {
        let confirmPasswordLabel = UILabel()
        let myString = "Confirm Password"
        let myAttribute = [NSFontAttributeName:UIFont(name: "Times New Roman", size: 15)!]
        let myAttrString = NSAttributedString(string: myString, attributes: myAttribute)
        confirmPasswordLabel.attributedText = myAttrString
        return confirmPasswordLabel
    }()
    
    //creates a confirm password UItextfield
    let confirmPasswordTextField : LeftPaddedTextField = {
        let confirmPasswordText = LeftPaddedTextField()
        confirmPasswordText.placeholder = "Password"
        confirmPasswordText.layer.borderColor = UIColor.lightGray.cgColor
        confirmPasswordText.layer.borderWidth = 1
        confirmPasswordText.isSecureTextEntry = true
        return confirmPasswordText
    }()
    
    // creates a UIButton
    
    let signupButton: UIButton  = {
        let button = UIButton(type: .system)
        button.backgroundColor = .black
        button.setTitle("SIGN UP", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    // will handle the  sign up of a user
    func handleSignUp(){
            // first we cant to take sure that all of the fields are filled
        var bio: String = ""
        
        var profilePic: String = ""
            guard let username = self.nameTextField.text,
                let confirmPassword = self.confirmPasswordTextField.text,
                let email = self.emailTextField.text,
                let password = self.passwordTextField.text,
                !username.isEmpty,
                !email.isEmpty,
                !password.isEmpty,
            !confirmPassword.isEmpty
                else {
                    
                    print("Required fields are not all filled!")
                    return
            }
            
            let gender = self.selectedUserGender;
            // will make sure user is validated before it even tries to create user
            
            if self.validateEmail(enteredEmail:email) != true{
                let alertController = UIAlertController(title: "Error", message: "Please Enter A Valid Email", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                present(alertController, animated: true, completion: nil)

            }
        // will make sure the password and confirm password textfields have the same value if so it will print an error
        if passwordTextField.text != confirmPasswordTextField.text {
            let alertController = UIAlertController(title: "Error", message: "Passwords Don't Match", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        }
            // will authenticate a user into the authentication services with an email and passowrd
            AuthService.createUser(controller: self, email: email, password: password) { (authUser) in
                guard let firUser = authUser else {
                    return
                }
                
                // wlll add the user to the firebase database
                UserService.create(firUser, username: username, gender: gender , profilePic: profilePic , bio: bio) { (user) in
                    guard let user = user else {
                         print("User successfully loaded into firebase db")
                        return
                    }
                    // will set the current user for userdefaults to work
                    User.setCurrent(user, writeToUserDefaults: true)
                    // self.delegate?.finishSigningUp()

                    self.finishSigningUp()
                    
              
                }
            }
        }
    
    
    func finishSigningUp() {
        print("Finish signing up from signup view controller")
        print("Attempting to return to root view controller")
    
        let homeController = HomeViewController()
        //should change the root view controller to the homecontroller when done signing up
        self.view.window?.rootViewController = homeController
        self.view.window?.makeKeyAndVisible()
        
    }
    
    
// will validate email entry so user can not enter false text
    
    func validateEmail(enteredEmail:String) -> Bool {
        
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
        
    }

    

    //will create a label so users know to select gender when creating account
    let genderLabel: UILabel = {
       let gender = UILabel()
        let myString = "Gender"
        let myAttribute = [NSFontAttributeName:UIFont(name: "Times New Roman", size: 15)!]
        let myAttrString = NSAttributedString(string: myString, attributes: myAttribute)
        gender.attributedText = myAttrString
        return gender
    }()
    //will create a segmented control button to add gender
    
    lazy var genderSelector: UISegmentedControl = {
        let genderSelect = UISegmentedControl(items: ["Male", "Female"])
        genderSelect.tintColor = UIColor.black
        genderSelect.addTarget(self, action: #selector(handleGenderSelection), for: .valueChanged)
        
        return genderSelect
    }()
    
    func handleGenderSelection()  {
       //print(genderSelector.selectedSegmentIndex)
        if (genderSelector.selectedSegmentIndex == 0) {
            selectedUserGender = "Male"
        }else if(genderSelector.selectedSegmentIndex == 1 ){
            selectedUserGender = "Female"

        }
       // print(selectedUserGender)

    }
    
  // will create a cancel button so users can go back to login screen if they actually want to log in
   // Buton setup as well as cancel will be in this code block
    let cancelButton : UIButton = {
       let cancel = UIButton()
        cancel.setTitle("Cancel", for: .normal)
        cancel.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        cancel.setTitleColor(.black, for: .normal)
        cancel.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        return cancel
    }()
    
    func handleCancel(){
        self.dismiss(animated: true, completion: nil)
    }
    
    /////////////////////////////////////////////
    
    
    
    
    // Will move the UI Up on login Screen when keyboard appears
    
    fileprivate func  observeKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
    }
    // will properly show keyboard
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
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(r: 255, g: 255 , b: 255)
        observeKeyboardNotifications()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)

        /////////////////////////  Where all the subviews will be added
        
        view.addSubview(signUp)
        view.addSubview(nameLabel)
        view.addSubview(nameTextField)
        view.addSubview(emailLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordLabel)
        view.addSubview(passwordTextField)
        view.addSubview(confirmPasswordLabel)
        view.addSubview(confirmPasswordTextField)
        view.addSubview(signupButton)
        view.addSubview(genderLabel)
        view.addSubview(genderSelector)
        view.addSubview(cancelButton)
        ////////////////////////////////////////////////////////////////////
        
        
        /////////////////////////  Where all the constraints will be added
        // constraints for the sign up label/title
        _ = signUp.anchor(top: view.centerYAnchor, left: nil, bottom: nil, right: nil, paddingTop: -280, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 70, height: 35)
        signUp.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        //constraints for name label
        _ = nameLabel.anchor(top: signUp.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 32, paddingBottom: 0, paddingRight: 0, width: 70, height: 14)
        //constraints for name text field
        _ = nameTextField.anchor(top: nameLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 3.7, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 40)
        //constraints for email label
        _ = emailLabel.anchor(top: nameTextField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 32, paddingBottom: 0, paddingRight: 0, width: 70, height: 14)
        //constraints for email text field
         _ = emailTextField.anchor(top: emailLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 3.7, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 40)
        //constraints for the password label
        _ = passwordLabel.anchor(top: emailTextField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 32, paddingBottom: 0, paddingRight: 0, width: 70, height: 14)
        //constraints for the password text field
         _ = passwordTextField.anchor(top: passwordLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 3.7, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 40)
        //constraisnts for the confirm password label
        _ = confirmPasswordLabel.anchor(top: passwordTextField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 32, paddingBottom: 0, paddingRight: 0, width: 160, height: 14)
        //constraints for the confirm password textfield
         _ = confirmPasswordTextField.anchor(top: confirmPasswordLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 3.7, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 40)
        //constaints for the gender label
        _ = genderLabel.anchor(top: confirmPasswordTextField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 70, height: 14)
        //constraints for segmented control
        _ = genderSelector.anchor(top: confirmPasswordTextField.bottomAnchor, left: genderLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 15, paddingBottom: 0, paddingRight: 32, width: 100, height: 20)
        //constraints for the sign up button
        _ = signupButton.anchor(top: genderSelector .bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 18.7, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 40)
        //constraints for the cancel button
        _ = cancelButton.anchor(top: view.centerYAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: -300, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 20)

        ////////////////////////////////////////////////////////////////////

        
        

        
        // Do any additional setup after loading the view.
    }

   

}





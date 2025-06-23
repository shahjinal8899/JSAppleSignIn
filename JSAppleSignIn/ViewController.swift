//
//  ViewController.swift
//  JSAppleSignIn
//
//  Created by The Shiva's Girl on 23/06/25.
//

import UIKit
import AuthenticationServices
import SwiftKeychainWrapper

//KEYCHAIN Login
let KEYCHAIN_MyAppleIdentifier = "KeychainMyAppleIdentifier"
let KEYCHAIN_MyAppleEmail = "KeychainMyAppleEmail"
let KEYCHAIN_MyAppleName = "KeychainMyAppleName"

class ViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var stackDetails: UIStackView!
    @IBOutlet weak var btnAppleSignin: UIButton!
    
    //MARK: - Variables
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblIdentifier: UILabel!
    
    //MARK: - View Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.btnAppleSignin.layer.cornerRadius = 15
                
        //Retrieve Data from Keychain
        let obj = self.retrieveDataFromKeychain()
        self.lblIdentifier.text = obj.0
        self.lblEmail.text = obj.1
        self.lblName.text = obj.2
        
        if obj.0 == "",
           obj.1 == "",
           obj.2 == "" {
            self.stackDetails.isHidden = true
        } else {
            self.stackDetails.isHidden = false
        }
    }

    //MARK: - Button Action Methods
    @IBAction func btnAppleLogin_clk(_ sender: Any) {
        self.appleLogin()
    }
    
    //MARK: - Save/Retreive/Remove data Keychain Methods
    func saveDataToKeychain(withAppleEmail: String, withAppleID: String, withAppleUserName: String) {
        let saveEmailSuccessful: Bool = KeychainWrapper.standard.set(withAppleEmail, forKey: KEYCHAIN_MyAppleEmail)
        let saveIDSuccessful: Bool = KeychainWrapper.standard.set(withAppleID, forKey: KEYCHAIN_MyAppleIdentifier)
        let saveNameSuccessful: Bool = KeychainWrapper.standard.set(withAppleUserName, forKey: KEYCHAIN_MyAppleName)
        print("saveEmailSuccessful : \(saveEmailSuccessful)")
        print("saveIDSuccessful : \(saveIDSuccessful)")
        print("saveNameSuccessful : \(saveNameSuccessful)")
    }
        
    func retrieveDataFromKeychain() -> (String, String, String) {
        if let retrievedID = KeychainWrapper.standard.string(forKey: KEYCHAIN_MyAppleIdentifier) {
            if let retrievedEmail = KeychainWrapper.standard.string(forKey: KEYCHAIN_MyAppleEmail),
               let retrievedName = KeychainWrapper.standard.string(forKey: KEYCHAIN_MyAppleName) {
                print("Retrieved from Keychain")
                return (retrievedID, retrievedEmail, retrievedName)
            }
        }
        
        return ("", "", "")
    }

    func removeDataFromKeychain() {
        let removeEmailSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: KEYCHAIN_MyAppleEmail)
        let removeIDSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: KEYCHAIN_MyAppleIdentifier)
        let removeNameSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: KEYCHAIN_MyAppleName)
        if removeEmailSuccessful &&
            removeIDSuccessful &&
            removeNameSuccessful {
            print("Removed from Keychain")
        }
    }
    
    //MARK: - Show Alert Methods
    func showAlert(withTitle: String, withMsg: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: withTitle, message: withMsg, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {_ in
               
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

//MARK: - Apple Login Methods
extension ViewController: ASAuthorizationControllerPresentationContextProviding, ASAuthorizationControllerDelegate {
    public func appleLogin() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    @available(iOS 13.0, *)
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        //Hide Loader
        
        //Show Alert
        self.showAlert(withTitle: "Apple SignIn Error", withMsg: "\(error.localizedDescription)")
    }
    
    @available(iOS 13.0, *)
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            
            var strEmail = ""
            var strName = ""
            
            //Name
            if let givenName = appleIDCredential.fullName?.givenName,
               givenName.count > 0{
                strName = givenName
                
                if  let familyName = appleIDCredential.fullName?.familyName,
                    familyName.count > 0{
                    strName = givenName + " " + familyName
                }
            } else {
                strName = "" //userIdentifier
            }
            
            //Email
            if  let email = appleIDCredential.email,
                    email.count > 0 {
                strEmail = email
                
                //Retrieve data from keychain
                let strvalemail = self.retrieveDataFromKeychain().1
                if strvalemail != strEmail {
                    //Remove Email from keychain
                    self.removeDataFromKeychain()
                }
                
                if strName.count == 0 {
                    strName = self.retrieveDataFromKeychain().2
                }
                
                //Save Data in Keychain
                self.saveDataToKeychain(withAppleEmail: strEmail, withAppleID: userIdentifier, withAppleUserName: strName)
            }
            
            if strEmail.count > 0 {
                self.lblEmail.text = strEmail
                
            } else {
                //Email will be retrieved only once
                //Retrieve data from keychain
                let strkeychainID = self.retrieveDataFromKeychain().0
                let strkeychainEmail = self.retrieveDataFromKeychain().1
                strName = self.retrieveDataFromKeychain().2
                
                if userIdentifier == strkeychainID {
                    if strkeychainEmail.count > 0 {
                        self.lblEmail.text = strkeychainEmail
                    }
                }
            }
            
            //Apple User Identifier
            self.lblIdentifier.text = userIdentifier
            
            //Setup Name
            self.lblName.text = strName
                                          
            self.stackDetails.isHidden = false
            
            //Make an API Call here
            
        }
    }
    
    @available(iOS 13.0, *)
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

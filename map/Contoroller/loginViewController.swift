//
//  loginViewController.swift
//  map
//
//  Created by Yabuki Shodai on 2021/05/25.
//

import UIKit
import FBSDKLoginKit
import FirebaseAuth
import FirebaseFirestore
import Firebase

class loginViewController: UIViewController, LoginButtonDelegate {
   
    var Database = Firestore.firestore()
    var pictureURL = String()
    var pictureURLString = String()
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    var checkBox = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.isEnabled = false
    }
    
    @IBAction func loginButotn(_ sender: Any) {
    
        Auth.auth().signInAnonymously { (authResult, error) in
            if error != nil{
                print(error)
                return
            }
            let userID = Auth.auth().currentUser!.uid
            self.Database.collection("Users").document(userID).setData(["userId":userID])
            
            //画面遷移する
            self.performSegue(withIdentifier: "Home", sender: nil)
        }
    }
    
    
    //使ってない。
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if error == nil {
            if result?.isCancelled == true {
                return
            }
            
            
            let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
            
            //ここからfirebase
            Auth.auth().signIn(with: credential) { (result, error) in
                if error != nil {
                    return
                }
                let userName = result?.user.displayName
                
                print(result?.user.displayName! ?? "No Name")
                
                print("loginしました")
                let userID = Auth.auth().currentUser?.uid as! String
                print(userID)
                self.pictureURLString = result!.user.photoURL!.absoluteString
                
                self.Database.collection("Users").document(Auth.auth().currentUser!.uid).setData(["username":userName!,"userImage": self.pictureURLString])
                //次の画面の遷移先を指定
                self.performSegue(withIdentifier: "Home", sender: nil)
            }
            
            
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
    }
    @IBAction func tapCheckBox(_ sender: Any) {
        checkBox = !checkBox
        if checkBox == true{
            checkButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
            loginButton.isEnabled = true
        }
        else{
            checkButton.setImage(UIImage(systemName: "square"), for: .normal)
            loginButton.isEnabled = false
        }
    }
}

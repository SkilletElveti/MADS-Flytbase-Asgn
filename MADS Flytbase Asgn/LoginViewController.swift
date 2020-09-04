//
//  LoginViewController.swift
//  MADS Flytbase Asgn
//
//  Created by Shubham Vinod Kamdi on 03/09/20.
//  Copyright © 2020 Persausive Tech. All rights reserved.
//

import UIKit
import SwiftyJSON

class LoginViewController: UIViewController {
   
   
    
    @IBOutlet weak var backBtn: UIButton!
       
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var forgotPassword: UILabel!
    @IBOutlet weak var loginBtn: UIButton!
       
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var passwordView: UIView!
       
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var password: UILabel!
       
    @IBOutlet weak var loginTitle: UILabel!
       
       
    @IBOutlet weak var whiteView: UIView!
    override func viewDidLoad() {
            super.viewDidLoad()
            registerNotification()
        passwordTextField.isSecureTextEntry = true
        self.loginBtn.addTarget(self, action: #selector(login), for: .touchUpInside)
    }
    
  @IBAction func login(){
    if EmailValidation.isValidEmail(emailStr: self.usernameTextField.text!){
            
            
               
                    if !self.passwordTextField.text!.isEmpty{
                        self.loginService()
                    }else{
                        let alert = UIAlertController(title: "Error", message: "Password should not be empty", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
                            _ in
                            alert.dismiss(animated: true, completion: nil)
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
               
           
            
            
        }else{
            let alert = UIAlertController(title: "Error", message: "Enter Your Email", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
                _ in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
    }

    func loginService(){
        if Reachability.isInternetAvailable(){
            let server = Constant.SERVER_URL + Constant.LOGIN
            let url = URL(string: server)
            
            let session = URLSession.shared
            var req = URLRequest(url: url!)
            req.httpMethod = "Post"
            req.setValue("application/json", forHTTPHeaderField: "Content-Type")
            req.setValue(Constant.STATIC_TOKEN, forHTTPHeaderField: "Token")
            let data: [String: AnyObject] = ["email":self.usernameTextField.text as AnyObject ,"password":self.passwordTextField.text as AnyObject , "language": "en" as AnyObject,"source":"ios" as AnyObject]
            let json_data = try! JSONSerialization.data(withJSONObject: data, options: [])
            
            session.uploadTask(with: req, from: json_data){
                data, response, error in
                if error == nil{
                    let JSONResponse = JSON(data)
                    print(JSONResponse)
                    if JSONResponse["status"].boolValue{
                        
                        let token = JSONResponse["token"].stringValue
                        let first_name = JSONResponse["user"]["first_name"].stringValue
                        UserDefaults.standard.set(first_name, forKey: Constant.first_name)
                        UserDefaults.standard.set(token, forKey: Constant.token)
                        UserDefaults.standard.set(true, forKey: Constant.IS_LOGGED_IN)
                       
                        DispatchQueue.main.async {
                            let app = UIApplication.shared.delegate as! AppDelegate
                            app.redirect()
                        }
                        
                        
                        
                    }else{
                        let alert = UIAlertController(title: "Error", message: JSONResponse["message"].stringValue, preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
                            _ in
                            alert.dismiss(animated: true, completion: nil)
                        }))
                        DispatchQueue.main.async {
                            self.present(alert, animated: true, completion: nil)
                        }
                        
                    }
                }else{
                    let alert = UIAlertController(title: "Error", message: "\(String(describing: error))", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
                        _ in
                        alert.dismiss(animated: true, completion: nil)
                    }))
                    DispatchQueue.main.async {
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }.resume()
        }else{
            let alert = UIAlertController(title: "Error", message: "Internet Not AVailable", preferredStyle: UIAlertController.Style.alert)
                       alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
                           _ in
                           alert.dismiss(animated: true, completion: nil)
                       }))
                       self.present(alert, animated: true, completion: nil)
        }
    }

    func registerNotification(){
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector:#selector(adjustForKeyboard) , name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        
        let userInfo = notification.userInfo
        let keyBoardScreenEndFrame = (userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyBoardViewEndFrame = view.convert(keyBoardScreenEndFrame, to: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification{
            scrollView.contentInset = UIEdgeInsets.zero
        }else{
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyBoardViewEndFrame.height, right: 0)
        }
            scrollView.scrollIndicatorInsets = scrollView.contentInset
        
    }
    
    func addDoneButtonOnKeyboard(textField: UITextField) {
        
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
           doneToolbar.barStyle       = UIBarStyle.default
        let flexSpace              = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.doneButtonAction))
           
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
           
        doneToolbar.items = items
        doneToolbar.sizeToFit()
           
        textField.inputAccessoryView = doneToolbar
        
    }
       
    @objc func doneButtonAction() {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
      

}

class EmailValidation{
    class func isValidEmail(emailStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailStr)
    }
}

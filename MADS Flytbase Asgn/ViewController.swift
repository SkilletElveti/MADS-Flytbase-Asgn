//
//  ViewController.swift
//  MADS Flytbase Asgn
//
//  Created by Shubham Vinod Kamdi on 03/09/20.
//  Copyright © 2020 Persausive Tech. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift


class ViewController: UIViewController {

    @IBOutlet weak var one: UIButton!
    @IBOutlet weak var two: UIButton!
    @IBOutlet weak var three: UIButton!
    @IBOutlet weak var four: UIButton!
    @IBOutlet weak var five: UIButton!
    @IBOutlet weak var six: UIButton!
    @IBOutlet weak var seven: UIButton!
    @IBOutlet weak var eight: UIButton!
    @IBOutlet weak var nine: UIButton!
    @IBOutlet weak var zero: UIButton!
    @IBOutlet weak var compute: UIButton!
    @IBOutlet weak var mult: UIButton!
    @IBOutlet weak var add: UIButton!
    @IBOutlet weak var sub: UIButton!
    @IBOutlet weak var div: UIButton!
    @IBOutlet weak var displayLabel: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var clr: UIButton!
    @IBOutlet weak var historyBtn: UIButton!
    @IBOutlet weak var logoutBtn: UIButton!
    
    var hist: [History] = []
    var historyObj: History!
    var db: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.displayLabel.text = ""
        registerNotification()
        
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = false
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        
        createShadow(button: logoutBtn, isOrange: true)
        
        hist = []
        historyBtn.addTarget(self, action: #selector(goToHistory), for: .touchUpInside)
        createShadow(button: historyBtn)
        
        one.addTarget(self, action: #selector(appendInput), for: .touchUpInside)
        createShadow(button: one)
        
        
        two.addTarget(self, action: #selector(appendInput), for: .touchUpInside)
        createShadow(button: two)
        
        three.addTarget(self, action: #selector(appendInput), for: .touchUpInside)
        createShadow(button: three)
        
        four.addTarget(self, action: #selector(appendInput), for: .touchUpInside)
        createShadow(button: four)
        
        five.addTarget(self, action: #selector(appendInput), for: .touchUpInside)
        createShadow(button: five)
        
        six.addTarget(self, action: #selector(appendInput), for: .touchUpInside)
        createShadow(button: six)
        
        seven.addTarget(self, action: #selector(appendInput), for: .touchUpInside)
        createShadow(button: seven)
        
        eight.addTarget(self, action: #selector(appendInput), for: .touchUpInside)
        createShadow(button: eight)
        
        nine.addTarget(self, action: #selector(appendInput), for: .touchUpInside)
        createShadow(button: nine)
        
        zero.addTarget(self, action: #selector(appendInput), for: .touchUpInside)
        createShadow(button: zero)
        
        compute.addTarget(self, action: #selector(appendInput), for: .touchUpInside)
        createShadow(button: compute)
        
        mult.addTarget(self, action: #selector(appendInput), for: .touchUpInside)
        createShadow(button: mult, isOrange: true)
        
        add.addTarget(self, action: #selector(appendInput), for: .touchUpInside)
        createShadow(button: add, isOrange: true)
        
        sub.addTarget(self, action: #selector(appendInput), for: .touchUpInside)
        createShadow(button: sub, isOrange: true)
        
        div.addTarget(self, action: #selector(appendInput), for: .touchUpInside)
        createShadow(button: div, isOrange: true)
        
        displayLabel.delegate = self
        displayLabel.addTarget(self, action: #selector(didChangeInput), for: .editingChanged)
        
        createShadow(button: clr, isOrange: true)
        clr.layer.shadowColor = UIColor.clear.cgColor
        logoutBtn.layer.shadowColor = UIColor.clear.cgColor
        clr.addTarget(self, action: #selector(clearALl), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    
    @objc func goToHistory(){
        
            let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HistoryViewController") as! HistoryViewController
            
            self.present(VC, animated: true)
        
    }
    
    func createShadow(button: UIButton!, isOrange: Bool = false){
        if !isOrange{
             button.backgroundColor = .white
        }
       
        button.clipsToBounds = true
        
        button.layer.shadowColor = UIColor.lightGray.cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        button.layer.shadowOpacity = 1.0
        button.layer.shadowRadius = 0.0
        button.layer.masksToBounds = false
        button.layer.cornerRadius = 4.0
    }

    var input = ""
    var tempCount: Int = 0
    var digits: [Int] = []
    var symbols: [String] = []
    var temp: String = ""
       
    func createSubArrays(){
        if input.first != "-" || input.first != "+" || input.first != "*" || input.first != "/" || input.last != "-" || input.last != "+" || input.last != "*" || input.last != "/"{
            for i in input{
                
                if i != "+" && i != "/" && i != "*" && i != "-"{
                    temp.append(i)
                    tempCount += 1
                    
                }else{
                    
                    tempCount += 1
                    let doubleValue = Int(temp)
                    self.digits.append(doubleValue!)
                    self.symbols.append(String(i))
                    temp = ""
                
                }
                
                if tempCount == input.count{
                    
                    let doubleValue = Int(temp)
                    self.digits.append(doubleValue!)
                    print("OPS => \(symbols)")
                    tempCount = 0
                    print("Digits => \(digits)")
                    opTravers()
                
                }
            }
        }
        
           
       }

        func evaluate(operation: String, left: Int, right: Int, index: Int ) {
            
            switch operation {
                
            case "+":
                digits[index] = left + right
                symbols.remove(at: index)
                digits.remove(at: index + 1)
                break
               
            case "-":
                digits[index] = left - right
                symbols.remove(at: index)
                digits.remove(at: index + 1)
                break
           
            case "*":
                digits[index] = left * right
                symbols.remove(at: index)
                digits.remove(at: index + 1)
                break
            
            case "/":
                digits[index] = left / right
                symbols.remove(at: index)
                digits.remove(at: index + 1)
                break
           
            default:
                break
                
            }
            
        }

        func opTravers(){
           
            let count = symbols.count
            
            for i in 0 ..< count{
                
               if let index = symbols.firstIndex(of: "*"){
                   evaluate(operation: "*", left: digits[index], right:  digits[index + 1 ] , index: index )
                   if i == count - 1{
                        self.displayOutput()
                   }
                   continue
               }
               
               if let index = symbols.firstIndex(of: "+"){
                   evaluate(operation: "+", left: digits[index ], right:  digits[index + 1 ] , index: index )
                   if i == count - 1{
                       self.displayOutput()
                   }
                   continue
               }
               
               if let index = symbols.firstIndex(of: "/"){
                   evaluate(operation: "/", left: digits[index ], right:  digits[index + 1 ] , index: index )
                   if i == count - 1{
                        self.displayOutput()
                   }
                   continue
               }
               
               if let index = symbols.firstIndex(of: "-"){
                   evaluate(operation: "-", left: digits[index ], right:  digits[index + 1 ] , index: index )
                   if i == count - 1{
                        self.displayOutput()
                   }

                   continue
               }
               
               
               
               
            }
            
        }
    
    func displayOutput(){
        
        print(digits[0])
        self.historyObj.result = "\(digits[0])"
        self.input = ""
        self.input = "\(digits[0])"
        self.displayLabel.text = input
        self.symbols = []
        self.digits = []
        self.temp = ""
        var ref: DocumentReference? = nil
        
        db.collection("FRESH").getDocuments() {
            (querySnapshot, err) in
            if let err = err
            {
                print("Error getting documents: \(err)");
            }
            else
            {
                var count = 0
                for document in querySnapshot!.documents {
                    
                    print("\(document.documentID) => \(document.data())")
                    let some = document.data()
                    let name: String = "\(some["NAME"]!)"
                    
                    if name == UserDefaults.standard.string(forKey: Constant.first_name){
                    
                       count += 1
                        
                    }
                   
                }

                print("Count = \(count)")
                if count < 10{
                    
                           
                    ref = self.db.collection("FRESH").addDocument(data: [
                            "INPUT": self.historyObj.input,
                            "RESULT": self.historyObj.result,
                            "NAME": UserDefaults.standard.string(forKey: Constant.first_name)!
                                        ]){
                                                  err in
                                                  if let err = err {
                                                      print("Error adding document: \(err)")
                                                  } else {
                                                      print("Document added with ID: \(ref!.documentID)")
                                                  }
                                              }
                          
                }
            }
        }
        
        
        

    }
    
    @objc func clearALl(){
        self.symbols = []
        self.digits = []
        self.temp = ""
        self.input = ""
        self.displayLabel.text = ""
        self.view.endEditing(true)
    }
    
    @IBAction func appendInput(_ sender: UIButton){
        if sender == zero{
            
             self.displayLabel.text! += "0"
             self.input = self.displayLabel.text!
            
        }else if sender == one{
            
            self.displayLabel.text! += "1"
             self.input = self.displayLabel.text!
            
        }else if sender == two{
            
           self.displayLabel.text! +=  "2"
             self.input = self.displayLabel.text!
            
        }else if sender == three{
            self.displayLabel.text! +=  "3"
            self.input = self.displayLabel.text!
            
        }else if sender == four{
             self.displayLabel.text! +=  "4"
             self.input = self.displayLabel.text!
            
        }else if sender == five{
             self.displayLabel.text! +=  "5"
             self.input = self.displayLabel.text!
            
        }else if sender == six{
            self.displayLabel.text! +=  "6"
            self.input = self.displayLabel.text!
            
        }else if sender == seven{
             self.displayLabel.text! += "7"
            self.input = self.displayLabel.text!
            
        }else if sender == eight{
             self.displayLabel.text! += "8"
             self.input = self.displayLabel.text!
            
        }else if sender == nine{
           
            self.displayLabel.text! += "9"
            
        }else if sender == mult{
            
            if input.last != "+" && input.last != "/" && input.last != "*" && input.last != "-"{
                
                self.displayLabel.text! +=  "*"
                 self.input = self.displayLabel.text!
                
            }
            
            
        }else if sender == add{
            
            if input.last != "+" && input.last != "/" && input.last != "*" && input.last != "-"{
                 self.displayLabel.text! +=  "+"
                self.input = self.displayLabel.text!
            }
            
            
        }else if sender == sub{
            
            if input.last != "+" && input.last != "/" && input.last != "*" && input.last != "-"{
                
                 self.displayLabel.text! +=  "-"
                self.input = self.displayLabel.text!
                
            }
            
        }else if sender == div{
            
            if input.last != "+" && input.last != "/" && input.last != "*" && input.last != "-"{
                 self.displayLabel.text! +=  "/"
                self.input = self.displayLabel.text!
            }
            
        }else if sender == compute{
            if input.contains("+") || input.contains("*") || input.contains("/") || input.contains("-"){
                
               
                   if input.first != "-" && input.first != "+" && input.first != "*" && input.first != "/" && input.last != "-" && input.last != "+" && input.last != "*" && input.last != "/"{
                        if input.contains("+") || input.contains("*") || input.contains("/") || input.contains("-"){
                            
                             validate()
                        }
                    }
                
            }
            
        }
    }
    
    var revFlag: Bool = false
    var revCount: Int = 0
    @objc func didChangeInput(){
        self.input = displayLabel.text!
        
    }
    
    @IBAction func logout(){
        UserDefaults.standard.removeObject(forKey: Constant.token)
        UserDefaults.standard.removeObject(forKey: Constant.first_name)
        UserDefaults.standard.removeObject(forKey: Constant.IS_LOGGED_IN)
        UserDefaults.standard.synchronize()
        let app = UIApplication.shared.delegate as! AppDelegate
        app.redirect()
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

    func validate(){
        revCount = 0
        for i in input{
            revCount += 1
            if  revFlag == true && (i == "+" || i == "*" || i == "/" || i == "-"){
               
                revFlag = false
                break
                
            }else if i != "+" || i != "*" || i != "/" || i != "-"{
                 revFlag = false
            }
            
            if i == "+" || i == "*" || i == "/" || i == "-"{
                revFlag = true
                continue
            }
            
             if revCount == input.count {
                revCount = 0
                historyObj = History()
                self.historyObj.input = input
                self.createSubArrays()
                
            }
        }
    }
    
}

extension ViewController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard CharacterSet(charactersIn: "0123456789+-/*").isSuperset(of: CharacterSet(charactersIn: string)) else {
            return false
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if !textField.text!.isEmpty{
            self.view.endEditing(true)
            self.input = self.displayLabel.text!
           
            if input.first != "-" && input.first != "+" && input.first != "*" && input.first != "/" && input.last != "-" && input.last != "+" && input.last != "*" && input.last != "/"{
                if input.contains("+") || input.contains("*") || input.contains("/") || input.contains("-"){
                    
                    validate()
                }
            }
            
        }else{
            self.view.endEditing(true)
        }
        
      
       return true
    }
    
}

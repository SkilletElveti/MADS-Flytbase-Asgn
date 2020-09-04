//
//  HistoryViewController.swift
//  MADS Flytbase Asgn
//
//  Created by Shubham Vinod Kamdi on 03/09/20.
//  Copyright © 2020 Persausive Tech. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift
import SystemConfiguration

class HistoryViewController: UIViewController {

    @IBOutlet weak var historyTable: UITableView!
    var history: [History]!
    var db: Firestore!
    var ifFirstTime: Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if Reachability.isInternetAvailable(){
            
            if ifFirstTime{
                self.history = []
                getDataFromFirebase()
                ifFirstTime = false
            }
            
            
            
        }else{
            
            print("Error No Internet!")
            
        }
       
    }
    
    func getDataFromFirebase(){
       
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
                    count += 1
                  //  print("\(document.documentID) => \(document.data())")
                    let some = document.data()
                    var hist: History = History()
                    let name: String = "\(some["NAME"]!)"
                    
                    if name == UserDefaults.standard.string(forKey: Constant.first_name){
                    
                        hist.input = "\(some["INPUT"] ?? "Unavl")"
                        hist.result = "\(some["RESULT"] ?? "Unavl")"
                        hist.id = "\(document.documentID)"
                        
                        self.history.append(hist)
                        self.historyTable.delegate = self
                        self.historyTable.dataSource = self
                        self.historyTable.reloadData()
                    
                    }
                   
                }

                print("Count = \(count)");
            }
        }
        
    }
    
    @objc func deleteFunc(_ sender: UITapGestureRecognizer){
        if let view = sender.view{
            let index = view.tag
            self.db.collection("FRESH")
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    // Some error occured
                } else {
                    for document in querySnapshot!.documents{
                        let data = document.data()
                        let name: String = data["NAME"] as! String
                        let id = self.history[index].id
                        
                        if document.documentID ==  id && name == UserDefaults.standard.string(forKey: Constant.first_name)!{
                            
                            self.db.collection("FRESH").document(document.documentID).updateData([
                               "NAME": ""
                            ]) { err in
                                if let err = err {
                                    print("Error updating document: \(err)")
                                } else {
                                    print("Document successfully updated")
                                    self.history.remove(at: index)
                                    self.historyTable.reloadData()
                                                    
                                }
                            }
                            
                           
                        }
                    }
                }
            }
        }
    }
    


}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell") as! HistoryCell
        cell.resultLabel.text = "Result: " + history[indexPath.row].result
        cell.inputLabel.text = "Input: " + history[indexPath.row].input
        cell.delete.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(deleteFunc(_:))))
        cell.delete.tag = indexPath.row
        return cell
    }
    
}


class HistoryCell: UITableViewCell {
    
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var inputLabel: UILabel!
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var delete: UIButton!
}



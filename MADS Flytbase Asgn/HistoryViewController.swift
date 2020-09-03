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
                    print("\(document.documentID) => \(document.data())")
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
    


}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell") as! HistoryCell
        cell.resultLabel.text = "Result: " + history[indexPath.row].result
        cell.inputLabel.text = "Input: " + history[indexPath.row].input
        return cell
    }
    
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.db.collection("users").document(self.history[indexPath.row].id).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                    self.history.remove(at: indexPath.row)
                    self.historyTable.deleteRows(at: [indexPath], with: .fade)
                }
            }
            
        } else if editingStyle == .insert {
            
        }
    }
}


class HistoryCell: UITableViewCell {
    
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var inputLabel: UILabel!
    @IBOutlet weak var parentView: UIView!
    
}


class Reachability {
    
    class func isInternetAvailable() -> Bool{
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
    class func getIP()-> String? {
        
        var address: String?
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            
            var ptr = ifaddr
            while ptr != nil {
                defer { ptr = ptr?.pointee.ifa_next } // memory has been renamed to pointee in swift 3 so changed memory to pointee
                
                let interface = ptr?.pointee
                let addrFamily = interface?.ifa_addr.pointee.sa_family
                if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                    
                    if let name: String = String(cString: (interface?.ifa_name)!), name == "en0" {  // String.fromCString() is deprecated in Swift 3. So use the following code inorder to get the exact IP Address.
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        getnameinfo(interface?.ifa_addr, socklen_t((interface?.ifa_addr.pointee.sa_len)!), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST)
                        address = String(cString: hostname)
                    }
                }
            }
            freeifaddrs(ifaddr)
        }
        
        return address
    }
}



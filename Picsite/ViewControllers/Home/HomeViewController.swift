//
//  HomeViewController.swift
//  Picsite
//
//  Created by Marc Hidalgo on 25/2/22.
//

import UIKit
import BSWInterfaceKit
import PicsiteUI

class HomeViewController: UIViewController {
    
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .red
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let docData: [String: Any] = [
//            "stringExample": "Hello world!",
//            "booleanExample": true,
//            "numberExample": 3.14159265,
//            "arrayExample": [5, true, "hello"],
//            "nullExample": NSNull(),
//            "objectExample": [
//                "a": 5,
//                "b": [
//                    "nested": "foo"
//                ]
//            ]
//        ]
////        let settings = Firestore.firestore().settings
////        settings.host = "localhost:8080"
////        settings.isPersistenceEnabled = false
////        settings.isSSLEnabled = false
////        Firestore.firestore().settings = settings
//
//        let db = Firestore.firestore()
//        db.collection("data").document("two").setData(docData) { err in
//            if let err = err {
//                print("Error writing document: \(err)")
//            } else {
//                print("Document successfully written!")
//            }
//        }
    }
}




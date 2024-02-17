//
//  HomeViewController.swift
//  Picsite
//
//  Created by Marc Hidalgo on 25/2/22.
//

import UIKit
import BSWInterfaceKit
import PicsiteUI
import Firebase

class HomeViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.title = "tabbar-controller-profile-title".localized
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "sign-out".localized
        return cell
    }

    // MARK: - Table view delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let firebaseAuth = Auth.auth()
        performBlockingTask(loadingMessage: "sign-out-loading-title".localized, errorMessage: "Error".localized) {
            try firebaseAuth.signOut()
            try await Task.sleep(nanoseconds: 1_000_000_000)
            SceneDelegate.main?.updateContainedViewController()
        }
    }
}



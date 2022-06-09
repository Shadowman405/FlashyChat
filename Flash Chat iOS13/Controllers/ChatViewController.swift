//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {
    
    var messages: [Message] = [
        Message(sender: "1@2.com", body: "Sosi pes"),
        Message(sender: "UncleBogdan@bebra.ru", body: "Do you like what you see slave??"),
        Message(sender: "Vansama@gmail.com", body: "Hoi-hoi-hoi , Im fckng cumming")
    ]

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
        navigationItem.hidesBackButton = true
        title = K.appName
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
            do {
                    try Auth.auth().signOut()
                    navigationController?.popToRootViewController(animated: true)
                } catch let signOutError as NSError {
                    print("Error signing out: %@", signOutError)
                }
        }
    
}

extension ChatViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath)
        cell.textLabel?.text = messages[indexPath.row].body
        
        return cell
    }
    
}

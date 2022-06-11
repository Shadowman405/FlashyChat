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
    
    var messages: [Message] = []
    let db = Firestore.firestore()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
        navigationItem.hidesBackButton = true
        title = K.appName
        
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        loadMessages()
    }
    
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email {
            db.collection(K.FStore.collectionName).addDocument(data: [K.FStore.senderField: messageSender, K.FStore.bodyField: messageBody]) { error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                        print("Data saved")
                }
            }
        }
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


// MARK: - Extensions

extension ChatViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        cell.title.text = messages[indexPath.row].body
        
        return cell
    }
    
    func loadMessages() {
        db.collection(K.FStore.collectionName).addSnapshotListener { querySnapshot, error in
            self.messages = []
            if let error = error {
                print(error.localizedDescription)
            } else {
                if let snapshotDocs = querySnapshot?.documents {
                    for document in snapshotDocs {
                        let data = document.data()
                        if let sender = data[K.FStore.senderField] as? String, let messageBody = data[K.FStore.bodyField] as? String {
                            let newMessage = Message(sender: sender, body: messageBody)
                            self.messages.append(newMessage)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
    
}

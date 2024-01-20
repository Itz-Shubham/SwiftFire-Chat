//
//  HomeViewController.swift
//  SwiftFire Chat
//
//  Created by Shubham on 18/01/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class HomeViewController: UIViewControllerWithKeyboardManager {
    
    var messages: [Message] = []
    var messageService = MessageService()
    let currentUser = AuthService.currentUser
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var textFieldBottomConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if  currentUser == nil {
            navigationController?.popToRootViewController(animated: true)
        } else {
            print(currentUser!.uid)
            messageService.delegate = self
            navigationItem.hidesBackButton = true
            title = K.appName
            tableView.dataSource = self
            tableView.register(UINib(nibName: K.messageCell, bundle: nil), forCellReuseIdentifier: K.reusableCell)
            messageService.messageListerner()
        }
    }
    
    @IBAction func onLogoutButtonPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signoutError as NSError {
            print("Error siging out%: @", signoutError)
        }
    }
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        messageService.sendMessage(text: messageTextField.text)
    }
    
    override func onKeyboardStateChange(iskeyboardActive: Bool, height: CGFloat) {
        if iskeyboardActive {
            self.textFieldBottomConstraint?.constant = 32
        } else {
            self.textFieldBottomConstraint?.constant = height + 16 // for bottom padding
        }
    }
    
    
}

// MARK: - Table Data Source
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.reusableCell, for: indexPath) as! MessageCell
        cell.messageLabel.text = messages[indexPath.row].content
        cell.userNameLabel.text = messages[indexPath.row].senderName
        if currentUser!.uid == messages[indexPath.row].senderId {
            cell.userImage1.isHidden = true
            cell.userNameLabel.textAlignment = .right
            cell.leadingConstraint.constant = 96
            cell.messageBubble.backgroundColor = .white
        }
        else {
            cell.userImage2.isHidden = true
            cell.userNameLabel.textAlignment = .left
            cell.trailingContraint.constant = 96
        }
        
            
            return cell
        }
        
    }
    
    // MARK: - Message Stream
    extension HomeViewController: MessageDelegate {
        func messageSendingError(error: String?) {
            if error != nil {
                print(error!)
            } else {
                self.messageTextField.text = ""
            }
        }
        
        func didUpdateMessages(messages: [Message]) {
            DispatchQueue.main.async {
                self.messages = messages
                self.tableView.reloadData()
                if self.messages.count > 0 {
                    let indexPath = IndexPath(row: self.messages.count-1, section: 0)
                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                }
            }
        }
        
    }
    

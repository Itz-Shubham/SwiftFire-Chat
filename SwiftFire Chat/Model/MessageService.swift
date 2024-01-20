//
//  FirestoreService.swift
//  SwiftFire Chat
//
//  Created by Shubham on 19/01/24.
//

import FirebaseAuth
import FirebaseFirestore

protocol MessageDelegate {
    func didUpdateMessages(messages: [Message])
    func messageSendingError(error: String?)
    // func didFailWithError(error: Error)
}

struct MessageService {

    var delegate: MessageDelegate?
    
    let collection = Firestore.firestore().collection(K.FStore.messageCollection)
    let currentUser = Auth.auth().currentUser
    
    func sendMessage(text: String?) {
        if currentUser == nil {
            self.delegate?.messageSendingError(error: "User is not logged in")
        } else if let messageText = text {
            if messageText.isEmpty {
                self.delegate?.messageSendingError(error: "Text is empty")
            }
            let data = Message.toDict(Message(
                senderId: currentUser!.uid,
                senderName: currentUser?.displayName ?? "Unknown",
                content: messageText
            ))
            collection.addDocument(data: data) { (error) in
                if let e = error {
                    self.delegate?.messageSendingError(error: "Error in sending message: \(e)")
                } else {
                    self.delegate?.messageSendingError(error: nil)
                }
            }
        }
    }
        
    func messageListerner() {
        collection.order(by: "datetime").addSnapshotListener { querySnapshot, error in
            if let e = error {
                print("Error in listing firestore: \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    var newMessages: [Message] = []
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        newMessages.append(Message.fromDocumentSnapshot(data: data))
                    }
                    self.delegate?.didUpdateMessages(messages: newMessages)
                }
            }
        }
    }
}



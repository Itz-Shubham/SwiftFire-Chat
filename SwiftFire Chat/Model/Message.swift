//
//  Message.swift
//  SwiftFire Chat
//
//  Created by Shubham on 19/01/24.
//

import FirebaseFirestore

struct Message {
    var senderId: String
    var senderName: String
    var type: String = "text"
    var content: String
    // var datetime: Any
    
    static func fromDocumentSnapshot(data:[String: Any]) -> Message {
        return Message(
            senderId: data["sender_id"] as? String ?? "",
            senderName: data["sender_name"] as? String ?? "",
            // type: data["type"] as? String ?? "text",
            content: data["content"] as? String ?? ""
            // datetime: data["date"] as? String ?? ""
        )
    }
    
    static func toDict(_ message:Message) -> [String: Any] {
        return [
            "sender_id" : message.senderId,
            "sender_name": message.senderName,
            // "type": "text",
            "content": message.content,
            "datetime": FieldValue.serverTimestamp()
        ]
    }
}

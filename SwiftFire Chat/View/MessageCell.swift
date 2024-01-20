//
//  MessageCell.swift
//  SwiftFire Chat
//
//  Created by Shubham on 19/01/24.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var userImage1: UIImageView!
    @IBOutlet weak var userImage2: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageBubble: UIView!

    @IBOutlet weak var trailingContraint: NSLayoutConstraint!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear // this
        messageBubble.layer.cornerRadius = 16
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

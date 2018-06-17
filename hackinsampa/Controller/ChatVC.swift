//
//  ChatVC.swift
//  hackinsampa
//
//  Created by Carlos Doki on 16/06/18.
//  Copyright © 2018 Carlos Doki. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import SwiftKeychainWrapper

class ChatVC: JSQMessagesViewController {

    var  messages = [JSQMessage]()
    var postKey: String!
    var nroLiticacao: String!
    
    lazy var outgoingBubble: JSQMessagesBubbleImage = {
        return JSQMessagesBubbleImageFactory()!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }()
    
    lazy var incomingBubble: JSQMessagesBubbleImage = {
        return JSQMessagesBubbleImageFactory()!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViewOnTop()
        
        automaticallyScrollsToMostRecentMessage = true
        
        senderId = KeychainWrapper.standard.string(forKey: KEY_UID)!
        senderDisplayName = "..."
        
        self.collectionView?.collectionViewLayout.sectionInset = UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0)
        
        collectionView.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
        let query = Constants.refs.databaseChats.queryLimited(toLast: 10)
        
        _ = query.observe(.childAdded, with: { [weak self] snapshot in
            
            if  let data        = snapshot.value as? [String: String],
                let id          = data["sender_id"],
                let name        = data["name"],
                let text        = data["text"],
                !text.isEmpty
            {
                if let message = JSQMessage(senderId: id, displayName: name, text: text)
                {
                    self?.messages.append(message)
                    
                    self?.finishReceivingMessage()
                }
            }
        })
        
        
    }
    
    func addViewOnTop() {
        let selectableView2 = UIView(frame: CGRect(x: 0, y: 10, width: self.view.bounds.width, height: 60))
        //        selectableView2.backgroundColor = UIColor(displayP3Red: 53/255, green: 112/255, blue: 255/255, alpha: 1.0)
        //        selectableView2.backgroundColor = UIColor.gray
        //var color1 = hexStringToUIColor(hex: "#3570FF")
        //selectableView2.backgroundColor = color1
        
        let randomViewLabel = UILabel(frame: CGRect(x: 100, y: 15, width: 250, height: 16))
        randomViewLabel.text = nroLiticacao
        
        let button = UIButton(type: .system) // let preferred over var here
        button.frame = CGRect(x: 8, y: 8, width: 50, height: 30)
        //button.backgroundColor = UIColor.white
       button.setTitle("Voltar", for: .normal)
//        button.setImage(#imageLiteral(resourceName: "backAsset 3"), for:UIControlState.normal)
        button.addTarget(self, action: #selector(buttonAction), for: UIControlEvents.touchUpInside)
        
        
        selectableView2.addSubview(randomViewLabel)
        selectableView2.addSubview(button)
        
//        view.addSubview(selectableView)
        view.addSubview(selectableView2)
    }
    
    @objc func buttonAction(sender: UIButton!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource!
    {
        return messages[indexPath.item].senderId == senderId ? outgoingBubble : incomingBubble
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource!
    {
        return nil
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString!
    {
        return messages[indexPath.item].senderId == senderId ? nil : NSAttributedString(string: messages[indexPath.item].senderDisplayName)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat
    {
        return messages[indexPath.item].senderId == senderId ? 0 : 15
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!)
    {
        let ref = Constants.refs.databaseChats.childByAutoId()
//       let ref = DB_BASE.child("licitacao").child(postKey).child("post").childByAutoId()
//  orgao/postkey/OC/postkey/chat
        
        let message = ["sender_id": senderId, "name": senderDisplayName, "text": text]
        
        ref.setValue(message)
        
        finishSendingMessage()
    }
}

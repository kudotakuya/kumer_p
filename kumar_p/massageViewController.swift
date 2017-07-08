//
//  massageViewController.swift
//  kumar_p
//
//  Created by Takuya Kudo on 2017/07/08.
//  Copyright © 2017年 Takuya Kudo. All rights reserved.
//

import UIKit
import JSQMessagesViewController

class massageViewController: JSQMessagesViewController { // ViewControllerからJSQMessagesViewControllerに変更する
    
    var messages: [JSQMessage] = [
        JSQMessage(senderId: "child", displayName: "B", text: "もうやだー"),
        JSQMessage(senderId: "Parent",  displayName: "A", text: "どうしたの？"),
        JSQMessage(senderId: "child", displayName: "B", text: "つかれたー"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 適当につける
        senderDisplayName = "A"
        senderId = "Parent"
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "background.png")?.draw(in: self.view.bounds)
        
        let image: UIImage! = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        
        self.view.backgroundColor = UIColor(patternImage: image)
    }
    
    //アイテムごとに参照するメッセージデータを返す
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.row]
    }
    
    
    //アイテムごとのMessageBubble(背景)を返す
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        if messages[indexPath.row].senderId == senderId {
            return JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(
                with: UIColor(red: 112/255, green: 192/255, blue:  75/255, alpha: 1))
        } else {
            return JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(
                with: UIColor(red: 229/255, green: 229/255, blue: 229/255, alpha: 1))
        }
    }
    
    
    // cell for item
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        
        if messages[indexPath.row].senderId == senderId {
            cell.textView?.textColor = UIColor.white
        } else {
            cell.textView?.textColor = UIColor.darkGray
        }
        return cell
    }
    
    
    // section
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    
    // image data for item
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        
        //senderId == 自分　だった場合表示しない
        let senderId = messages[indexPath.row].senderId
        
        if senderId == "Parent" {
            return nil
        }
        return JSQMessagesAvatarImage.avatar(with: UIImage(named: "boy.png"))
    }
    
    
    //時刻表示のための高さ調整
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        
        let message = messages[indexPath.item]
        if indexPath.item == 0 {
            return nil
        }
        if indexPath.item - 1 > 0 {
            let previousMessage = messages[indexPath.item - 1]
            if message.date.timeIntervalSince(previousMessage.date) / 60 > 1 {
                return nil
            }
        }
        return nil
    }
    
    
    // 送信時刻を出すために高さを調整する
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAt indexPath: IndexPath!) -> CGFloat {
        
        if indexPath.item == 0 {
            return kJSQMessagesCollectionViewCellLabelHeightDefault
        }
        if indexPath.item - 1 > 0 {
            let previousMessage = messages[indexPath.item - 1]
            let message = messages[indexPath.item]
            if message.date .timeIntervalSince(previousMessage.date) / 60 > 1 {
                return kJSQMessagesCollectionViewCellLabelHeightDefault
            }
        }
        return 0.0
    }
    
    //Sendボタンが押された時に呼ばれる
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        //キーボードを閉じる
        self.view.endEditing(true)
        
        //メッセージを追加
        let message = JSQMessage(senderId: senderId, displayName: senderDisplayName, text: text)
        self.messages.append(message!)
        
        //送信を反映
        self.finishReceivingMessage(animated: true)
        
        //textFieldをクリアする
        self.inputToolbar.contentView.textView.text = ""
        
        //テスト返信を呼ぶ
        testRecvMessage()
    }
    
    //テスト用「マグロならあるよ！」を返す
    func testRecvMessage() {
        
        let message = JSQMessage(senderId: "child", displayName: "B", text: "がんばる！")
        self.messages.append(message!)
        self.finishReceivingMessage(animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
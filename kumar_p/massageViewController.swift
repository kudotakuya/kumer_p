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
    
    
    
    var messages: [JSQMessage] = []
    var max = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // 適当につける
        senderDisplayName = "A"
        senderId = "Parent"
        
        
        setData()
        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(massageViewController.getMessage), userInfo: nil, repeats: true)
        
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
        
        let postString = "msg=\(text!)"
        var request = URLRequest(url: URL(string: "https://version1.xyz/spajam2017/parent.php")!)
        
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            (data, response, error) in
            
            if (error == nil) {
                // API通信成功
                print("success")
                print("response: \(response!)")
                print(String(data: data!, encoding: .utf8)!)
            } else {
                // API通信失敗
                print("error")
            }
        })
        task.resume()
    
        //送信を反映
        self.finishReceivingMessage(animated: true)
        
        //textFieldをクリアする
        self.inputToolbar.contentView.textView.text = ""
        
        //テスト返信を呼ぶ
        //testRecvMessage()
    }
    
    //テスト用「マグロならあるよ！」を返す
    func testRecvMessage() {
        
        let message = JSQMessage(senderId: "child", displayName: "B", text: "がんばる！")
        self.messages.append(message!)
        self.finishReceivingMessage(animated: true)
    }
    
    func setData(){
        
        let urlStr = "https://version1.xyz/spajam2017/messages.php"
        if let url = URL(string: urlStr) {
            let req = NSMutableURLRequest(url: url)
            req.httpMethod = "GET"
            let task = URLSession.shared.dataTask(with: req as URLRequest, completionHandler: { (data, resp, err) in
                // print(resp!.url!)
                //print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as Any)
                
                
                // 受け取ったdataをJSONパース、エラーならcatchへジャンプ
                do {
                    // dataをJSONパースし、グローバル変数"getJson"に格納
                    let Json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
                    
                    for i in 0..<Json.count {
                        
                        let list = Json[i] as! [String:Any]
                        
                        var sender = "Parent"
                        var display = "A"
                        
                        if(list["person"] as! Bool){
                            sender = "child"
                            display = "B"
                        }
                        
                        let message = JSQMessage(senderId: sender, displayName: display, text: list["message"] as! String)
                        self.messages.append(message!)
                        self.finishReceivingMessage(animated: true)
                        
                        self.max = list["id"] as! Int
                        
                        
                    }
                    
                    
                } catch {
                    print ("json error")
                    return
                }
                
                
            })
            task.resume()
            
            
        }
    }
    
    func getMessage(){
        
        let min = 5
        let urlStr = "https://version1.xyz/spajam2017/messages.php?id=" + String(max + 1)
        print(urlStr);
        if let url = URL(string: urlStr) {
            let req = NSMutableURLRequest(url: url)
            req.httpMethod = "GET"
            let task = URLSession.shared.dataTask(with: req as URLRequest, completionHandler: { (data, resp, err) in
                // print(resp!.url!)
                //print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as Any)
                
                
                // 受け取ったdataをJSONパース、エラーならcatchへジャンプ
                do {
                    // dataをJSONパースし、グローバル変数"getJson"に格納
                    let Json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
                    
                    for i in 0..<Json.count {
                        
                        let list = Json[i] as! [String:Any]
                        
                        var sender = "Parent"
                        var display = "A"
                        
                        if(list["person"] as! Bool){
                            sender = "child"
                            display = "B"
                        }
                        
                        let message = JSQMessage(senderId: sender, displayName: display, text: list["message"] as! String)
                        self.messages.append(message!)
                        self.finishReceivingMessage(animated: true)
                        
                        self.max = list["id"] as! Int
                        
                    }
                    
                    
                } catch {
                    print ("json error")
                    return
                }
                
                
            })
            task.resume()
            
            
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

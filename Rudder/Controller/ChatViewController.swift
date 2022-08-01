//
//  ChatViewController.swift
//  Rudder
//
//  Created by 박민호 on 2022/06/20.
//

import UIKit

class ChatViewController: UIViewController{
    
    var userInfoId: Int! //채팅 구별 위해
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var chatTableView: UITableView!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    private var chats: [Chat] = [Chat(chatMessageId: 1, chatMessageBody: "my love", chatMessageTime: "my love", sendUserInfoId: 1, sendUserNickname: "myco sdf", isMine: true, chatRoomId: 234)]
    
    private var messageIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userInfoId = UserDefaults.standard.integer(forKey: "userInfoId")
        chatTableView.separatorStyle = .none
        
        let myCellNib: UINib = UINib.init(nibName: "MyChatCell", bundle: nil)
        self.chatTableView.register(myCellNib, forCellReuseIdentifier: "myChatCell")
        
        let yourCellNib: UINib = UINib.init(nibName: "YourChatCell", bundle: nil)
        self.chatTableView.register(yourCellNib, forCellReuseIdentifier: "yourChatCell")
        
        //refreshControll에 관한것들
        
        self.chatTableView.estimatedRowHeight = 200 //autolatyout 잘 작동하게 대략적인 높이?
        self.chatTableView.rowHeight = UITableView.automaticDimension
        // Do any additional setup after loading the view.
    }
}


extension ChatViewController {
    func handleMessageBody(message: Data){
        print("touch here")
        let decoder:JSONDecoder = JSONDecoder()
        do {
            
            let decodedResponse: Chat = try decoder.decode(Chat.self, from: message)
            DispatchQueue.main.async {
                
                print("비교" + String(decodedResponse.sendUserInfoId) + " " + String(self.userInfoId))
                
                guard decodedResponse.sendUserInfoId != self.userInfoId else {return}
                
                self.chats.append(Chat(chatMessageId: decodedResponse.chatMessageId, chatMessageBody: decodedResponse.chatMessageBody, chatMessageTime: decodedResponse.chatMessageTime, sendUserInfoId: decodedResponse.sendUserInfoId, sendUserNickname: decodedResponse.sendUserNickname, isMine: decodedResponse.isMine, chatRoomId: 123))
                //mock
                
             
                
                self.chatTableView.beginUpdates()
                self.chatTableView.insertRows(at: [IndexPath.init(row: self.chats.count-1, section: 0)], with: .none)
                self.chatTableView.endUpdates()
                let indexPath = NSIndexPath(item: self.chats.count-1, section: 0);
                self.chatTableView.scrollToRow(at: indexPath as IndexPath, at: UITableView.ScrollPosition.middle, animated: true)
                //self.textField.text = decodedResponse.chatMessageBody
               // completion(decodedResponse.likeCount)
            }
        } catch {
            print("응답 디코딩 실패")
            print(error.localizedDescription)
            dump(error)
            DispatchQueue.main.async {
               // completion(-1)
            }
        }
    }
    
    @IBAction func sendChat(_ sender: UIButton) {
        
        self.chats.append(Chat(chatMessageId: 123, chatMessageBody: textField.text!, chatMessageTime: "123", sendUserInfoId: userInfoId, sendUserNickname: "mockNickname", isMine: true, chatRoomId: 123))
        
     
        
        self.chatTableView.beginUpdates()
        self.chatTableView.insertRows(at: [IndexPath.init(row: self.chats.count-1, section: 0)], with: .none)
        self.chatTableView.endUpdates()
        let indexPath = NSIndexPath(item: self.chats.count-1, section: 0);
        self.chatTableView.scrollToRow(at: indexPath as IndexPath, at: UITableView.ScrollPosition.middle, animated: true)
        
        RequestSendChat.uploadInfo(channelId: 1, chatBody: textField.text!, completion: {
           status in
            if status == 1 {
                print("send chat success")
            }
        })
    }
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let myCell: MyChatCell
        myCell = tableView.dequeueReusableCell(withIdentifier: "myChatCell", for: indexPath) as! MyChatCell
        let yourCell: YourChatCell
        yourCell = tableView.dequeueReusableCell(withIdentifier: "yourChatCell", for: indexPath) as! YourChatCell
        // cell.delegate = self
        
        guard indexPath.row < chats.count else {
            return myCell
        }
        
        let chat: Chat = chats[indexPath.row]
        
        if userInfoId == chat.sendUserInfoId {
            myCell.configure(chat: chat, tableView: chatTableView, indexPath: indexPath)
            return myCell
        } else {
            yourCell.configure(chat: chat, tableView: chatTableView, indexPath: indexPath)
            return yourCell
        }
        //endPostId = post.postId
     
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*if let cell: UITableViewCell = tableView.cellForRow(at: indexPath) {
            indexPathForSelectedRow = indexPath as NSIndexPath
            self.performSegue(withIdentifier: "ShowMessageRoom", sender: cell)
            //indexPathForSelectedRow = indexPath as NSIndexPath
           // cell.selectionStyle = .none
        }*/
    }
}


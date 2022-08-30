//
//  ChatViewController.swift
//  Rudder
//
//  Created by 박민호 on 2022/06/20.
//

import UIKit

class ChatViewController: UIViewController, UIGestureRecognizerDelegate{
    
    var userInfoId: Int! //채팅 구별 위해
    var chatRoomId: Int!
    var endChatMessageId: Int  = -1
    var nowPaging: Bool = true
    var isInit: Bool = true
    
    @IBOutlet weak var textField: UITextField!

    @IBOutlet weak var chatTableView: UITableView!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    private var chats: [Chat] = []
    private var messageIndex = 0
    
    private var originalY: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.startAnimating()
        
        hideKeyboardWhenTappedAround()
       // textField.bor
        
        requestOldChats(endChatMessageId: -1)
        let k_moveToNotification = Notification.Name("chatReceived") //이거이름재설정 필요
        NotificationCenter.default.addObserver(self, selector: #selector(self.receivedChat(notification:)), name: k_moveToNotification, object: nil)

        userInfoId = UserDefaults.standard.integer(forKey: "userInfoId")
        chatTableView.separatorStyle = .none
        
        let myCellNib: UINib = UINib.init(nibName: "MyChatCell", bundle: nil)
        self.chatTableView.register(myCellNib, forCellReuseIdentifier: "myChatCell")
        
        let yourCellNib: UINib = UINib.init(nibName: "YourChatCell", bundle: nil)
        self.chatTableView.register(yourCellNib, forCellReuseIdentifier: "yourChatCell")
        
        let yourFirstCellNib: UINib = UINib.init(nibName: "YourFirstChatCell", bundle: nil)
        self.chatTableView.register(yourFirstCellNib, forCellReuseIdentifier: "yourFirstChatCell")
        
        //refreshControll에 관한것들
        
        self.chatTableView.estimatedRowHeight = 200 //autolatyout 잘 작동하게 대략적인 높이?
        self.chatTableView.rowHeight = UITableView.automaticDimension
        // Do any additional setup after loading the view.
        
        
        
    }
    
    override func viewDidLayoutSubviews() {
        originalY = self.view.frame.origin.y
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    
    @objc func receivedChat(notification: NSNotification){
        print("recieved chat")
        let currentChat = notification.userInfo!["receivedChat"] as? Chat
        handleMessageBody(chat: currentChat!)
    }
}


extension ChatViewController {
    func handleMessageBody(chat: Chat){
        print("touch here")
        print("비교" + String(chat.sendUserInfoId) + " " + String(self.userInfoId))
        print("비교2 " + String(chat.chatRoomId) + " " + String(self.chatRoomId))
                
        if chat.sendUserInfoId == self.userInfoId && chat.chatRoomId == self.chatRoomId{
            self.spinner.stopAnimating()
            self.view.isUserInteractionEnabled = true
        }
                
        self.chats.append(chat)
        
        self.chatTableView.beginUpdates()
        self.chatTableView.insertRows(at: [IndexPath.init(row: self.chats.count-1, section: 0)], with: .none)
        self.chatTableView.endUpdates()
        let indexPath = NSIndexPath(item: self.chats.count-1, section: 0);
        self.chatTableView.scrollToRow(at: indexPath as IndexPath, at: UITableView.ScrollPosition.middle, animated: true)
                //self.textField.text = decodedResponse.chatMessageBody
               // completion(decodedResponse.likeCount)
        
    }
    
        

    
    @IBAction func sendChat(_ sender: UIButton) {
        
        spinner.startAnimating()
        self.view.isUserInteractionEnabled = false
        let chatText = textField.text!
        textField.text = nil
        RequestSendChat.uploadInfo(channelId: chatRoomId, chatBody: chatText, completion: {
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
        let yourFirstCell: YourFirstChatCell
        yourFirstCell = tableView.dequeueReusableCell(withIdentifier: "yourFirstChatCell", for: indexPath) as! YourFirstChatCell
        // cell.delegate = self
        
        guard indexPath.row < chats.count else {
            return myCell
        }
        
        let chat: Chat = chats[indexPath.row]
        
        if userInfoId == chat.sendUserInfoId {
            myCell.configure(chat: chat, tableView: chatTableView, indexPath: indexPath)
            return myCell
        } else {
            if indexPath.row == 0 || chats[indexPath.row - 1].sendUserInfoId != chat.sendUserInfoId {
                yourFirstCell.configure(chat: chat, tableView: chatTableView, indexPath: indexPath)
                return yourFirstCell
            } else {
                yourCell.configure(chat: chat, tableView: chatTableView, indexPath: indexPath)
                return yourCell
            }
        }
        //endPostId = post.postId
     
        
    }
}


extension ChatViewController {
    func requestOldChats(endChatMessageId: Int) {
        RequestOldChat.uploadInfo(chatRoomId: chatRoomId, endChatMessageId: endChatMessageId, completion: {(chats: [Chat]?) in
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
            }
            guard var chats = chats else { self.nowPaging = false; return }
            guard chats.count != 0 else {
                DispatchQueue.main.async {Alert.showAlert(title: "No more chats", message: nil, viewController: self) }
                return
            }
            
            chats.reverse()
            
            print("chat count ",String(chats.count))
            self.endChatMessageId = chats[0].chatMessageId
            self.chats = chats + self.chats
            DispatchQueue.main.async{
                self.chatTableView.reloadSections(IndexSet(0...0),
                                                  with: UITableView.RowAnimation.automatic)
                var indexPath = NSIndexPath(item: chats.count, section: 0)
                if self.isInit { indexPath = NSIndexPath(item: chats.count - 1, section: 0) }
                self.chatTableView.scrollToRow(at: indexPath as IndexPath, at: UITableView.ScrollPosition.top, animated: false)
            }
            self.nowPaging = false
        })
    }
}

extension ChatViewController {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.contentOffset.y <= 0 else { return }
        if !nowPaging {
            nowPaging = true
            spinner.startAnimating()
            requestOldChats(endChatMessageId: endChatMessageId)
        }
   }
    
    func hideKeyboardWhenTappedAround() {
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            tap.delegate = self
            tap.cancelsTouchesInView = false
            view.addGestureRecognizer(tap)
    }
                                                                   
    @objc func dismissKeyboard(){
        view.endEditing(true)
                
    }
                                                                     
    @objc func keyboardWillShow(_ sender: Notification) {
        guard let keyboardSize = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
               // if keyboard size is not available for some reason, dont do anything
               return
    
        }

            //let keyboardHeight = keyboardRect.height
        self.view.frame.origin.y = 0 - keyboardSize.height + 105
            //self.textField.frame.origin.y = keyboardRect.origin.y - self.textField.frame.height
            //commentTableView.contentSize.height += keyboardRect.height
        }
        @objc func keyboardWillHide(_ sender: Notification) {
            let keyboardFrame: NSValue = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
            let keyboardRect = keyboardFrame.cgRectValue
            self.view.frame.origin.y = originalY // Move view to original position
            //commentTableView.contentSize.height -= keyboardRect.height
        }
}

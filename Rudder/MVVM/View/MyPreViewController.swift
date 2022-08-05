//
//  MyPreViewController.swift
//  Rudder
//
//  Created by 박민호 on 2022/07/05.
//

import UIKit

class MyPreViewController: UIViewController {
    
    let viewModel = MyPreViewModel()

    //@IBOutlet weak var aGChatView: UIView!
    @IBOutlet weak var aGPartyTitle: UILabel! //accepted group chat view
    @IBOutlet weak var aGChatBody: UILabel!
    @IBOutlet weak var aGChatImageView: UIImageView!
    
    @IBOutlet weak var applcantsView: UIView!
    @IBOutlet weak var messagesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        setUpBinding()
        viewModel.requestPartyDates()
    }
}

extension MyPreViewController {
    func setUpBinding(){
        viewModel.getPartyDatesFlag.bind{ [weak self] status in
            guard let self = self else {return}
            
            if status == 1 { self.viewModel.requestGroupChatroom(partyId: self.viewModel.myPartyDates[0].partyId)}
            else { print("party date wrong") }
        }
        
        viewModel.getGroupChatRoomFlag.bind{ [weak self] status in
            guard let self = self else {return}
            switch status {
            case 1:
                self.viewModel.requestPartyApplicants(partyId: self.viewModel.myPartyDates[0].partyId)
                DispatchQueue.main.async{self.setAGChatView()}
            default : print("something wrong")
            }
        }
        
        viewModel.getPartyApplicantsFlag.bind{ [weak self] status in
            guard let self = self else {return}
            switch status {
            case 1:
                print("hit setAPpl")
                self.viewModel.requestOTOChatRoom(partyId:  self.viewModel.myPartyDates[0].partyId)
                DispatchQueue.main.async{self.setApplicantsView()}
            default : print("something wrong")
            }
        }
        
        viewModel.getOTOChatRoomFlag.bind{ [weak self] status in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.messagesTableView.reloadSections(IndexSet(0...0), with: UITableView.RowAnimation.automatic)
                self.setOTOChatBinding()
            }
        }
        
        viewModel.receivedGroupChatFlag.bind{ [weak self] _ in
            guard let self = self else {return}
            DispatchQueue.main.async { self.setAGChatView() }
        }
    }
    
    func setOTOChatBinding() {
        for i in 0..<viewModel.otoChatRooms.count {
            viewModel.receivedOTOChatFlag[i].bind{ [weak self] _ in
                guard let self = self else {return}
                let indexPath = IndexPath(row: i, section: 0)
                self.messagesTableView.reloadRows(at: [indexPath], with: .none)
            }
        }
    }
}

extension MyPreViewController {
    func setUpTableView() {
        let cellNib: UINib = UINib.init(nibName: "ChatRoomCell", bundle: nil)
        self.messagesTableView.register(cellNib, forCellReuseIdentifier: "chatRoomCell")
        self.messagesTableView.estimatedRowHeight = 200 //autolatyout 잘 작동하게 대략적인 높이?
        self.messagesTableView.rowHeight = UITableView.automaticDimension
    }
}

extension MyPreViewController {
    func setAGChatView() {
        aGPartyTitle.text = "mockDate"
        aGChatBody.text = viewModel.groupChatRoom.recentMessage
        RequestImage.downloadImage(from: URL(string: viewModel.groupChatRoom.chatRoomImageUrl)!, imageView: aGChatImageView)
    }
    
    func setApplicantsView() {
        var tmp: NSLayoutXAxisAnchor
        tmp = applcantsView.leadingAnchor
        
        //print("party Id ", String(viewModel.))
        print("applications count", String(viewModel.myPartyApplicants.count))
        
        for i in 0..<viewModel.myPartyApplicants.count  {
            let imageView = UIImageView()
            applcantsView.addSubview(imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
            imageView.topAnchor.constraint(equalTo: applcantsView.topAnchor).isActive = true
            imageView.bottomAnchor.constraint(equalTo: applcantsView.bottomAnchor).isActive = true
            imageView.leadingAnchor.constraint(equalTo: tmp, constant: 10).isActive = true
            imageView.layer.cornerRadius = 15
            
            imageView.image = UIImage(systemName: "xmark")
            RequestImage.downloadImage(from: URL(string: viewModel.myPartyApplicants[i].partyProfileImageUrl)!, imageView: imageView)
            tmp = imageView.trailingAnchor
        }
        applcantsView.trailingAnchor.constraint(equalTo: tmp).isActive = true
    }
}

extension MyPreViewController:UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.otoChatRooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: ChatRoomCell
        cell = tableView.dequeueReusableCell(withIdentifier: "chatRoomCell", for: indexPath) as! ChatRoomCell
        
        let chatRoom: ChatRoom = viewModel.otoChatRooms[indexPath.row]
        cell.configure(chatRoom: chatRoom, tableView: messagesTableView, indexPath: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let _: UITableViewCell = tableView.cellForRow(at: indexPath) {
            self.performSegue(withIdentifier: "GoChatRoom", sender: indexPath.row)
            // cell.selectionStyle = .none
        }
    }
}

extension MyPreViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let chatViewController: ChatViewController =
            segue.destination as? ChatViewController else {
            return
        }
        chatViewController.chatRoomId = viewModel.otoChatRooms[sender as! Int].chatRoomId
    }
}

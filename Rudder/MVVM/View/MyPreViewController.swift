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
    
    @IBOutlet weak var applcantsView: UIView!
    @IBOutlet weak var messagesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        viewModel.receivedChatFlag.bind{ [weak self] _ in
            guard let self = self else {return}
            DispatchQueue.main.async { self.setAGChatView() }
        }
    }
}

extension MyPreViewController {
    func setAGChatView() {
        print("hit here haloha ")
        print(viewModel.groupChatRoom.recentMessage)
        aGPartyTitle.text = "mockDate"
        aGChatBody.text = viewModel.groupChatRoom.recentMessage
    }
    
    func setApplicantsView() {
        
        var tmp: NSLayoutXAxisAnchor
        tmp = applcantsView.leadingAnchor
        
        for i in 0..<viewModel.myPartyApplicants.count  {
            let imageView = UIImageView()
            applcantsView.addSubview(imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
            imageView.topAnchor.constraint(equalTo: applcantsView.topAnchor).isActive = true
            imageView.bottomAnchor.constraint(equalTo: applcantsView.bottomAnchor).isActive = true
            imageView.leadingAnchor.constraint(equalTo: tmp).isActive = true
            
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
}

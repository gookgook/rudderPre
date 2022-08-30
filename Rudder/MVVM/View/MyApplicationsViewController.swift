//
//  MyApplicationsViewController.swift
//  Rudder
//
//  Created by 박민호 on 2022/08/22.
//

import UIKit

class MyApplicationsViewController: UIViewController {
    
    let viewModel = MyApplicationsViewModel()
    
    @IBOutlet weak var acceptedTableView: UITableView!
    @IBOutlet weak var appliedTableView: UITableView!
    
    @IBOutlet weak var acceptedTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var appliedTableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var groupOrOTO: Int = 0 // perform segue할 때 이거 group인지 OTO인지 구분하기 위한 꼼수 (1 - group, 2 - OTO )

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        setUpBinding()
        setBarStyle()
        viewModel.requestApprovedParties()
        viewModel.requestAppliedPre()
    }
}

extension MyApplicationsViewController {
    func setUpBinding() {
        viewModel.getApprovedPreFlag.bind{[weak self] status in
            guard status != -1 else { print("something wrong"); return}
            guard let self = self else {return}
            
            print("admiandsifn adm " + String(self.viewModel.approvedParties.count))
            DispatchQueue.main.async {
                self.acceptedTableView.reloadSections(IndexSet(0...0), with: UITableView.RowAnimation.automatic)
                self.acceptedTableView.layoutSubviews()
                self.acceptedTableViewHeight.constant = self.acceptedTableView.contentSize.height
            }
            self.setGroupChatBinding()
        }
        viewModel.getAppliedPreFlag.bind{[weak self] status in
            guard status != -1 else { print("something wrong"); return}
            guard let self = self else {return}
            self.viewModel.requestOTOChatRoom()
        }
        viewModel.getOTOChatRoomFlag.bind{[weak self] status in
            guard status != -1 else { print("something wrong"); return}
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.appliedTableView.reloadSections(IndexSet(0...0), with: UITableView.RowAnimation.automatic)
                self.appliedTableViewHeight.constant = self.appliedTableView.contentSize.height
            }
            self.setOTOChatBinding()
        }
        viewModel.isLoadingFlag.bind{ [weak self] status in
            guard let self = self else {return}
            DispatchQueue.main.async {
                if status {
                    self.spinner.startAnimating()
                    self.view.isUserInteractionEnabled = false
                }
                else {
                    self.spinner.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                }
            }
        }
    }
}

extension MyApplicationsViewController {
    func setGroupChatBinding() {
        for i in 0..<viewModel.groupChatRooms.count {
            viewModel.receivedGroupChatFlag[i].bind{ [weak self] _ in
                guard let self = self else {return}
                let indexPath = IndexPath(row: i, section: 0)
                self.acceptedTableView.reloadRows(at: [indexPath], with: .none)
            }
        }
    }
    func setOTOChatBinding() {
        
        print("otoChatRoom Count ", String(viewModel.otoChatRooms.count))
        
        for i in 0..<viewModel.otoChatRooms.count {
            viewModel.receivedOTOChatFlag[i].bind{ [weak self] _ in
                guard let self = self else {return}
                let indexPath = IndexPath(row: i, section: 0)
                self.appliedTableView.reloadRows(at: [indexPath], with: .none)
               
            }
        }
    }
}

extension MyApplicationsViewController {
    func setUpTableView(){
        let agCellNib: UINib = UINib.init(nibName: "AGChatRoomCell", bundle: nil)
        //let pendingCellNib: UINib = UINib.init(nibName: "pendingCell", bundle: nil)
        self.acceptedTableView.register(agCellNib, forCellReuseIdentifier: "aGChatRoomCell")
        //self.acceptedTableView.register(pendingCellNib, forCellReuseIdentifier: "pendingCell")
        self.acceptedTableView.estimatedRowHeight = 100
        self.acceptedTableView.rowHeight = UITableView.automaticDimension
        
        let pendingAppCellNib: UINib = UINib.init(nibName: "PendingAppCell", bundle: nil)
        let chatRoomCellNib: UINib = UINib.init(nibName: "ChatRoomCell", bundle: nil)
        self.appliedTableView.register(pendingAppCellNib, forCellReuseIdentifier: "pendingAppCell")
        self.appliedTableView.register(chatRoomCellNib, forCellReuseIdentifier: "chatRoomCell")
        self.appliedTableView.estimatedRowHeight = 100
        self.appliedTableView.rowHeight = UITableView.automaticDimension
    }
}

extension MyApplicationsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == acceptedTableView {
            
            if viewModel.approvedParties.count == 0 {return 1}
            return viewModel.approvedParties.count
        } else {
            if viewModel.appliedParties.count == 0 {return 1}
            return viewModel.appliedParties.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == acceptedTableView {
            
            let cell: AGChatRoomCell
            cell = acceptedTableView.dequeueReusableCell(withIdentifier: "aGChatRoomCell", for: indexPath) as! AGChatRoomCell
            if viewModel.approvedParties.count == 0 {
                cell.configure(isEmptyCell: true, partyTime: nil, chatRoom: nil, tableView: tableView, indexPath: indexPath)
                return cell
            }
            
      
            cell.configure(isEmptyCell: false, partyTime: viewModel.approvedParties[indexPath.row].partyTime, chatRoom: viewModel.groupChatRooms[indexPath.row]!, tableView: tableView, indexPath: indexPath)
            cell.tag = 1 //chat room exist
            return cell
        } else {
            if viewModel.appliedParties.count != 0 && viewModel.appliedParties[indexPath.row] == nil{
                let cell: ChatRoomCell
                cell = appliedTableView.dequeueReusableCell(withIdentifier: "chatRoomCell", for: indexPath) as! ChatRoomCell
                cell.configure(chatRoom: viewModel.otoChatRooms[indexPath.row]!, tableView: tableView, indexPath: indexPath)
                cell.tag = 1
                return cell
            } else {
                let cell: PendingAppCell
                cell = appliedTableView.dequeueReusableCell(withIdentifier: "pendingAppCell", for: indexPath) as! PendingAppCell
                
                if viewModel.appliedParties.count == 0 {
                    cell.configure(isEmptyCell: true, party: nil, tableView: tableView, indexPath: indexPath)
                    return cell
                }
                
                cell.configure(isEmptyCell: false,party: viewModel.appliedParties[indexPath.row]!, tableView: tableView, indexPath: indexPath)
                cell.tag = 0
                return cell
            }
        }
    }
}

extension MyApplicationsViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == acceptedTableView {
            if let _: UITableViewCell = tableView.cellForRow(at: indexPath) {
                groupOrOTO = 1
                self.performSegue(withIdentifier: "GoChatRoom", sender: indexPath.row)
            }
        } else {
            if let cell: UITableViewCell = tableView.cellForRow(at: indexPath) {
                groupOrOTO = 2
                if cell.tag == 1 { self.performSegue(withIdentifier: "GoChatRoom", sender: indexPath.row) }
                else { self.performSegue(withIdentifier: "GoPartyDetail", sender: indexPath.row) }
            }
            
        }
    }
}

extension MyApplicationsViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoChatRoom" {
            guard let chatViewController: ChatViewController =
                segue.destination as? ChatViewController else {
                return
            }
            if groupOrOTO == 1 { chatViewController.chatRoomId = viewModel.groupChatRooms[sender as! Int]?.chatRoomId }
            else if groupOrOTO == 2 {chatViewController.chatRoomId = viewModel.otoChatRooms[sender as! Int]?.chatRoomId }
        } else {
            guard let partyDetailViewController: PartyDetailViewController =
                segue.destination as? PartyDetailViewController else {
                return
            }
            partyDetailViewController.partyId = viewModel.appliedParties[sender as! Int]!.partyId
        }
    }
}

extension MyApplicationsViewController {
    func setBarStyle(){
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "SF Pro Text Bold", size: 20)!]
    }
}

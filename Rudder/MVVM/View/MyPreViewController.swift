//
//  MyPreViewController.swift
//  Rudder
//
//  Created by 박민호 on 2022/07/05.
//

import UIKit
import GameKit

class MyPreViewController: UIViewController {
    
    let viewModel = MyPreViewModel()
    
    var currentPartyNo: Int = 0
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!

    //@IBOutlet weak var aGChatView: UIView!
    @IBOutlet weak var aGPartyTitle: UILabel! //accepted group chat view
    @IBOutlet weak var aGChatBody: UILabel!
    @IBOutlet weak var aGChatImageView: UIImageView!
    
    @IBOutlet weak var applicantLabel: UILabel!
    @IBOutlet weak var MessagesLabel: UILabel!
    
    @IBOutlet weak var applicantsView: UIView!
    @IBOutlet weak var messagesTableView: UITableView!
    
    @IBOutlet weak var messageTableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var partyDatePicker: UITextField!
    let pickerView = UIPickerView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        setUpBinding()
        viewModel.requestPartyDates()
        
        let k_doLogout = Notification.Name("doLogout") //이거이름재설정 필요
        NotificationCenter.default.addObserver(self, selector: #selector(self.doLogout), name: k_doLogout, object: nil)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        setUIs()
    }
    
    @objc func doLogout(){
        UserDefaults.standard.removeObject(forKey: "token")
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}

extension MyPreViewController {
    func setUpBinding(){
        viewModel.getPartyDatesFlag.bind{ [weak self] status in
            guard let self = self else {return}
            
            if status == 1 {
                
                guard self.viewModel.myPartyDates.count > 0 else {
                    DispatchQueue.main.async {
                        Alert.showAlert(title: "You didn't host any party", message: nil, viewController: self)
                        self.aGChatBody.text = " "
                        self.MessagesLabel.text = " "
                        self.applicantLabel.text = " "
                    }
                    return
                }
                
                self.viewModel.requestGroupChatroom(partyId: self.viewModel.myPartyDates[self.currentPartyNo].partyId)
                DispatchQueue.main.async {
                    self.setPartyDatePicker()
                }
            }
            else { print("party date wrong") }
        }
        
        viewModel.getGroupChatRoomFlag.bind{ [weak self] status in
            guard let self = self else {return}
            switch status {
            case 1:
                self.viewModel.requestPartyApplicants(partyId: self.viewModel.myPartyDates[self.currentPartyNo].partyId)
                DispatchQueue.main.async{self.setAGChatView()}
            default : print("something wrong")
            }
        }
        
        viewModel.getPartyApplicantsFlag.bind{ [weak self] status in
            guard let self = self else {return}
            switch status {
            case 1:
                print("hit setAPpl")
                self.viewModel.requestOTOChatRoom(partyId:  self.viewModel.myPartyDates[self.currentPartyNo].partyId)
                DispatchQueue.main.async{self.setApplicantsView()}
            default : print("something wrong")
            }
        }
        
        viewModel.getOTOChatRoomFlag.bind{ [weak self] status in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.messagesTableView.reloadSections(IndexSet(0...0), with: UITableView.RowAnimation.automatic)
                self.messageTableViewHeight.constant = self.messagesTableView.contentSize.height
                self.setOTOChatBinding()
            }
        }
        
        viewModel.receivedGroupChatFlag.bind{ [weak self] _ in
            guard let self = self else {return}
            DispatchQueue.main.async { self.setAGChatView() }
        }
        
        viewModel.refreshFlag.bind{ [weak self] _ in
            guard let self = self else {return}
            self.viewModel.requestPartyDates()
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
        self.messagesTableView.estimatedRowHeight = 100 //autolatyout 잘 작동하게 대략적인 높이?
        self.messagesTableView.rowHeight = UITableView.automaticDimension
    }
}

extension MyPreViewController: UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    func setPartyDatePicker() {
        partyDatePicker.text = Utils.stringDate(date: viewModel.myPartyDates[0].partyDate) + " ▼"
        
        pickerView.delegate = self
        partyDatePicker.inputView = pickerView
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let tmpBarButton = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(self.done))
        tmpBarButton.tintColor = MyColor.rudderPurple
        let button = tmpBarButton
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        partyDatePicker.inputAccessoryView = toolBar
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        viewModel.myPartyDates.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Utils.stringDate(date: viewModel.myPartyDates[row].partyDate)
    }
   
    
    @objc func done(){
        partyDatePicker.text = Utils.stringDate(date: viewModel.myPartyDates[pickerView.selectedRow(inComponent: 0)].partyDate) + " ▼"
        self.currentPartyNo = pickerView.selectedRow(inComponent: 0)
        
        
        for view in self.applicantsView.subviews {
            view.removeFromSuperview()
        }
        
        
        self.viewModel.requestGroupChatroom(partyId: self.viewModel.myPartyDates[self.currentPartyNo].partyId)
        partyDatePicker.endEditing(true)
    }
    
}

extension MyPreViewController {
    func setAGChatView() {
        aGPartyTitle.text = viewModel.groupChatRoom.chatRoomTitle
        aGChatBody.text = viewModel.groupChatRoom.recentMessage
        RequestImage.downloadImage(from: URL(string: viewModel.groupChatRoom.chatRoomImageUrl)!, imageView: aGChatImageView)
        aGChatImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(touchAGChatRoom(_:))))
        aGChatImageView.isUserInteractionEnabled = true
    }
    
    @objc func touchAGChatRoom(_ sender: Any?){
        self.performSegue(withIdentifier: "GoGroupChatRoom", sender: nil)
    }
    
    func setApplicantsView() {
        var tmp: NSLayoutXAxisAnchor
        tmp = applicantsView.leadingAnchor
        
        //print("party Id ", String(viewModel.))
        print("applications count", String(viewModel.myPartyApplicants.count))
        
        if viewModel.myPartyApplicants.count == 0 {
            let imageView = UIImageView()
            applicantsView.addSubview(imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.widthAnchor.constraint(equalToConstant: 110).isActive = true
            imageView.topAnchor.constraint(equalTo: applicantsView.topAnchor).isActive = true
            imageView.bottomAnchor.constraint(equalTo: applicantsView.bottomAnchor).isActive = true
            imageView.leadingAnchor.constraint(equalTo: tmp, constant: 10).isActive = true
            imageView.layer.cornerRadius = 15
            imageView.clipsToBounds = true
            imageView.isUserInteractionEnabled = false
            
            RequestImage.downloadImage(from: URL(string: "https://d17a6yjghl1rix.cloudfront.net/team_apply_mock.png")!, imageView: imageView)
        }
        
        for i in 0..<viewModel.myPartyApplicants.count   {
            let imageView = UIImageView()
            applicantsView.addSubview(imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.widthAnchor.constraint(equalToConstant: 110).isActive = true
            imageView.topAnchor.constraint(equalTo: applicantsView.topAnchor).isActive = true
            imageView.bottomAnchor.constraint(equalTo: applicantsView.bottomAnchor).isActive = true
            imageView.leadingAnchor.constraint(equalTo: tmp, constant: 10).isActive = true
            imageView.layer.cornerRadius = 15
            imageView.clipsToBounds = true
            imageView.tag = i
            
            imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(touchApplicant(_:))))
            imageView.isUserInteractionEnabled = true
            
            RequestImage.downloadImage(from: URL(string: viewModel.myPartyApplicants[i].partyProfileImageUrl)!, imageView: imageView)
            
            let nicknameLabel = UILabel()
            nicknameLabel.translatesAutoresizingMaskIntoConstraints = false
            applicantsView.addSubview(nicknameLabel)
            nicknameLabel.text = viewModel.myPartyApplicants[i].userNickname
            nicknameLabel.textColor = UIColor.white
            nicknameLabel.font = UIFont(name: "SF Pro Text", size: 13)
            nicknameLabel.layer.zPosition = 1
            nicknameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
            nicknameLabel.widthAnchor.constraint(equalToConstant: 56).isActive = true
            nicknameLabel.leadingAnchor.constraint(equalTo: tmp, constant: 20).isActive = true
            nicknameLabel.bottomAnchor.constraint(equalTo: applicantsView.bottomAnchor, constant: -5).isActive = true
            
            let numberLabel = UILabel()
            numberLabel.translatesAutoresizingMaskIntoConstraints = false
            applicantsView.addSubview(numberLabel)
            numberLabel.text = "+"+String(viewModel.myPartyApplicants[i].numberApplicants)
            numberLabel.textColor = UIColor.white
            numberLabel.font = UIFont(name: "SF Pro Text", size: 11)
            numberLabel.layer.zPosition = 1
            numberLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
            numberLabel.leadingAnchor.constraint(equalTo: nicknameLabel.trailingAnchor, constant: 4).isActive = true
            numberLabel.bottomAnchor.constraint(equalTo: applicantsView.bottomAnchor, constant: -5).isActive = true
            numberLabel.widthAnchor.constraint(equalToConstant: 30).isActive = true
            numberLabel.backgroundColor = MyColor.opaGray
            numberLabel.layer.cornerRadius = 5
            numberLabel.layer.borderWidth = 0.1
            numberLabel.textAlignment = .center
            
            
            
            tmp = imageView.trailingAnchor
        }
        applicantsView.trailingAnchor.constraint(equalTo: tmp, constant: 10).isActive = true
    }
    @objc func touchApplicant(_ sender: UITapGestureRecognizer) {
        print("touch sodfju asdf")
        if let imageView = sender.view as? UIImageView{
            self.performSegue(withIdentifier: "GoProfile", sender: imageView.tag)
        }
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
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero //이 3줄은 seperator 줄을 가로로 full 하기 위함
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let _: UITableViewCell = tableView.cellForRow(at: indexPath) {
            self.performSegue(withIdentifier: "GoChatRoom", sender: indexPath.row)
            // cell.selectionStyle = .none
        }
    }
}

extension MyPreViewController: DoGoChatRoomDelegate {
    
    func doGoChatRoomDelegate(chatRoomId: Int) {
        self.viewModel.requestOTOChatRoom(partyId:  self.viewModel.myPartyDates[self.currentPartyNo].partyId)
        self.performSegue(withIdentifier: "GoChatRoomDirect", sender: chatRoomId) //profile에서 새로 만들어져서
        
    }
}

extension MyPreViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoChatRoom" {
            guard let chatViewController: ChatViewController =
                segue.destination as? ChatViewController else {
                return
            }
            chatViewController.chatRoomId = viewModel.otoChatRooms[sender as! Int].chatRoomId
        }else if segue.identifier == "GoGroupChatRoom"{
            guard let chatViewController: ChatViewController =
                segue.destination as? ChatViewController else {
                return
            }
            chatViewController.chatRoomId = viewModel.groupChatRoom.chatRoomId
        
        }else if segue.identifier == "GoChatRoomDirect" {
            guard let chatViewController: ChatViewController =
                segue.destination as? ChatViewController else {
                return
            }
            chatViewController.chatRoomId = sender as? Int
            
        }else if segue.identifier == "GoPreSetting" {
            guard let preSettingViewController: PreSettingViewController =
                segue.destination as? PreSettingViewController else {
                return
            }
            preSettingViewController.partyThumbnailImageURL = viewModel.groupChatRoom.chatRoomImageUrl
            preSettingViewController.partyId = viewModel.myPartyDates[currentPartyNo].partyId
            
        }else{
            guard let profileViewController: ProfileViewController = segue.destination as? ProfileViewController else {
                return
            }
            profileViewController.applicant = viewModel.myPartyApplicants[(sender as? Int)!]
            profileViewController.partyId = viewModel.myPartyDates[currentPartyNo].partyId
            profileViewController.delegate = self
            
        }
    }
}


extension MyPreViewController {
    @IBAction func touchUpSetting(_ sender: UIBarButtonItem){
        guard viewModel.groupChatRoom != nil else {
            Alert.showAlert(title: "You didn't host any party", message: nil, viewController: self)
            return
        }
        self.performSegue(withIdentifier: "GoPreSetting", sender: nil)
    
    }
}


extension MyPreViewController {
    func setUIs(){
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "SF Pro Text Bold", size: 20)!]
        self.tabBarController?.tabBar.isHidden = false
    }
}

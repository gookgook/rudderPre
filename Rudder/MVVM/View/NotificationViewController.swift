//
//  NotificationViewController.swift
//  Rudder
//
//  Created by 박민호 on 2022/08/12.
//

import UIKit

final class NotificationViewController: UIViewController {
    
    let viewModel = NotificationViewModel()
    
    @IBOutlet weak var notificationTableView: UITableView!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        setUpBinding()
        setBarStyle()
        viewModel.requestNotifications(endNotificationId: -1)
    }
}

extension NotificationViewController {
    func setUpBinding(){
        viewModel.getNotificationFlag.bind{ [weak self] status in
            guard let self = self else {return}
            if status == 1 {
                //self.nowPaging = false
                guard !self.viewModel.notifications.isEmpty else {
                    DispatchQueue.main.async { Alert.showAlert(title: "No more notifications", message: nil, viewController: self) }
                    return
                }
                //self.endNotificationId = self.viewModel.parties[self.viewModel.parties.count - 1].partyId
                DispatchQueue.main.async {
                   // print(self.viewModel.parties.count)
                    self.notificationTableView.reloadSections(IndexSet(0...0), with: UITableView.RowAnimation.automatic)
                }
            }
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
        viewModel.tabBarDestinationFlag.bind{[weak self] destination in
            guard let self = self else {return}
            self.tabBarController?.selectedIndex = destination!
            self.navigationController?.popViewController(animated: false)
        }
    }
}


extension NotificationViewController {
    func setUpTableView() {
        let cellNib: UINib = UINib.init(nibName: "NotificationCell", bundle: nil)
        
        self.notificationTableView.register(cellNib, forCellReuseIdentifier: "notificationCell")
        
        let refreshControl: UIRefreshControl = UIRefreshControl()
        //refreshControl.addTarget(self, action: #selector(self.viewModel.reloadPosts), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = MyColor.rudderPurple
        
        //self.partyTableView.refreshControl = refreshControl
        self.notificationTableView.estimatedRowHeight = 200 //autolatyout 잘 작동하게 대략적인 높이?
        self.notificationTableView.rowHeight = UITableView.automaticDimension
    }
}

extension NotificationViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NotificationCell
        cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell", for: indexPath) as! NotificationCell
        
        let notification: UserNotification = viewModel.notifications[indexPath.row]
        cell.configure(notification: notification, tableView: notificationTableView, indexPath: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let _: UITableViewCell = tableView.cellForRow(at: indexPath) {
            viewModel.touchUpNotifications(index: indexPath.row)
        }
    }
}

extension NotificationViewController {
    func setBarStyle(){
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "SF Pro Text Bold", size: 20)!]
    }
}

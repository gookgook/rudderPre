//
//  PartyMainViewController.swift
//  Rudder
//
//  Created by 박민호 on 2022/07/08.
//

import UIKit

class PartyMainViewController: UIViewController {
    
    let viewModel = PartyMainViewModel()
    
    @IBOutlet weak var partyTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBinding()
        setUpTableView()
        viewModel.requestPartyDates(endPartyId: -1)
    }
}

extension PartyMainViewController {
    func setUpBinding() {
        viewModel.getPartiesFlag.bind{ [weak self] status in
            guard let self = self else {return}
            if status == 1 {
                DispatchQueue.main.async {
                    print(self.viewModel.parties.count)
                    self.partyTableView.reloadSections(IndexSet(0...0), with: UITableView.RowAnimation.automatic)
                }
               
            }
        }
    }
}

extension PartyMainViewController {
    func setUpTableView() {
        let cellNib: UINib = UINib.init(nibName: "PartyCell", bundle: nil)
        
        self.partyTableView.register(cellNib, forCellReuseIdentifier: "partyCell")
        
        let refreshControl: UIRefreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.viewModel.reloadPosts),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = MyColor.rudderPurple
        
        self.partyTableView.refreshControl = refreshControl
        self.partyTableView.estimatedRowHeight = 200 //autolatyout 잘 작동하게 대략적인 높이?
        self.partyTableView.rowHeight = UITableView.automaticDimension
    }
}

extension PartyMainViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.parties.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PartyCell
        cell = tableView.dequeueReusableCell(withIdentifier: "partyCell", for: indexPath) as! PartyCell
        
        let party: Party = viewModel.parties[indexPath.row]
        cell.configure(party: party, tableView: partyTableView, indexPath: indexPath)
        
        return cell
    }
}

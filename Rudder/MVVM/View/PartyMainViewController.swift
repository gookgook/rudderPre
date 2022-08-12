//
//  PartyMainViewController.swift
//  Rudder
//
//  Created by 박민호 on 2022/07/08.
//

import UIKit

class PartyMainViewController: UIViewController {
    
    let viewModel = PartyMainViewModel()
    
    var nowPaging: Bool = false
    var endPartyId: Int = -1
    
    @IBOutlet weak var partyTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBinding()
        setUpTableView()
        viewModel.requestPartyDates(endPartyId: endPartyId)
        self.navigationItem.hidesBackButton = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setBarStyle()
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
}
extension PartyMainViewController: DoRefreshPartyDelegate{
    func doRefreshParty() {
        self.viewModel.reloadPosts()
    }
    
    @IBAction func touchUpMyProfile(_ sender: UIBarButtonItem){
        self.performSegue(withIdentifier: "GoMyProfile", sender: nil)
    }
    
    @IBAction func touchUpNotification(_ sender: UIBarButtonItem){
        self.performSegue(withIdentifier: "GoNotification", sender: nil)
    }
}

extension PartyMainViewController {
    func setUpBinding() {
        viewModel.getPartiesFlag.bind{ [weak self] status in
            guard let self = self else {return}
            if status == 1 {
                self.nowPaging = false
                guard !self.viewModel.parties.isEmpty else {
                    DispatchQueue.main.async { Alert.showAlert(title: "No more parties", message: nil, viewController: self) }
                    return
                }
                self.endPartyId = self.viewModel.parties[self.viewModel.parties.count - 1].partyId
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let _: UITableViewCell = tableView.cellForRow(at: indexPath) {
            
            self.performSegue(withIdentifier: "GoPartyDetail", sender: indexPath.row)
            // cell.selectionStyle = .none
        }
    }
}

extension PartyMainViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoPartyDetail" {
            guard let partyDetailViewController: PartyDetailViewController =
                segue.destination as? PartyDetailViewController else {
                return
            }
            partyDetailViewController.partyId = viewModel.parties[sender as! Int].partyId
        } else {
            guard let makePreViewController: MakePreViewController =
                segue.destination as? MakePreViewController else {
                return
            }
            makePreViewController.delegate = self
        }
    }
}

extension PartyMainViewController {
    func setBarStyle(){
        self.navigationController?.navigationItem.hidesBackButton = true
        
        let logoContainer = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 19))

         let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 19))
         imageView.contentMode = .scaleAspectFit
         let image = UIImage(named: "NewLogo")
         imageView.image = image
         logoContainer.addSubview(imageView)
        self.navigationItem.titleView = logoContainer
        
        self.tabBarController?.tabBar.isTranslucent = false
        self.tabBarController?.tabBar.isHidden = false
        self.tabBarController?.tabBar.backgroundColor = UIColor.white
    }
}

extension PartyMainViewController{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.contentOffset.y >= 0 else { return }
        if !nowPaging {
            nowPaging = true
            //spinner.startAnimating()
            viewModel.requestPartyDates(endPartyId: endPartyId)
        }
   }
}

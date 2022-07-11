//
//  MainViewController.swift
//  Rudder
//
//  Created by 박민호 on 2022/06/08.
//

import UIKit

/*class MainViewController: UIViewController {

    let viewModel = MainViewModel()
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var postTableView: UITableView!
    @IBOutlet weak var categoryScrollView: UIScrollView!
    
    private var currentButton: UIButton!
    
    private var lastButtonAnchor: NSLayoutXAxisAnchor!
    private var infiniteScrollNow: Bool = false
    private var banInfinite: Bool = false
}

extension MainViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBinding()
        viewModel.requestCategory()
    }
}

extension MainViewController {
    func setUpBinding() {
        viewModel.isLoading.bind { [weak self] status in
            guard let self = self else  { return }
            if status { DispatchQueue.main.async { self.spinner.startAnimating() } }
            else { DispatchQueue.main.async { self.spinner.stopAnimating() }}
        }
        viewModel.posts.bind { [weak self] _ in
            guard let self = self else { return }
            DispatchQueue.main.async { self.postTableView.reloadSections(IndexSet(0...0), with: UITableView.RowAnimation.automatic) }
            self.infiniteScrollNow = false
        }
        viewModel.categories.bind { [weak self] _ in
            guard let self = self else { return }
            DispatchQueue.main.async { self.makeCategoryButton() }
        }
    }
}

extension MainViewController {
    @objc func pressed(_ sender: UIButton) {
        banInfinite = false
        print("pressed "+String(sender.tag)+" current"+String(currentButton.tag))
        currentButton.setTitleColor(.systemGray, for: .normal)
        sender.setTitleColor(.black, for: .normal)
        viewModel.currentCategoryId = sender.tag
        viewModel.endPostId = -1
        viewModel.requestPosts(infiniteScrollNow: infiniteScrollNow)
        currentButton = sender
    }
}

extension MainViewController {
    func makeCategoryButton(){
        for v in categoryScrollView.subviews{
            v.removeFromSuperview()
        }
        let AllCategory = Category(categoryId: -1, categoryName: "All", isSelected: true, isMember: "f",  categoryType: "common", categoryAbbreviation: "All")
        viewModel.categories.value.insert(AllCategory, at: 0)
        var tmp: NSLayoutXAxisAnchor = categoryScrollView.leftAnchor
        for i in 0...viewModel.categories.value.count - 1 {
            let button = UIButton()
            button.setTitleColor(.systemGray, for: .normal)
            button.titleLabel!.font = UIFont(name: "SF Pro Text Bold", size: 18)
            
            categoryScrollView.addSubview(button)
            button.centerYAnchor.constraint(equalTo: categoryScrollView.centerYAnchor, constant: 0).isActive = true
            button.translatesAutoresizingMaskIntoConstraints = false
            button.leftAnchor.constraint(equalTo: tmp, constant: 20).isActive = true
    
            
            button.setTitle(viewModel.categories.value[i].categoryAbbreviation, for: .normal)
            button.tag = viewModel.categories.value[i].categoryId
            button.addTarget(self, action: #selector(pressed(_ :)), for: .touchUpInside)
            
            if i == 0 {
                button.setTitleColor(.black, for: .normal)
                currentButton = button
            }
            
            tmp = button.rightAnchor
            lastButtonAnchor = button.rightAnchor
        }
        DispatchQueue.main.async {
            self.categoryScrollView.rightAnchor.constraint(equalTo: self.lastButtonAnchor, constant: 50).isActive = true
        }
    }
}

extension MainViewController {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TmpViewController.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: CommunityBoardCell
        cell = tableView.dequeueReusableCell(withIdentifier: "communityBoardCell",
                                             for: indexPath) as! CommunityBoardCell
        // cell.delegate = self
        
        guard indexPath.row < viewModel.posts.value.count else {
            return cell
        }
        
        let post: Post = viewModel.posts.value[indexPath.row]
        
        viewModel.endPostId = post.postId
        
        
        //cell.moreMenuButton.addTarget(self, action: #selector(touchUpMoreMenuButton(_ :)), for: .touchUpInside)
        cell.moreMenuButton.tag = indexPath.row
        
        cell.likeButton.addTarget(self, action: #selector(touchUpLikeButton(_ :)), for: .touchUpInside)
        cell.likeButton.tag = indexPath.row
        cell.configure(post: post, tableView: tableView, indexPath: indexPath)
        cell.tag  = post.postId
        
        let url = URL(string: post.userProfileImageUrl)!
        
        let cacheKey: String = url.absoluteString
        if let cachedImage = ImageCache.imageCache.object(forKey: cacheKey as NSString) {
            DispatchQueue.main.async {  cell.characterView.image = cachedImage }
            return cell
        }
        
        RequestImageData.getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async{
                let image = UIImage(data: data)
                guard image != nil else {return }
                ImageCache.imageCache.setObject(image!, forKey: cacheKey as NSString)
                cell.characterView.image = image
            }
        }
        return cell
    }
}


extension MainViewController {
    @objc func touchUpLikeButton(_ sender: UIButton) {
        print("like button pressed "+String(sender.tag))
        guard let token: String = UserDefaults.standard.string(forKey: "token"),
              token.isEmpty == false else {
            print("no token")
            return
        }
        if viewModel.posts.value[sender.tag].isLiked == true {
            viewModel.posts.value[sender.tag].isLiked = false
            sender.setImage(UIImage(named: "like"), for: .normal)
            /*let cell = self.postTableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! CommunityBoardCell
            // for .highlighted 에 blur 한거 필요
            cell.likeCountLabel.text = String(Int(cell.likeCountLabel.text!)! - 1)
            TmpViewController.posts[sender.tag].likeCount -= 1*/
            viewModel.requestAddLike(cell: cell,cellTag:sender.tag)
    
        }else{
            viewModel.posts.value[sender.tag].isLiked = true
            sender.setImage(UIImage(named: "like_purple"), for: .normal)
            /*let cell = self.postTableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! CommunityBoardCell
            // for .highlighted 에 blur 한거 필요
            
            cell.likeCountLabel.text = String(Int(cell.likeCountLabel.text!)! + 1)
            viewModel.posts.value[sender.tag].likeCount += 1*/
            //안해도 어차피 reload??
            viewModel.requestAddLike(cell: cell, cellTag:sender.tag )
            
        }
    }
}

extension MainViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.size.height + 30 && infiniteScrollNow == false && banInfinite == false{
            
            print("infinite scroll")
            infiniteScrollNow = true
            //requestPosts(endPostId: endPostId)
            
            
        }
    }
    
    func setBar(){
        self.navigationItem.hidesBackButton = true
        let label = UILabel()
        label.text = " Community"
        label.textAlignment = .left
        label.font = UIFont(name: "SF Pro Text Bold", size: 20)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: label)
    }
    
    func setBarStyle(){
        self.tabBarController?.tabBar.isTranslucent = false
        self.tabBarController?.tabBar.isHidden = false
        self.tabBarController?.tabBar.backgroundColor = UIColor.white
        
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.barTintColor = .white
       // self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
    }
    
}
*/
//isRefreshing 을 넣자


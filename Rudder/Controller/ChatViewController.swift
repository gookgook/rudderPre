//
//  ChatViewController.swift
//  Rudder
//
//  Created by 박민호 on 2022/06/20.
//

import UIKit
import SwiftStomp
import SquareInAppPaymentsSDK
import CoreLocation

class ChatViewController: UIViewController, OrderViewControllerDelegate, UIViewControllerTransitioningDelegate, SQIPCardEntryViewControllerDelegate, PKPaymentAuthorizationViewControllerDelegate {
    
    var userInfoId: Int! //채팅 구별 위해
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        print("finished")
    }
    
    func cardEntryViewController(_ cardEntryViewController: SQIPCardEntryViewController, didObtain cardDetails: SQIPCardDetails, completionHandler: @escaping (Error?) -> Void) {
        print("Payment token (nonce) generated by In-App Payments SDK: \(cardDetails.nonce)")
                
    }
    
    
    func cardEntryViewController(_ cardEntryViewController: SQIPCardEntryViewController, didCompleteWith status: SQIPCardEntryCompletionStatus) {
        print("Payment token (nonce) generated by In-App Payments SDK")
    }
    
    func didRequestPayWithApplyPay() {
        dismiss(animated: true) {
            self.requestApplePayAuthorization()
        }
    }
    
    func didRequestPayWithCard() {
        dismiss(animated: true) {
            
                    let vc = self.makeCardEntryViewController()
                    vc.delegate = self

                    let nc = UINavigationController(rootViewController: vc)
                    self.present(nc, animated: true, completion: nil)
                }
    }
    
    func makeCardEntryViewController() -> SQIPCardEntryViewController {
            // Customize the card payment form
            let theme = SQIPTheme()
            theme.errorColor = .red
            theme.tintColor = Color.primaryAction
            theme.keyboardAppearance = .light
            theme.messageColor = Color.descriptionFont
            theme.saveButtonTitle = "Pay"

            return SQIPCardEntryViewController(theme: theme)
        }
 
    func requestApplePayAuthorization() {
            guard SQIPInAppPaymentsSDK.canUseApplePay else {
                return
            }

           /* guard appleMerchanIdSet else {
                showMerchantIdNotSet()
                return
            }*/

            let paymentRequest = PKPaymentRequest.squarePaymentRequest(
                merchantIdentifier: Constants.ApplePay.MERCHANT_IDENTIFIER,
                countryCode: Constants.ApplePay.COUNTRY_CODE,
                currencyCode: Constants.ApplePay.CURRENCY_CODE
            )

            paymentRequest.paymentSummaryItems = [
                PKPaymentSummaryItem(label: "Super Cookie", amount: 1.00)
            ]

            let paymentAuthorizationViewController = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)

            paymentAuthorizationViewController!.delegate = self

            present(paymentAuthorizationViewController!, animated: true, completion: nil)
        }

    
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var chatTableView: UITableView!
    
    private var chats: [Chat] = [Chat(chatMessageId: 1, chatMessageBody: "my love", chatMessageTime: "my love", sendUserInfoId: 1, sendUserNickname: "myco sdf", isMine: true)]
    
    private var swiftStomp: SwiftStomp!
    private var messageIndex = 0
    
    private var locationManager = CLLocationManager()
    

    func aboutLocation(){
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            print("위 서 on")
            locationManager.startUpdatingLocation()
            print(locationManager.location?.coordinate)
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        aboutLocation()
        
        userInfoId = UserDefaults.standard.integer(forKey: "userInfoId")
        
       

        initStomp()
        registerObservers()
        
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
    
    private func initStomp(){
    
        let url = URL(string: "ws://test.rudderuni.com/ws")!
        
        self.swiftStomp = SwiftStomp(host: url)
        self.swiftStomp.enableLogging = true
        self.swiftStomp.delegate = self
        self.swiftStomp.autoReconnect = true
                
        self.swiftStomp.enableAutoPing()
    }

    private func registerObservers(){
        //NotificationCenter.default.addObserver(self, selector: #selector(appWillResignActive), name: NSNotification.Name.willResignActiveNotification, object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: NSNotification.Name.UIApplication.didBecomeActiveNotification, object: nil)
        
    }
    /**
     * Observer functions
     */
    @objc func appDidBecomeActive(notification : Notification){
        if !self.swiftStomp.isConnected{
            self.swiftStomp.connect()
        }
    }
    
    @objc func appWillResignActive(notication : Notification){
        if self.swiftStomp.isConnected{
            self.swiftStomp.disconnect(force: true)
        }
    }
    
    @IBAction func triggerConnect(_ sender: Any) {
        if !self.swiftStomp.isConnected{
            self.swiftStomp.connect()
        }
        
    }
        
    @IBAction func triggerDisconnect(_ sender: Any) {
        if self.swiftStomp.isConnected{
            self.swiftStomp.disconnect()
        }
    }
}

extension ChatViewController: SwiftStompDelegate{
    
    func onConnect(swiftStomp: SwiftStomp, connectType: StompConnectType) {
            if connectType == .toSocketEndpoint{
                print("Connected to socket")
            } else if connectType == .toStomp{
                print("Connected to stomp")
                
                //** Subscribe to topics or queues just after connect to the stomp!
                swiftStomp.subscribe(to: "/topic/1")
                //swiftStomp.subscribe(to: "/topic/greeting2")
                
            }
        }
        
        func onDisconnect(swiftStomp: SwiftStomp, disconnectType: StompDisconnectType) {
            if disconnectType == .fromSocket{
                print("Socket disconnected. Disconnect completed")
            } else if disconnectType == .fromStomp{
                print("Client disconnected from stomp but socket is still connected!")
            }
        }
        
        func onMessageReceived(swiftStomp: SwiftStomp, message: Any?, messageId: String, destination: String, headers : [String : String]) {
            
            if let message = message as? Data {
                print("as DATA")
                handleMessageBody(message: message)
            }else if let message = message as? String{
                let dMessage = message.data(using: .utf8)!
                handleMessageBody(message: dMessage)
                print("as STRING")
            }
            
            print()
        }
        
        func onReceipt(swiftStomp: SwiftStomp, receiptId: String) {
            print("Receipt with id `\(receiptId)` received")
        }
        
        func onError(swiftStomp: SwiftStomp, briefDescription: String, fullDescription: String?, receiptId: String?, type: StompErrorType) {
            if type == .fromSocket{
                print("Socket error occurred! [\(briefDescription)]")
            } else if type == .fromStomp{
                print("Stomp error occurred! [\(briefDescription)] : \(String(describing: fullDescription))")
            } else {
                print("Unknown error occured!")
            }
        }
        
        func onSocketEvent(eventName: String, description: String) {
            print("Socket event occured: \(eventName) => \(description)")
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
                
                self.chats.append(Chat(chatMessageId: decodedResponse.chatMessageId, chatMessageBody: decodedResponse.chatMessageBody, chatMessageTime: decodedResponse.chatMessageTime, sendUserInfoId: decodedResponse.sendUserInfoId, sendUserNickname: decodedResponse.sendUserNickname, isMine: decodedResponse.isMine))
                
             
                
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
        
        self.chats.append(Chat(chatMessageId: 123, chatMessageBody: textField.text!, chatMessageTime: "123", sendUserInfoId: userInfoId, sendUserNickname: "mockNickname", isMine: true))
        
     
        
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

extension ChatViewController {
    @IBAction func tapPayButton(_ sender: UIButton) {
        showOrderSheet()

    }
    
    private func showOrderSheet() {
           // Open the buy modal
           let orderViewController = OrderViewController()
           orderViewController.delegate = self
           let nc = OrderNavigationController(rootViewController: orderViewController)
           nc.modalPresentationStyle = .custom
           nc.transitioningDelegate = self
           present(nc, animated: true, completion: nil)
       }
}






protocol OrderViewControllerDelegate: AnyObject {
    func didRequestPayWithApplyPay()
    func didRequestPayWithCard()
}

class OrderViewController : UIViewController {
    weak var delegate: OrderViewControllerDelegate?
    var applePayResponse : String?
        
    override func loadView() {
        let orderView = OrderView()
        self.view = orderView

        orderView.addCardButton.addTarget(self, action: #selector(didTapPayButton), for: .touchUpInside)
        orderView.applePayButton.addTarget(self, action: #selector(didTapApplePayButton), for: .touchUpInside)
        orderView.closeButton.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
    }

        // MARK: - Button tap functions
        
    @objc private func didTapCloseButton() {
        dismiss(animated: true, completion: nil)
    }
        
    @objc private func didTapPayButton() {
        delegate?.didRequestPayWithCard()
    }
        
    @objc private func didTapApplePayButton() {
        delegate?.didRequestPayWithApplyPay()
            
    }
    
}

extension OrderViewController: HalfSheetPresentationControllerHeightProtocol {
    var halfsheetHeight: CGFloat {
        return (view as! OrderView).stackView.systemLayoutSizeFitting(UIView.layoutFittingExpandedSize).height
    }
}
    
class OrderNavigationController : UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationBarHidden(true, animated: false)
    }
}

extension OrderNavigationController: HalfSheetPresentationControllerHeightProtocol {
    var halfsheetHeight: CGFloat {
        return ((viewControllers.last as? HalfSheetPresentationControllerHeightProtocol)?.halfsheetHeight ?? 0.0) + navigationBar.bounds.height
    }
}


class OrderView : UIView {
    lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 30
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)

        return view
    }()
    

    lazy var addCardButton = ActionButton(backgroundColor: Color.primaryAction, title: "Pay with card", image: nil)
    lazy var applePayButton = ActionButton(backgroundColor: Color.applePayBackground, title: nil, image:UIImage(systemName: "applelogo"))
    private lazy var headerView = HeaderView(title: "Place your order")

    var closeButton: UIButton {
        return headerView.closeButton
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = Color.popupBackground

        stackView.addArrangedSubview(headerView)
        stackView.addArrangedSubview(TableRowView(heading: "Ship to", title: "Lauren Nobel", subtitle: "1455 Market Street\nSan Francisco, CA, 94103"))
        stackView.addArrangedSubview(HairlineView())
        stackView.addArrangedSubview(TableRowView(heading: "Total", title: "$1.00", subtitle: nil))
        stackView.addArrangedSubview(HairlineView())
        stackView.addArrangedSubview(makeRefundLabel())

        let payStackView = UIStackView()
        payStackView.spacing = 12
        payStackView.distribution = .fillEqually
        payStackView.addArrangedSubview(addCardButton)
        payStackView.addArrangedSubview(applePayButton)
        stackView.addArrangedSubview(payStackView)

        addSubview(stackView)

        stackView.pinToTop(ofView: self)
    }
}

extension OrderView {
    private func makeRefundLabel() -> UILabel {
        let label = UILabel()

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8
        let attributes = [NSAttributedString.Key.paragraphStyle : paragraphStyle]

        label.attributedText = NSMutableAttributedString(string: "You can refund this transaction through your Square dashboard, goto squareup.com/dashboard.", attributes: attributes)
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor(red: 0.48, green: 0.48, blue: 0.48, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }
}


class ActionButton: UIButton {
    init(backgroundColor: UIColor, title: String?, image: UIImage?) {
        super.init(frame: .zero)

        commonInit()

        self.backgroundColor = backgroundColor
        setTitle(title, for: .normal)
        setImage(image, for: .normal)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        setTitleColor(.white, for: .normal)

        titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        titleLabel?.textAlignment = .center
        titleLabel?.adjustsFontSizeToFitWidth = true
        translatesAutoresizingMaskIntoConstraints = false

        contentEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = bounds.height / 2
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        alpha = 0.7
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)

        alpha = 1.0
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)

        alpha = 1.0
    }
}

class HairlineView : UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        backgroundColor = Color.hairlineColor
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 1)
    }
}

class HeaderView : UIStackView {
    lazy var closeButton = makeCloseButton()
    private var title: String = ""

    init(title: String) {
        super.init(frame: .zero)
        commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        distribution = .fillProportionally
        alignment = .center
        layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        isLayoutMarginsRelativeArrangement = true
        addArrangedSubview(closeButton)
        addArrangedSubview(makeOrderTitleLabel(text: title))

        let hiddenCloseButton = makeCloseButton()
        hiddenCloseButton.alpha = 0.0
        addArrangedSubview(hiddenCloseButton)
    }
}

extension HeaderView {
    private func makeCloseButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = Color.descriptionFont

        return button
    }


    private func makeOrderTitleLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = "Place your order"
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .center

        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }
}

class TableRowView : UIStackView {
    var heading: String?
    var title: String?
    var subtitle: String?

    init(heading: String?, title: String?, subtitle: String?) {
        self.heading = heading
        self.title = title
        self.subtitle = subtitle

        super.init(frame: .zero)

        commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        axis = .horizontal
        distribution = .fillProportionally
        alignment = .top
        spacing = 30
        layoutMargins = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        isLayoutMarginsRelativeArrangement = true

        if let heading = heading {
            addArrangedSubview(makeHeadingLabel(text: heading))
        }

        let bodyStackView = UIStackView()
        bodyStackView.axis = .vertical
        bodyStackView.spacing = 6
        addArrangedSubview(bodyStackView)

        if let title = title {
            bodyStackView.addArrangedSubview(makeTitleLabel(text: title))
        }

        if let subtitle = subtitle {
            bodyStackView.addArrangedSubview(makeSubtitleLabel(text: subtitle))
        }
    }
}

extension TableRowView {
    private class HeadlingLabel: UILabel {
        override init(frame: CGRect) {
            super.init(frame: frame)
            commonInit()
        }

        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)

            commonInit()
        }

        func commonInit() {
            textColor = Color.heading
            font = UIFont.systemFont(ofSize: 16, weight: .regular)
            translatesAutoresizingMaskIntoConstraints = false
            setContentHuggingPriority(.required, for: .horizontal)
        }

        override var intrinsicContentSize: CGSize {
            return CGSize(width: 54, height: super.intrinsicContentSize.height)
        }
    }

    private func makeHeadingLabel(text: String?) -> UILabel {
        let label = HeadlingLabel()
        label.text = text

        return label
    }

    private func makeTitleLabel(text: String?) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)

        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }

    private func makeSubtitleLabel(text: String) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = UIColor(red: 0.48, green: 0.48, blue: 0.48, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)

        let paragraphStyle = NSMutableParagraphStyle()
        let attributes = [NSAttributedString.Key.paragraphStyle : paragraphStyle]
        label.attributedText = NSMutableAttributedString(string: text, attributes: attributes)

        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }
}


struct Color {
    static let background = UIColor(red: 0.47, green: 0.8, blue: 0.77, alpha: 1.0)
    static let popupBackground = UIColor.white
    static let primaryAction = UIColor(red: 0.14, green: 0.6, blue: 0.55, alpha: 1)
    static let applePayBackground = UIColor.black
    static let hairlineColor = UIColor.black.withAlphaComponent(0.1)
    static let descriptionFont = UIColor(red: 0.48, green: 0.48, blue: 0.48, alpha: 1)
    static let navigationBarTintColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1)
    static let heading = UIColor(red: 0.14, green: 0.6, blue: 0.55, alpha: 1)
}

extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }

    func pinToTop(ofView view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.topAnchor.constraint(equalTo: view.topAnchor),
        ])
    }
}


protocol HalfSheetPresentationControllerHeightProtocol: AnyObject {
    var halfsheetHeight: CGFloat { get }
}

class HalfSheetPresentationController: UIPresentationController {
    private lazy var dimmingView = makeDimmingView()

    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView, let sheetHeight = (presentedViewController as? HalfSheetPresentationControllerHeightProtocol)?.halfsheetHeight else {
            return super.frameOfPresentedViewInContainerView
        }

        return CGRect(x: 0,
                      y: containerView.bounds.height - sheetHeight,
                      width: containerView.bounds.width,
                      height: sheetHeight)
    }

    override func presentationTransitionWillBegin() {
        containerView?.addSubview(dimmingView)
        dimmingView.frame = containerView!.bounds

        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] (context) in
            self?.dimmingView.alpha = 1.0
        }, completion: nil)
    }

    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] (context) in
            self?.dimmingView.alpha = 0.0
        }, completion: nil)
    }

    @objc func didTapBackground() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }

    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()

        presentedView?.roundCorners(corners: [.topLeft, .topRight], radius: 12)
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
}

extension HalfSheetPresentationController {
    private func makeDimmingView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        view.alpha = 0.0

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapBackground))
        view.addGestureRecognizer(tapGesture)

        return view
    }

    private func makePaddingView() -> UIView {
        let view = UIView()
        view.backgroundColor = Color.popupBackground

        return view
    }
}


extension ChatViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("didUpdateLocations")
        if let location = locations.first {
            print("위도: \(location.coordinate.latitude)")
            print("경도: \(location.coordinate.longitude)")
        } else {
            print("위치 서비스 off 상태")
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("위치 서비스 error")
    }
}

struct Constants {
    struct ApplePay {
        static let MERCHANT_IDENTIFIER: String = "REPLACE_ME"
        static let COUNTRY_CODE: String = "US"
        static let CURRENCY_CODE: String = "USD"
    }

    struct Square {
        static let SQUARE_LOCATION_ID: String = "REPLACE_ME"
        static let APPLICATION_ID: String  = "REPLACE_ME"
        static let CHARGE_SERVER_HOST: String = "REPLACE_ME"
        static let CHARGE_URL: String = "\(CHARGE_SERVER_HOST)/chargeForCookie"
    }
}

//
//  MakePreViewController.swift
//  Rudder
//
//  Created by 박민호 on 2022/07/18.
//

import UIKit

final class MakePreViewController: UIViewController, UINavigationControllerDelegate {
    
    let viewModel: MakePreViewModel = MakePreViewModel()
    
    weak var delegate: DoRefreshPartyDelegate?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var thumbnailImageView: ButtonView!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var participantsPicker: UITextField!
    @IBOutlet weak var descriptionView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var locationField: UITextField!
    
    @IBOutlet weak var postButton: UIButton!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    private var currentEditFieldBottom: CGFloat = 0.0
    private var originalOffset: CGFloat = 0.0
    
    
    let imagePicker = UIImagePickerController()
    let pickerView = UIPickerView() //participant number pickerView
}

extension MakePreViewController {
    
    
    @IBAction func touchUpPostButton(_ sender: UIButton){
      
        viewModel.partyDescription = descriptionView.text
        if participantsPicker.text == "Select" {viewModel.participantNumber = 0}
        else { viewModel.participantNumber = Int(participantsPicker.text ?? "0")! }
        viewModel.locationString = locationField.text
        viewModel.partyTitle = titleField.text
        viewModel.requestMakeParty()
    }
    
    @objc func pickImage(_ sender: ButtonView){
        self.present(self.imagePicker, animated: true)
    }
}

extension MakePreViewController {
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUIs()
        setUpBinding()
        setParticipantsPicker()
        setImagePicker()
        placeholderSetting()
        hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    
    func setUpBinding(){
        viewModel.makePartyResultFlag.bind { [weak self] status in
            guard let self = self else {return}
            DispatchQueue.main.async {
                switch status {
                case 1:
                    self.delegate?.doRefreshParty()
                    
                    Alert.showAlertWithCB(title: "Success!", message: nil, isConditional: false, viewController: self) {_ in 
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                case -2 : Alert.showAlert(title: "one or more fields are empty", message: nil, viewController: self)
                default : Alert.showAlert(title: "server error", message: nil, viewController: self)
                }
            }
        }
        viewModel.isLoadingFlag.bind{ [weak self] status in
            guard let self = self else {return}
            DispatchQueue.main.async {
                if status {
                    LoadingScreen.shared.showLoadingPage(_view: self)
                    self.view.isUserInteractionEnabled = false
                }
                else {
                    LoadingScreen.shared.hideLoadingPage(_view: self)
                    self.view.isUserInteractionEnabled = true
                }
            }
        }
    }
}

extension MakePreViewController {
    @IBAction func changeDatePicker(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
       // print(formatter.string(from: sender.date))
        viewModel.partyDate = formatter.string(from: sender.date)
    }
}

extension MakePreViewController: UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    func setParticipantsPicker() {
        participantsPicker.text = "Select"
        
        pickerView.delegate = self
        participantsPicker.inputView = pickerView
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let tmpBarButton = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(self.done))
        tmpBarButton.tintColor = MyColor.rudderPurple
        let button = tmpBarButton
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        participantsPicker.inputAccessoryView = toolBar
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        viewModel.minimumParticipants.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(viewModel.minimumParticipants[row])
    }
    
    @objc func done(){
            
        participantsPicker.text = String(viewModel.minimumParticipants[pickerView.selectedRow(inComponent: 0)])
        participantsPicker.endEditing(true)
    }
    
}

extension MakePreViewController : UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
        var newImage: UIImage? = nil // update 할 이미지
            
        if let possibleImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            newImage = possibleImage // 수정된 이미지가 있을 경우
        } else if let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            newImage = possibleImage // 원본 이미지가 있을 경우
        }
            
        let imageURL: NSURL = info[UIImagePickerController.InfoKey.imageURL] as! NSURL
        let imageString = imageURL.absoluteString
    
        let imageMetadata: ImageMetaData!
        
        print("fileType "+imageString!.suffix(4))
        
        switch imageString!.suffix(4){
        case "jpeg" : imageMetadata = ImageMetaData(contentType: "image/jpeg", fileName: "mock")
        case ".png" : imageMetadata = ImageMetaData(contentType: "image/png", fileName: "mock")
        case "heic" : imageMetadata = ImageMetaData(contentType: "image/heic", fileName: "mock")
        case "heif" : imageMetadata = ImageMetaData(contentType: "image/heif", fileName: "mock")
        case "heix" : imageMetadata = ImageMetaData(contentType: "image/heix", fileName: "mock")
        default:
            Alert.showAlert(title: "Unsupported file format", message: nil, viewController: self)
            return
        }
        
        setImageToView(image: newImage!)
        viewModel.imageMetaData = imageMetadata
        viewModel.thumbnailImage = newImage!
        picker.dismiss(animated: true, completion: nil)
    }
    
    func setImageToView(image: UIImage){
        let imageView = UIImageView(image: image)
        imageView.frame = thumbnailImageView.frame
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        contentView.addSubview(imageView)
    }
    
    func setImagePicker() {
        self.imagePicker.sourceType = .photoLibrary // 앨범에서 가져옴
        self.imagePicker.allowsEditing = true // 수정 가능 여부
        self.imagePicker.delegate = self
        thumbnailImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pickImage(_:))))
    }
}

extension MakePreViewController {
    func setUIs(){
        postButton.applyGradient(colors: MyColor.gPurple)
        self.navigationController?.navigationBar.tintColor = UIColor.black
        participantsPicker.tintColor = .clear
        descriptionView.textContainerInset = UIEdgeInsets(top: 9, left: 7, bottom: 9, right: 7)
        titleField.addLeftPadding(padding: 7)
        locationField.addLeftPadding(padding: 7)
        datePicker.contentHorizontalAlignment = .left
        
        locationField.delegate = self
        titleField.delegate = self
        //datePicker.lang
    }
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}



extension MakePreViewController: UITextViewDelegate {
    func placeholderSetting() {
        descriptionView.delegate = self // txtvReview가 유저가 선언한 outlet
        descriptionView.text = "Tell the pre's concept, plan after the pre, etc"
        descriptionView.textColor = UIColor.lightGray
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        originalOffset = scrollView.contentOffset.y
        currentEditFieldBottom = textView.frame.origin.y + textView.frame.height
        print("textViewBegin Editing")
        
        if descriptionView.textColor == UIColor.lightGray {
            descriptionView.text = nil
            descriptionView.textColor = UIColor.black
        }
        
    }
    // TextView Place Holder
    func textViewDidEndEditing(_ textView: UITextView) {
        if descriptionView.text.isEmpty {
            descriptionView.text = "Tell the pre's concept, plan after the pre, etc"
            descriptionView.textColor = UIColor.lightGray
        }
    }
}

extension MakePreViewController {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
        originalOffset = scrollView.contentOffset.y
        currentEditFieldBottom = textField.frame.origin.y + textField.frame.height
        print("textFieldBegin Editing")
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .microseconds(50)) { [self] in //textViewDidBeginEditing이 keyboardwillshow보다 늦어서
            // code
            print("keyboardwillshow")
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                print(String(describing: currentEditFieldBottom) + " " + String(describing: self.scrollView.frame.height) + " " + String(describing: keyboardSize.height) + " " + String(describing: originalOffset))
                
                if currentEditFieldBottom <= self.scrollView.frame.height - keyboardSize.height + originalOffset{
                    return
                }
                let cp = CGPoint(x: 0, y: currentEditFieldBottom - self.scrollView.frame.height + keyboardSize.height)
                if self.scrollView.contentOffset.y == originalOffset {
                    scrollView.setContentOffset(cp, animated: true)
                }
            }
        }
        
            
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        print("willresign")
        if scrollView.contentOffset.y != originalOffset{
            scrollView.contentOffset.y = originalOffset
        }
    }
}

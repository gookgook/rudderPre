//
//  MakePreViewController.swift
//  Rudder
//
//  Created by 박민호 on 2022/07/18.
//

import UIKit

class MakePreViewController: UIViewController, UINavigationControllerDelegate {
    
    let viewModel: MakePreViewModel = MakePreViewModel()
    
    weak var delegate: DoRefreshPartyDelegate?
    
    @IBOutlet weak var thumbnailImageView: ButtonView!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var participantsPicker: UITextField!
    @IBOutlet weak var descriptionView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var locationField: UITextField!
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var postButton: UIButton!
    
    let imagePicker = UIImagePickerController()
    let pickerView = UIPickerView() //participant number pickerView
    
    
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
        
        //datePicker.lang
    }
}

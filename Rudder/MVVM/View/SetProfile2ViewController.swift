//
//  SetProfileViewController.swift
//  Rudder
//
//  Created by 박민호 on 2022/06/28.
//

import UIKit

class SetProfile2ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var viewModel: SignUpViewModel? // setProfile1Viewcontroller 에서 넘겨줄거임
    
    let imagePicker = UIImagePickerController()
    var currentImagePicker: Int = 0
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var imagePickView1: ButtonView!
    @IBOutlet weak var imagePickView2: ButtonView!
    @IBOutlet weak var imagePickView3: ButtonView!
    @IBOutlet weak var imagePickView4: ButtonView!
    @IBOutlet weak var imagePickView5: ButtonView!
    @IBOutlet weak var imagePickView6: ButtonView!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    var availablePicker = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setImagePicker()
        setUpBinding()
        setUIs()
    }
    
    @IBAction func touchUpSignUpButton(_ sender: UIButton){
        viewModel?.requestSignUp()
    }
    
    func setUpBinding(){
        viewModel?.signUpResultFlag.bind { [weak self] status in
            guard let self = self else {return}
            DispatchQueue.main.async { /*self.spinner.stopAnimating()*/ }
            switch status {  // school name이 올 수도 있어서 오류상황들 앞에 놓고 그게 아니라면 school name 이 온걸로 간주해서 default에서 처리
            case -1 : DispatchQueue.main.async { Alert.showAlert(title: "Server Error", message: nil, viewController: self) }
            case 5: DispatchQueue.main.async { Alert.showAlert(title: "photo count", message: nil, viewController: self)}
            case 1 :
                print("sign up process completed")
                self.navigationController?.popToRootViewController(animated: true)
            default : print("server error")
            }
        }
        
        viewModel?.isLoadingFlag.bind{ [weak self] status in
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

extension SetProfile2ViewController {
    
    @objc func pickImage1(_ sender: ButtonView){
        currentImagePicker = 0
        guard availablePicker == currentImagePicker else { Alert.showAlert(title: ConstStrings.SELECT_PREVIOUS_FIRST, message: nil, viewController: self); return;}
        self.present(self.imagePicker, animated: true)
    }
    @objc func pickImage2(_ sender: ButtonView){
        currentImagePicker = 1
        guard availablePicker == currentImagePicker else { Alert.showAlert(title: ConstStrings.SELECT_PREVIOUS_FIRST, message: nil, viewController: self); return;}
        self.present(self.imagePicker, animated: true)
    }
    @objc func pickImage3(_ sender: ButtonView){
        currentImagePicker = 2
        guard availablePicker == currentImagePicker else { Alert.showAlert(title: ConstStrings.SELECT_PREVIOUS_FIRST, message: nil, viewController: self); return;}
        self.present(self.imagePicker, animated: true)
    }
    @objc func pickImage4(_ sender: ButtonView){
        currentImagePicker = 3
        guard availablePicker == currentImagePicker else { Alert.showAlert(title: ConstStrings.SELECT_PREVIOUS_FIRST, message: nil, viewController: self); return;}
        self.present(self.imagePicker, animated: true)
    }
    @objc func pickImage5(_ sender: ButtonView){
        currentImagePicker = 4
        guard availablePicker == currentImagePicker else { Alert.showAlert(title: ConstStrings.SELECT_PREVIOUS_FIRST, message: nil, viewController: self); return;}
        self.present(self.imagePicker, animated: true)
    }
    @objc func pickImage6(_ sender: ButtonView){
        currentImagePicker = 5
        guard availablePicker == currentImagePicker else { Alert.showAlert(title: ConstStrings.SELECT_PREVIOUS_FIRST, message: nil, viewController: self); return;}
        self.present(self.imagePicker, animated: true)
    }
    
    func setImageToView(image: UIImage){
        let imageView = UIImageView(image: image)
        
        switch currentImagePicker{
        case 0: imageView.frame = imagePickView1.frame
        case 1: imageView.frame = imagePickView2.frame
        case 2: imageView.frame = imagePickView3.frame
        case 3: imageView.frame = imagePickView4.frame
        case 4: imageView.frame = imagePickView5.frame
        case 5: imageView.frame = imagePickView6.frame
        default: return
        }
        self.view.addSubview(imageView)

    }
}


extension SetProfile2ViewController {
    
    func setImagePicker(){
        
        imagePickView1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pickImage1(_:))))
        imagePickView2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pickImage2(_:))))
        imagePickView3.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pickImage3(_:))))
        imagePickView4.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pickImage4(_:))))
        imagePickView5.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pickImage5(_:))))
        imagePickView6.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pickImage6(_:))))
        
        
        self.imagePicker.sourceType = .photoLibrary // 앨범에서 가져옴
            self.imagePicker.allowsEditing = true // 수정 가능 여부
            self.imagePicker.delegate = self // picker delegate
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let viewModel = viewModel else { print("no Viewmodel"); return; }
            
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
        viewModel.imageMetaDatas.append(imageMetadata)
        viewModel.profileImages.append(newImage!)
            //self.profileImageView.image = newImage // 받아온 이미지를 update
        availablePicker = currentImagePicker + 1
        picker.dismiss(animated: true, completion: nil) // picker를 닫아줌
    
        
        
        print("photo count ",String(viewModel.profileImages.count))
        
        }
}


extension SetProfile2ViewController {
    func setUIs(){
        signUpButton.applyGradient(colors: MyColor.gPurple)
    }
}

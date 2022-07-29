//
//  SetProfileViewController.swift
//  Rudder
//
//  Created by 박민호 on 2022/06/28.
//

import UIKit

class SetProfile2ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imagePicker = UIImagePickerController()
    var currentImagePicker: Int = 1
    
    
    var viewModel: SignUpViewModel? // setProfile1Viewcontroller 에서 넘겨줄거임
    @IBOutlet weak var spView: UIView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setImagePicker()
        setUpBinding()
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
            case 4: DispatchQueue.main.async { Alert.showAlert(title: "profile body count", message: nil, viewController: self)}
            case 1 : print("sign up process completed")
            default : print("server error")
            }
        }
    }
}

extension SetProfile2ViewController {
    
    @IBAction func pickImage1(_ sender: UIButton){
        currentImagePicker = 0
        self.present(self.imagePicker, animated: true)
    }
    @IBAction func pickImage2(_ sender: UIButton){
        currentImagePicker = 1
        self.present(self.imagePicker, animated: true)
    }
    @IBAction func pickImage3(_ sender: UIButton){
        currentImagePicker = 2
        self.present(self.imagePicker, animated: true)
    }
    @IBAction func pickImage4(_ sender: UIButton){
        currentImagePicker = 3
        self.present(self.imagePicker, animated: true)
    }
    @IBAction func pickImage5(_ sender: UIButton){
        currentImagePicker = 4
        self.present(self.imagePicker, animated: true)
    }
    @IBAction func pickImage6(_ sender: UIButton){
        currentImagePicker = 5
        self.present(self.imagePicker, animated: true)
    }
}


extension SetProfile2ViewController {
    
    func setImagePicker(){
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
        
        viewModel.imageMetaDatas.append(imageMetadata)
            //self.profileImageView.image = newImage // 받아온 이미지를 update
        picker.dismiss(animated: true, completion: nil) // picker를 닫아줌
    

        let imageView = UIImageView(image: newImage!)
        imageView.frame = CGRect(x: spView.frame.origin.x, y: spView.frame.origin.y + spView.frame.height + 60, width: 120, height: 120)

        spView.addSubview(imageView)
        viewModel.profileImages.append(newImage!)
        
        
        print(imageString!)
        print("photo count ",String(viewModel.profileImages.count))
        
        }
}

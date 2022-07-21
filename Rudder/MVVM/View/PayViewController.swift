//
//  PayViewController.swift
//  Rudder
//
//  Created by 박민호 on 2022/07/19.
//

import UIKit
import SquareInAppPaymentsSDK

class PayViewController: UIViewController, UIViewControllerTransitioningDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func tapPayButton(_ sender: UIButton) {
        showOrderSheet()
    }
    
    func showSuccessAlert() {
        Alert.showAlert(title: "결제 성공!", message: nil, viewController: self)
    }
    func showFailureAlert() {
        Alert.showAlert(title: "개같이 실패", message: nil, viewController: self)
    }
    func showCanceledAlert(){
        Alert.showAlert(title: "Payment Canceled", message: nil, viewController: self)
    }
}

extension PayViewController {
    private func showOrderSheet() {
           // Open the buy modal
        let orderViewController = OrderViewController(str: "FC Barcelona")
        orderViewController.delegate = self
        let nc = OrderNavigationController(rootViewController: orderViewController)
        nc.modalPresentationStyle = .custom
        nc.transitioningDelegate = self
        present(nc, animated: true, completion: nil)
    }
}


extension PayViewController : OrderViewControllerDelegate ,SQIPCardEntryViewControllerDelegate,PKPaymentAuthorizationViewControllerDelegate {
    func didRequestPayWithApplyPay() {
        dismiss(animated: true) { //이게 뭔데??
             self.requestApplePayAuthorization()
        }
    }
    
    func didRequestPayWithCard() {
        dismiss(animated: true) {
            let vc = self.makeCardEntryViewController()
            vc.delegate = self
            vc.isModalInPresentation = true //이거 알앤디

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
    
    func cardEntryViewController(_ cardEntryViewController: SQIPCardEntryViewController, didObtain cardDetails: SQIPCardDetails, completionHandler: @escaping (Error?) -> Void) {
        print("Payment token (nonce) generated by In-App Payments SDK: \(cardDetails.nonce)")
        
        RequestPay.uploadInfo(sourceId: cardDetails.nonce, amount: 1.01, completion: {status in
            print("payment status",String(status!))
            if status == 1 {
                DispatchQueue.main.async {
                    self.dismiss(animated: true)
                    self.showSuccessAlert()
                }
                
            } else {
                DispatchQueue.main.async {
                    self.dismiss(animated: true)
                    self.showFailureAlert()
                }
            }
        })
    }
    
   /* func cardEntryViewController(_ cardEntryViewController: SQIPCardEntryViewController, didObtain cardDetails: SQIPCardDetails) async throws {
        print("Payment token (nonce) generated by In-App Payments SDK")
    }*/
    
    func cardEntryViewController(_ cardEntryViewController: SQIPCardEntryViewController, didCompleteWith status: SQIPCardEntryCompletionStatus) {
        print("Payment token (nonce) generated by In-App Payments SDK cancled?")
        DispatchQueue.main.async {
            self.dismiss(animated: true)
            self.showCanceledAlert()
        }
        
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
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        print("finish")
    }
}



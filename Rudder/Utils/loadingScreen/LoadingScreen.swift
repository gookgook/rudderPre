//
//  LoadingScreen.swift
//  Rudder
//
//  Created by 박민호 on 2022/12/02.
//

import Foundation
import UIKit

class LoadingScreen {
    var loadingScreenView:LoadingScreenView?
        
        static let shared = LoadingScreen()
        private init(){ }
        
        //MARK: 보이기
        func showLoadingPage(_view:UIViewController) {

            let width = getRootViewController(vc: _view)?.view.frame.size.width ?? 0
            let height = getRootViewController(vc: _view)?.view.frame.size.height ?? 0

            loadingScreenView = LoadingScreenView(frame: CGRect(x: 0, y: 0, width: width , height: height))
            
            if let loadingScreenView = loadingScreenView {
                loadingScreenView.startLoading()
                self.getRootViewController(vc:_view)?.view.addSubview(loadingScreenView)
            }

        }

        //MARK: 숨기기
        func hideLoadingPage(_view:UIViewController) {
            
            // loading View의 tag 는 100
            if let loadingView = self.getRootViewController(vc: _view)?.view.viewWithTag(100) {
                
                loadingScreenView?.stopLoading()
                loadingView.removeFromSuperview()
            
            }
        }
        
        /**
         # getRootViewController
         - Author: k
         - Date:
         - Parameters:
            - vc: rootViewController 혹은 UITapViewController
         - Returns: UIViewController?
         - Note: vc내에서 가장 최상위에 있는 뷰컨트롤러 반환
        */
        public func getRootViewController(vc:UIViewController) ->UIViewController?{

        
            ///[1] 네비게이션 컨트롤러
            if let nc = vc as? UINavigationController {

                if let vcOfnavController = nc.visibleViewController {
                    return self.getRootViewController(vc: vcOfnavController)
                }
            
            ///[2] 탭뷰 컨트롤러
            }else if let tc = vc as? UITabBarController {
                
                if let tcOfnavControler = tc.selectedViewController {
                    return self.getRootViewController(vc: tcOfnavControler)
                }
                
            ///[3] 뷰 컨트롤러
            }else{
                if let pvc = vc.presentedViewController{
                    return self.getRootViewController(vc: pvc)
                }else {
                    return vc
                }
            }
            
            return nil
        }
}

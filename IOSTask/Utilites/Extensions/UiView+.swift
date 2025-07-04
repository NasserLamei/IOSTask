//
//  UiView+.swift
//  IOSTask
//
//  Created by Nasser Lamei on 03/07/2025.
//

import Foundation
import UIKit
import MBProgressHUD

extension UIView{
    func addShadowAndCorner(cornerRadius: CGFloat, shadowColor: UIColor, shadowOpacity: Float, shadowRadius: CGFloat, borderWidth: CGFloat = 0.0, borderColor: UIColor? = nil) {
        layer.cornerRadius = cornerRadius
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = CGSize.zero
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        layer.masksToBounds = false
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor?.cgColor
    }
}

extension UIViewController{
    func showHUD(progressLabel:String){
        let progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
        progressHUD.label.text = progressLabel
    }
    
    func dismissHUD(isAnimated:Bool) {
        MBProgressHUD.hide(for: self.view, animated: isAnimated)
    }
}

//
//  TextField+.swift
//  IOSTask
//
//  Created by Nasser Lamei on 03/07/2025.
//

import Foundation
import UIKit


extension UITextField{
    //that use to avoid sent empty string to api ""
    var isTextEmpty: Bool {
          return self.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true
      }
 
}

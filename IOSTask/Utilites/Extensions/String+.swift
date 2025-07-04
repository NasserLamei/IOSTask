//
//  String+.swift
//  IOSTask
//
//  Created by Nasser Lamei on 03/07/2025.
//

import Foundation

extension String {
    var englishDigits: String {
        return self.applyingTransform(.toLatin, reverse: false)?
                   .components(separatedBy: CharacterSet(charactersIn: "0123456789.").inverted)
                   .joined() ?? self
    }
}

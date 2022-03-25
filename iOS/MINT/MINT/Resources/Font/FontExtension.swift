//
//  FontExtension.swift
//  MINT
//
//  Created by choymoon on 2022/03/22.
//

import UIKit

extension UIFont {
    
    public static func rubikOne(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: "RubikOne-Regular", size: size) else {
            return UIFont.systemFont(ofSize: size)
        }
        return font
    }
}

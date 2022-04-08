//
//  FontExtension.swift
//  MINT
//
//  Created by choymoon on 2022/03/22.
//

import UIKit

extension UIFont {
    
    public static func rubikOne(size: CGFloat, _ isRatioSized: Bool = true) -> UIFont {
        let rSize = isRatioSized ? sizeWithScreenRatio(size: size) : size
        guard let font = UIFont(name: "RubikOne-Regular", size: rSize) else {
            return UIFont.systemFont(ofSize: rSize)
        }
        return font
    }
    
    enum Pretendard: String {
        case regular = "Pretendard-Regular"
        case thin = "Pretendard-Thin"
        case extraLight = "Pretendard-ExtraLight"
        case light = "Pretendard-Light"
        case medium = "Pretendard-Medium"
        case semiBold = "Pretendard-SemiBold"
        case bold = "Pretendard-Bold"
        case black = "Pretendard-Black"
        case extraBlack = "Pretendard-ExtraBlack"
    }
    
    static func pretendard(_ type : Pretendard, size : CGFloat, _ isRatioSized: Bool = true) -> UIFont {
        let rSize = isRatioSized ? sizeWithScreenRatio(size: size) : size
        let font = UIFont(name: type.rawValue, size: rSize)
        
        guard let rFont = font else {
            return UIFont.systemFont(ofSize: rSize)
        }
        
        return rFont
    }
    
    private static func sizeWithScreenRatio(size: CGFloat) -> CGFloat {
        let ratio = UIScreen.main.bounds.width / 375
        
        return size * ratio
    }
}

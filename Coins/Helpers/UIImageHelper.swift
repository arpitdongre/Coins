//
//  UIImageHelper.swift
//  Coins
//
//  Created by Arpit Dongre on 22/11/24.
//

import UIKit

extension UIImage {
    static func fromColor(_ color: UIColor) -> UIImage {
        let size = CGSize(width: 1, height: 0.5)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

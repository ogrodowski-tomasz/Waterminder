//
//  UIImage+Extensions.swift
//  Waterminder
//
//  Created by Tomasz Ogrodowski on 07/02/2023.
//

import UIKit

extension UIImage {

    func isEqualTo(image: UIImage?) -> Bool {
        if
            let image,
            let selfData = self.pngData(),
            let secondImageData = image.pngData()
        {
            return selfData == secondImageData
        }
        return false
    }

}

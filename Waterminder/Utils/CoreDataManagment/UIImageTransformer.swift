//
//  UIImageTransformer.swift
//  Waterminder
//
//  Created by Tomasz Ogrodowski on 06/02/2023.
//

import UIKit

class UIImageTransformer: ValueTransformer {

    override func transformedValue(_ value: Any?) -> Any? {
        // Converting UIImage to Data
        guard let uiImage = value as? UIImage else { return nil }

        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: uiImage, requiringSecureCoding: true)
            return data
        } catch {
            print("DEBUG: Failed to convert UIImage to Data: \(error)")
            return nil
        }
    }

    override func reverseTransformedValue(_ value: Any?) -> Any? {
        // Converting Data to UIImage
        guard let data = value as? Data else { return nil }
        do {
            let uiImage = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIImage.self, from: data)
            return uiImage
        } catch {
            print("DEBUG: Failed to convert Data to UIImage: \(error)")
            return nil
        }
    }
}

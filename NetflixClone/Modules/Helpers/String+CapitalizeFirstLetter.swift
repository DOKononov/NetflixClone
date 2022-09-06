//
//  String+CapitalizedFirst.swift
//  NetflixClone
//
//  Created by Dmitry Kononov on 4.09.22.
//

import Foundation

extension String {
    
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.dropFirst().lowercased()
    }
}

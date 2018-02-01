//
//  BundleImage.swift
//  PickupRide
//
//  Created by Niko Mikulicic on 01/02/2018.
//  Copyright © 2018 Niko Mikulicic. All rights reserved.
//

import UIKit

enum BundleImage: String {
    
    case profile = "icProfile"
    
    static func image(for: RideActionType) -> BundleImage {
        return profile
    }
}

extension UIImage {
    
    convenience init(from bundleImage: BundleImage) {
        self.init(named: bundleImage.rawValue)!
    }
}

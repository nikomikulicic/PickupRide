//
//  ProfileOptionCell.swift
//  PickupRide
//
//  Created by Niko Mikulicic on 02/02/2018.
//  Copyright © 2018 Niko Mikulicic. All rights reserved.
//

import UIKit

class ProfileOptionCell: UITableViewCell {

    @IBOutlet private weak var optionImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    func setUp(for option: ProfileOption) {
        optionImageView.image = UIImage(from: option.image)
        titleLabel.text = option.title
    }
}

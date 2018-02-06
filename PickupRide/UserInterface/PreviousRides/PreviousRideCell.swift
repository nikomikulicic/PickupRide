//
//  PreviousRideCell.swift
//  PickupRide
//
//  Created by Niko Mikulicic on 06/02/2018.
//  Copyright © 2018 Niko Mikulicic. All rights reserved.
//

import UIKit

class PreviousRideCell: UITableViewCell {

    @IBOutlet private weak var addressFromLabel: UILabel!
    @IBOutlet private weak var addressToLabel: UILabel!
    @IBOutlet private weak var passengersLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!

    func setUp(for booking: Booking) {
        addressFromLabel.text = "\(booking.addressFrom)"
        addressToLabel.text = "\(booking.addressTo)"
        passengersLabel.text = String(booking.numberOfPassengers)
        dateLabel.text = DateFormatter.dateTimeFormatter.string(from: booking.date)
    }
}

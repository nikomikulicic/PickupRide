//
//  RideActionView.swift
//  PickupRide
//
//  Created by Niko Mikulicic on 01/02/2018.
//  Copyright © 2018 Niko Mikulicic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RideActionView: UIView {
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var label: UILabel!
    
    var tapped: Observable<Void> {
        return button.rx.tap.asObservable()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNib()
    }
    
    func setUp(for action: RideAction) {
        button.setImage(UIImage(from: action.image), for: .normal)
        label.text = action.title
    }
    
    private func loadNib() {
        let view = Bundle.main.loadNibNamed(String(describing: RideActionView.self), owner: self, options: nil)?[0] as! UIView
        addSubview(view)
        view.autoPinEdgesToSuperviewEdges()
    }
}

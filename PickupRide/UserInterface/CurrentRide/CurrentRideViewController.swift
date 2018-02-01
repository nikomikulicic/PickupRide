//
//  CurrentRideViewController.swift
//  PickupRide
//
//  Created by Niko Mikulicic on 01/02/2018.
//  Copyright © 2018 Niko Mikulicic. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class CurrentRideViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private var profileButton: UIBarButtonItem!
    
    let profileTapped = PublishSubject<Void>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        setUpAppearance()
        profileButton.rx.tap.bind(to: profileTapped).disposed(by: disposeBag)
    }
    
    func setUpAppearance() {
        view.backgroundColor = UIColor.gray

        profileButton = UIBarButtonItem()
        profileButton.image = UIImage(from: .profile)
        navigationItem.rightBarButtonItem = profileButton
    }
}

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
import PureLayout

class CurrentRideViewController: UIViewController {
    
    private var profileButton: UIBarButtonItem!
    @IBOutlet private weak var actionsView: UIStackView!
    
    private let disposeBag = DisposeBag()
    private var viewModel: CurrentRideViewModel!
    
    let profileTapped = PublishSubject<Void>()
    
    convenience init(viewModel: CurrentRideViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        setUpAppearance()
        
        profileButton.rx.tap.bind(to: profileTapped).disposed(by: disposeBag)
        connectToViewModel()
    }
    
    private func connectToViewModel() {
        viewModel.actions.asObservable().subscribe(onNext: { [weak self] actions in
            self?.updateActionsView(with: actions)
        }).disposed(by: disposeBag)
    }
    
    private func updateActionsView(with actions: [RideAction]) {
        actionsView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let actionButtons = actions.map { createButton(for: $0) }
        actionButtons.forEach { actionsView.addArrangedSubview($0) }
        
        subscribeToActions(actionButtons)
    }
    
    private func subscribeToActions(_ actionButtons: [UIButton]) {
        actionButtons.enumerated().forEach { (index, button) in
            button.rx.tap
                .map { index }
                .bind(onNext: viewModel.actionTapped)
                .disposed(by: disposeBag)
        }
    }
    
    private func createButton(for action: RideAction) -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(from: action.image), for: .normal)
        button.autoSetDimension(.height, toSize: 60)
        button.autoMatch(.width, to: .height, of: button)
        
        return button
    }
    
    private func setUpAppearance() {
        view.backgroundColor = UIColor.white
        title = "Current ride"

        profileButton = UIBarButtonItem()
        profileButton.image = UIImage(from: .profile)
        profileButton.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -10, right: 0)
        navigationItem.rightBarButtonItem = profileButton
        
        actionsView.alignment = .center
        actionsView.spacing = 32
    }
}

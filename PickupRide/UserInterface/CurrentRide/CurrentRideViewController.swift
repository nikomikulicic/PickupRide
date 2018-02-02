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
    
    private func updateActionsView(with actions: [RideActionData]) {
        actionsView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let actionViews = actions.map { createActionView(for: $0) }
        actionViews.forEach { actionsView.addArrangedSubview($0) }
        
        subscribeToActions(actionViews)
    }
    
    private func subscribeToActions(_ actionViews: [RideActionView]) {
        actionViews.enumerated().forEach { (index, view) in
            view.tapped
                .map { index }
                .bind(onNext: viewModel.actionTapped)
                .disposed(by: disposeBag)
        }
    }
    
    private func createActionView(for action: RideActionData) -> RideActionView {
        let view = RideActionView()
        view.setUp(for: action)
        view.autoSetDimensions(to: CGSize(width: 100, height: 100))
        return view
    }
    
    private func setUpAppearance() {
        view.backgroundColor = UIColor.prBackgroundGray
        title = "Current ride"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        profileButton = UIBarButtonItem()
        profileButton.image = UIImage(from: .profile)
        profileButton.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -10, right: 0)
        navigationItem.rightBarButtonItem = profileButton
        
        actionsView.alignment = .center
        actionsView.spacing = 32
    }
}

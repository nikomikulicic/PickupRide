//
//  RideTests.swift
//  PickupRideTests
//
//  Created by Niko Mikulicic on 05/02/2018.
//  Copyright © 2018 Niko Mikulicic. All rights reserved.
//

import Foundation
import XCTest
import RxSwift
@testable import PickupRide

class RideTests: XCTestCase {
    
    private var disposeBag: DisposeBag!
    
    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
    }
    
    func testStateMachine() {
        assertAvailableActions(inState: .idle, after: .startRide, areEqualTo: [.passengerPickedUp])
        assertAvailableActions(inState: .drivingToPickupLocation, after: .passengerPickedUp, areEqualTo: [.stopOver, .endRide])
        assertAvailableActions(inState: .drivingPassengers, after: .stopOver, areEqualTo: [.continueRide])
        assertAvailableActions(inState: .stopped, after: .continueRide, areEqualTo: [.stopOver, .endRide])
    }
    
    private func assertAvailableActions(inState state: RideState, after action: RideActionType, areEqualTo expectedActions: [RideActionType]) {
        let expectation = self.expectation(description: "Correct available actions")
        let ride = Ride(initialState: state)
        
        ride.state.asObservable().skip(1).subscribe(onNext: { state in
            XCTAssertEqual(state.actions, expectedActions)
            expectation.fulfill()
        }).disposed(by: disposeBag)
        
        ride.moveToNextState(afterAction: action)
        wait(for: [expectation], timeout: 0.1)
    }
}

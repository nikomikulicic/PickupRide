//
//  RideDetailsViewController.swift
//  PickupRide
//
//  Created by Niko Mikulicic on 06/02/2018.
//  Copyright © 2018 Niko Mikulicic. All rights reserved.
//

import UIKit
import MapKit

class RideDetailsViewController: UIViewController {

    @IBOutlet private weak var mapView: MKMapView!
    
    private var viewModel: RideDetailsViewModel!
    
    convenience init(viewModel: RideDetailsViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        setUpApparance()
        configureMap()
    }
    
    private func setUpApparance() {
        title = "Ride details"
        view.backgroundColor = UIColor.prBackgroundGray
    }
    
    private func configureMap() {
        mapView.delegate = self
        addAnnotations()
        configureRegion()
        addRouteRenderer()
    }
    
    private func addAnnotations() {
        let annotations = viewModel.actionData.map { data -> MKAnnotation in
            let annotation = MKPointAnnotation()
            annotation.title = data.text
            annotation.coordinate = CLLocationCoordinate2D(latitude: data.location.latitude, longitude: data.location.longitude)
            return annotation
        }
        mapView.addAnnotations(annotations)
    }
    
    private func configureRegion() {
        let latitudes = viewModel.route.map { $0.latitude }
        let longitudes = viewModel.route.map { $0.longitude }
        guard
            let minLatitude = latitudes.min(),
            let maxLatitude = latitudes.max(),
            let minLongitude = longitudes.min(),
            let maxLongitude = longitudes.max()
            else {
                return
        }
        
        let zoom = 0.5
        let center = CLLocationCoordinate2D(latitude: (minLatitude + maxLatitude) / 2, longitude: (minLongitude + maxLongitude) / 2)
        let span = MKCoordinateSpan(latitudeDelta: 1.0/zoom * (maxLatitude - minLatitude), longitudeDelta: 1.0/zoom * (maxLongitude - minLongitude))
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    private func addRouteRenderer() {
        let polyline = MKPolyline(coordinates: viewModel.route, count: viewModel.route.count)
        mapView.add(polyline)
    }
}

extension RideDetailsViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard overlay is MKPolyline else { return MKOverlayRenderer() }
        
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        polylineRenderer.strokeColor = UIColor.red.withAlphaComponent(0.4)
        polylineRenderer.lineWidth = 3
        return polylineRenderer
    }
}

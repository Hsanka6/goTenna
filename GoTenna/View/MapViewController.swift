//
//  ViewController.swift
//  GoTenna
//
//  Created by Haasith Sanka on 7/23/19.
//  Copyright © 2019 Haasith Sanka. All rights reserved.
//

import UIKit
import Mapbox
import CoreLocation
import RealmSwift

class MapViewController: UIViewController, CLLocationManagerDelegate, MGLMapViewDelegate {
    @IBOutlet var mapView: MGLMapView!
    var pinData = [Pin]()
    var locationManager: CLLocationManager!
    var userLocation: CLLocationCoordinate2D!
    @IBOutlet var viewModel: MapViewViewModel!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        determineMyCurrentLocation()
    }
    @IBAction func zoomLevel(_ sender: Any) {
        let currentValue = Int(slider.value)
        mapView.zoomLevel = Double(exactly: currentValue) ?? 14
    }
    @IBOutlet var slider: UISlider!
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        return nil
    }
//    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
//        // Only show callouts for `Hello world!` annotation.
//        return annotation.responds(to: #selector(getter: MGLAnnotation.title)) && annotation.title! == "Hello world!"
//    }
    func mapView(_ mapView: MGLMapView, calloutViewFor annotation: MGLAnnotation) -> MGLCalloutView? {
        // Instantiate and return our custom callout view.
        return CustomCalloutView(representedObject: annotation)
    }
    func mapView(_ mapView: MGLMapView, tapOnCalloutFor annotation: MGLAnnotation) {
        // Optionally handle taps on the callout.
        print("Tapped the callout for: \(annotation)")
        // Hide the callout.
        mapView.deselectAnnotation(annotation, animated: true)
    }
    // Allow callout view to appear when an annotation is tapped.
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.isZoomEnabled = true
        getData()
        addMapMarkers()
    }
    func getData() {
        viewModel.fetchPins {
            DispatchQueue.main.async {
                self.addMapMarkers()
            }
        }
    }
    func addMapMarkers() {
        var points = [MGLPointAnnotation]()
        points = viewModel.getMapMarkers()
        for point in points {
            mapView.addAnnotation(point)
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLocation: CLLocation = locations.last else {
            return print("Can't find location")
        }
        self.userLocation = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        mapView.setCenter(CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude),zoomLevel: 14, animated: true)
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Error \(error)")
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "menu" {
            if let controller = segue.destination as? LocationTableViewController {
                controller.userLocation = self.userLocation
            }
        }
    }
}

class CustomCalloutView: UIView, MGLCalloutView {
    var representedObject: MGLAnnotation
    
    // Allow the callout to remain open during panning.
    let dismissesAutomatically: Bool = false
    let isAnchoredToAnnotation: Bool = true
    
    // https://github.com/mapbox/mapbox-gl-native/issues/9228
    override var center: CGPoint {
        set {
            var newCenter = newValue
            newCenter.y -= bounds.midY
            super.center = newCenter
        }
        get {
            return super.center
        }
    }
    lazy var leftAccessoryView = UIView() /* unused */
    lazy var rightAccessoryView = UIView() /* unused */
    weak var delegate: MGLCalloutViewDelegate?
    let tipHeight: CGFloat = 10.0
    let tipWidth: CGFloat = 20.0
    let mainBody: UIButton
    required init(representedObject: MGLAnnotation) {
        self.representedObject = representedObject
        self.mainBody = UIButton(type: .system)
        super.init(frame: .zero)
        backgroundColor = .clear
        mainBody.backgroundColor = .darkGray
        mainBody.tintColor = .white
        mainBody.contentEdgeInsets = UIEdgeInsets(top: 10.0, left: 0.0, bottom: 15.0, right: 0.0)
        mainBody.layer.cornerRadius = 4.0
        let subtitleView = CustomLabel(frame: CGRect(x: 0, y: 0.0, width: 150, height: 100))
        subtitleView.font = subtitleView.font.withSize(12)
        subtitleView.backgroundColor = UIColor.gray
        subtitleView.textColor = UIColor.white
        subtitleView.numberOfLines = 4
        subtitleView.text = representedObject.subtitle ?? ""
        addSubview(mainBody)
        //addSubview(subtitleView)
        rightAccessoryView.addSubview(subtitleView)
        mainBody.addSubview(rightAccessoryView)
    }
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - MGLCalloutView API
    func presentCallout(from rect: CGRect, in view: UIView, constrainedTo constrainedRect: CGRect, animated: Bool) {
        delegate?.calloutViewWillAppear?(self)
        view.addSubview(self)
        // Prepare title label.
        mainBody.setTitle(representedObject.title!, for: .normal)
        mainBody.sizeToFit()
        if isCalloutTappable() {
            // Handle taps and eventually try to send them to the delegate (usually the map view).
            mainBody.addTarget(self, action: #selector(CustomCalloutView.calloutTapped), for: .touchUpInside)
        } else {
            // Disable tapping and highlighting.
            mainBody.isUserInteractionEnabled = false
        }
        // Prepare our frame, adding extra space at the bottom for the tip.
        let frameWidth = mainBody.bounds.size.width
        let frameHeight = mainBody.bounds.size.height + tipHeight
        let frameOriginX = rect.origin.x + (rect.size.width/2.0) - (frameWidth/2.0)
        let frameOriginY = rect.origin.y - (frameHeight)
        frame = CGRect(x: frameOriginX , y: frameOriginY, width: frameOriginX , height: frameOriginY )
        if animated {
            alpha = 0
            UIView.animate(withDuration: 0.2) { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.alpha = 1
                strongSelf.delegate?.calloutViewDidAppear?(strongSelf)
            }
        } else {
            delegate?.calloutViewDidAppear?(self)
        }
    }
    func dismissCallout(animated: Bool) {
        if superview != nil {
            if animated {
                UIView.animate(withDuration: 0.2, animations: { [weak self] in
                    self?.alpha = 0
                    }, completion: { [weak self] _ in
                        self?.removeFromSuperview()
                })
            } else {
                removeFromSuperview()
            }
        }
    }
    func isCalloutTappable() -> Bool {
        if let delegate = delegate {
            if delegate.responds(to: #selector(MGLCalloutViewDelegate.calloutViewShouldHighlight)) {
                return delegate.calloutViewShouldHighlight!(self)
            }
        }
        return false
    }
    @objc func calloutTapped() {
        if isCalloutTappable() && delegate!.responds(to: #selector(MGLCalloutViewDelegate.calloutViewTapped)) {
            delegate!.calloutViewTapped!(self)
        }
    }
    override func draw(_ rect: CGRect) {
        // Draw the pointed tip at the bottom.
//        let fillColor: UIColor = .darkGray
//        let tipLeft = rect.origin.x + (rect.size.width / 2.0) - (tipWidth / 2.0)
//        let tipBottom = CGPoint(x: rect.origin.x + (rect.size.width / 2.0), y: rect.origin.y + rect.size.height)
//        let heightWithoutTip = rect.size.height - tipHeight - 1
//        let currentContext = UIGraphicsGetCurrentContext()!
//        let tipPath = CGMutablePath()
//        tipPath.move(to: CGPoint(x: tipLeft, y: heightWithoutTip))
//        tipPath.addLine(to: CGPoint(x: tipBottom.x, y: tipBottom.y))
//        tipPath.addLine(to: CGPoint(x: tipLeft + tipWidth, y: heightWithoutTip))
//        tipPath.closeSubpath()
//        fillColor.setFill()
//        currentContext.addPath(tipPath)
//        currentContext.fillPath()
    }
}

class CustomLabel: UILabel {
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: UIEdgeInsets.init(top: 15, left: 10, bottom: 10, right: 10)))
    }
}

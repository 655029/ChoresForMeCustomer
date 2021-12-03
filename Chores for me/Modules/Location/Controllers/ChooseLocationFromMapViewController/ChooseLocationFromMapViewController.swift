//
//  ChooseLocationFromMapViewController.swift
//  Chores for me
//
//  Created by Bright Roots 2019 on 15/04/21.
//

import UIKit
import SnapKit
import GoogleMaps
import SwiftyJSON

protocol LocationDelegate: class
{
    func childViewControllerResponse(location: String)
}

class ChooseLocationFromMapViewController: BaseViewController, GMSMapViewDelegate {


    // MARK: - Outlets


    // MARK: - Properties
    var transparentview =  UIView()
    let location: String? = ""
    var selectedLatitude:Double?
    var selectedLongitude:Double?
    private var searchController: UISearchController!
    public var longitude = Double()
    public var latitude = Double()
    var address: String?
    static var delegate: LocationDelegate?
    var geoCoder :CLGeocoder!

    lazy var mapButton : UIButton = {
        let  mapButton = UIButton()
        mapButton.translatesAutoresizingMaskIntoConstraints = false
        
        mapButton.setImage(UIImage(named: "NEXT BUTTON TO MAP SCREEN"), for: .normal)
        return mapButton
    }()

    lazy var markerImage : UIImageView = {
           let imge =  UIImageView()
           imge.image = #imageLiteral(resourceName: "job location")
           imge.translatesAutoresizingMaskIntoConstraints = false
           return imge
       }()


    var mapView: GMSMapView!
    let zoom: Float = 12
    let marker = GMSMarker()
    let locationManager = CLLocationManager()


    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addSearchBar()
        addMapView()
        addButton()
        addMarkerImage()
        mapButton.addTarget(self, action: #selector(btnClicked(sender:)), for: .touchUpInside)
        geoCoder = CLGeocoder()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        self.navigationController?.navigationBar.tintColor = .black
//        let camera = GMSCameraPosition.camera(withLatitude:self.latitude, longitude: self.longitude, zoom: 12)
//      //  self.mapView.bringSubviewToFront(pinImage)
//    //    mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true

        NotificationCenter.default.addObserver(self, selector: #selector(locationText(_:)), name: .locationName, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        mapView.animate(to: GMSCameraPosition(latitude: UserStoreSingleton.shared.currentLat ?? 0, longitude: UserStoreSingleton.shared.currentLong ?? 0, zoom: 15))
        CheckTimeFunc()

    }

    override func viewDidLayoutSubviews() {
          mapView?.snp.makeConstraints { (make) in
              make.edges.equalToSuperview()
          }
          mapView.delegate = self
          //  mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 50)
      }

    @objc func locationText(_ notification: Notification) {

    }

    @objc func btnClicked(sender:UIButton){
        if address != nil && address != "" {
            ChooseLocationFromMapViewController.delegate?.childViewControllerResponse(location: address!)
            UserStoreSingleton.shared.Address = address
            navigationController?.popViewController(animated: true)
        }

    }

    func addButton(){
        mapView.addSubview(mapButton)
        mapButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        mapButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        let centerXConstraint = NSLayoutConstraint(item: mapButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 154)
        let centerYConstraint = NSLayoutConstraint(item: mapButton, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: -200)
        NSLayoutConstraint.activate([centerXConstraint, centerYConstraint])
    }


    // MARK: - Layout
    private func addSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search location"
        if #available(iOS 13.0, *) {
            searchController.searchBar.searchTextField.font = AppFont.font(style: .regular, size: 15)
            searchController.searchBar.searchTextField.textColor = UIColor.white
            searchController.searchBar.searchTextField.backgroundColor = .white
        }
        searchController.searchBar.isUserInteractionEnabled = false
        searchController.searchBar.showsCancelButton = false
        searchController.searchBar.backgroundColor = .clear
        searchController.searchBar.setNewcolor(color: .white)


        if #available(iOS 13.0, *) {
            searchController.searchBar.searchTextField.clearButtonMode = .never
        } else {
            UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes
                .updateValue(UIColor.white, forKey: NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue))
//             Fallback on earlier versions
            if let searchField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
                searchField.clearButtonMode = .never
                searchField.backgroundColor = .white
                searchField.textColor = .white
            }
        }
        searchController.searchBar.searchFieldBackgroundPositionAdjustment = UIOffset(horizontal: 13, vertical: -42)
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.delegate = self
        self.searchController = searchController


    }


    // MARK: - Additional Helpers
    private func addMapView() {
            mapView = GMSMapView()
            view.backgroundColor = UIColor.white
            view.addSubview(mapView)
            mapView.delegate = self
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
        }

        func addMarkerImage(){
            view.addSubview(markerImage)
            let centerXConstraint = NSLayoutConstraint(item: markerImage, attribute: .centerX, relatedBy: .equal, toItem: mapView, attribute: .centerX, multiplier: 1.0, constant: 0.0)
            let centerYConstraint = NSLayoutConstraint(item: markerImage, attribute: .centerY, relatedBy: .equal, toItem: mapView, attribute: .centerY, multiplier: 1.0, constant: 32)
            NSLayoutConstraint.activate([centerXConstraint, centerYConstraint])
    }

    // MARK: - User Interaction


}

// MARK: - UISearchResultsUpdating

extension ChooseLocationFromMapViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {

    }
}

public extension UISearchBar {
    func setNewcolor(color: UIColor) {
        let clrChange = subviews.flatMap { $0.subviews }
        guard let sc = (clrChange.filter { $0 is UITextField }).first as? UITextField else { return }
        sc.textColor = color
    }
}


// MARK: - UISearchResultsUpdating

extension ChooseLocationFromMapViewController: UISearchBarDelegate {


}
extension ChooseLocationFromMapViewController: CLLocationManagerDelegate {
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        let lat = position.target.latitude
        let lng = position.target.longitude

        UserStoreSingleton.shared.currentLat = lat
        UserStoreSingleton.shared.currentLong = lng

        var location = CLLocation(latitude: lat, longitude: lng)
        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let placemarks = placemarks {
                if (placemarks.first?.location) != nil{
                    //self.addressTextField.text = (placemarks.first?.name ?? "")+" "+(placemarks.first?.subLocality ?? " ")
                    if let addressDict = (placemarks.first?.addressDictionary as NSDictionary?){
                        let dict = JSON(addressDict)
                        // self. .text = dict["City"].stringValue
                        print("\(dict["City"].stringValue)")
                        var address:String = ""
                        for data in dict["FormattedAddressLines"].arrayValue{
                            address = address+" "+data.stringValue
                            self.searchController.searchBar.text = "\(address)"
                            ChooseLocationFromMapViewController.delegate?.childViewControllerResponse(location: address)
                            self.address = address
                            

                        }
                    }
                }
            }

        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }
        locationManager.startUpdatingLocation()
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        let mapView = GMSMapView()
         mapView.isMyLocationEnabled = true
         mapView.settings.myLocationButton = true


    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
//        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        self.mapView.isMyLocationEnabled = true
        mapView.animate(to: GMSCameraPosition(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 15))
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 15);
        self.mapView.camera = camera
        let marker: GMSMarker = GMSMarker()
        let myCurrentLocation = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        marker.appearAnimation = .pop
        DispatchQueue.main.async { [self] in
            marker.map = mapView
            mapView.animate(to: GMSCameraPosition(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 15))
        }
        mapView.camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 15)
        locationManager.stopUpdatingLocation()
    }

}

extension Notification.Name {
    static let locationName = Notification.Name("Location")

}

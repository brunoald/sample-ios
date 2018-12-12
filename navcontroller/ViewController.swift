//
//  ViewController.swift
//  navcontroller
//
//  Created by Bruno Dias on 11/12/18.
//  Copyright © 2018 com.brunoald. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

class ViewController: UIViewController, CLLocationManagerDelegate, CityViewDelegate {
    
    func onTemperatureFound() {
        cityNameLabel.text = nil
    }
    
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var cityNameLabel: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        startReceivingLocationChanges()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func updateCityName(_ lat: Double, _ lng: Double) {
        let endpoint = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lng)&units=metric&appid=21935d3a6682a59b28ccbdb398591285"
        
        Alamofire.request(endpoint).responseJSON { response in
            if let result = response.result.value as? [String: Any] {
                let name = result["name"] as! String
                self.cityNameLabel.text = name
            }
        }
    }
    
    func startReceivingLocationChanges() {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if authorizationStatus != .authorizedWhenInUse && authorizationStatus != .authorizedAlways {
            // User has not authorized access to location information.
            locationManager.requestAlwaysAuthorization()
            return
        }
        
        // Do not start services that aren't available.
        if !CLLocationManager.locationServicesEnabled() {
            // Location services is not available.
            return
        }
        
        // Configure and start the service.
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.distanceFilter = 100.0  // In meters.
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lastLocation = locations.last!
        let latitude = lastLocation.coordinate.latitude
        let longitude = lastLocation.coordinate.longitude
        locationManager.stopUpdatingLocation()
        updateCityName(latitude, longitude)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "citySegue" {
            let name = cityNameLabel.text
            let cityController = segue.destination as! CityViewController
            cityController.cityName = name
            cityController.delegate = self
        }
    }

    @IBAction func confirmButtonClick(_ sender: Any) {
        if let cityName = cityNameLabel.text {
            print(cityName)
        }
    }
    
}


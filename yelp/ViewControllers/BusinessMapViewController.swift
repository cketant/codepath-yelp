//
//  YelpBusinessesMapViewController.swift
//  yelp
//
//  Created by christopher ketant on 10/24/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit
import MapKit

class BusinessMapViewController: UIViewController {
    @IBOutlet weak var map: MKMapView!
    private let initialLocation = CLLocation(latitude: 37.785771, longitude: -122.406165)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(initialLocation.coordinate, 100.0, 100.0)
        self.map.setRegion(coordinateRegion, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

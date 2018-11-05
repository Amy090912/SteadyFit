//
//  HomeViewController.swift
//  SteadyFit
//
//  Created by Raheem Mian on 2018-10-23.
//  Copyright © 2018 Daycar. All rights reserved.
//
//  Team Daycar
//  Edited by: Raheem Mian, Akshay Kumar, Dickson Chum
//  List of Changes: added labels, table and arrays for table, created segues for table view, implemented to obtain GPS coordinate from device and bring up iPhone Messages with default message.
//
//  HomeViewController.swift is connected to the first Home Screen of the UI, which shows the User's profile, activity tracker, events and emergency button.
//  The emergency button is implemented to obtain iPhone's GPS location and bring up iPhone's messaging app with a default message.
//

import UIKit
import Foundation
import MessageUI
import MapKit
import CoreLocation

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMessageComposeViewControllerDelegate, CLLocationManagerDelegate{
    var locationManager = CLLocationManager()
    let homeTableSections = ["Activity Tracker", "Events"]
    let homeTableContents = [ ["Histogram"] , ["Event A", "Event B", "Event C"]]
    @IBAction func EmergencyButton(_ sender: Any) {sendText()}
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.tableFooterView = UIView(frame: .zero)
        myTableView.delegate = self
        myTableView.dataSource = self
        profilePicture.layer.cornerRadius = profilePicture.frame.size.width / 2
        profilePicture.clipsToBounds = true
            locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    /*-----------------------------------Location-------------------------------------------------------------*/
    /*-----------------------------------Table----------------------------------------------------------------*/
    func numberOfSections(in tableView: UITableView) -> Int {
        return homeTableSections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return homeTableSections[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeTableContents[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "homeTableCell", for:  indexPath)
        cell.textLabel?.text = homeTableContents[indexPath.section][indexPath.row]
        return cell
    }
    
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: homeTableSections[indexPath.section], sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var indexPath = self.myTableView.indexPathForSelectedRow!
        if(indexPath.section == 0){
            let destination = segue.destination as! HistogramViewController
            destination.navigationItem.title = homeTableContents[indexPath.section][indexPath.row]
        }
        else{
            let destination = segue.destination as! UserEventsViewController
            destination.navigationItem.title = homeTableContents[indexPath.section][indexPath.row]
        }
    }
    /*-----------------------------------Messaging----------------------------------------------------------------*/
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last!
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
    }
    func sendText() {
        let composeVC = MFMessageComposeViewController()
        if(CLLocationManager.locationServicesEnabled()){
            locationManager.startUpdatingLocation()
           // let locValue:CLLocationCoordinate2D = locationManager.location!.coordinate
             composeVC.body = "I need help! This is my current location: " + "http://maps.google.com/maps?q=\(latitude),\(longitude)&ll=\(latitude),\(longitude)&z=17"
        }
        else{
            composeVC.body = "I need help!"
        }
        composeVC.messageComposeDelegate = self
        composeVC.recipients = ["7788823644"]
        if MFMessageComposeViewController.canSendText() {
            self.present(composeVC, animated: true, completion: nil)
        } else {
            print("Can't send messages.")
        }
    }
     /*-----------------------------------END Messaging----------------------------------------------------------------------*/

}

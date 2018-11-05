//
//  SettingsViewController.swift
//  SteadyFit
//
//  Created by Raheem Mian on 2018-11-03.
//  Copyright © 2018 Daycar. All rights reserved.
//SettingsViewController allows for editting personal information, notification settings, emergency button settings, and help settings.
//  The emergency button is implemented to obtain iPhone's GPS location and bring up iPhone's messaging app with a default message.

import UIKit
import MessageUI
import CoreLocation

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, MFMessageComposeViewControllerDelegate {

    var titleNameArr = ["John Doe", "Notification", "Emergency Button", "Help"]
    var detailArr = ["Edit profile, change password, or log out", "Toggle notfications for vents and groups", "Adjust the message sent to emergency contact", "How-to guides and support"]
    var imageNames = ["Profile", "Notification", "Ambulance", "Help"]
    var locationManager = CLLocationManager()
    @IBAction func EmergencyButton(_ sender: Any) {sendText()}
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleNameArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SettingsTableViewCell
        tableCell.detailInfo.text = detailArr[indexPath.row]
        tableCell.titleName.text = titleNameArr[indexPath.row]
        tableCell.imageIcon.image = UIImage(named: imageNames[indexPath.row])
        return tableCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
             performSegue(withIdentifier: "Exit" , sender: titleNameArr[indexPath.row])
        }
        else{
             performSegue(withIdentifier: "settingNavigation" , sender: titleNameArr[indexPath.row])
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func sendText() {
        let composeVC = MFMessageComposeViewController()
        if(CLLocationManager.locationServicesEnabled()){
            locationManager.startUpdatingLocation()
            let locValue:CLLocationCoordinate2D = locationManager.location!.coordinate
            composeVC.body = "I need help! This is my current location: " + "http://maps.google.com/maps?q=\(locValue.latitude),\(locValue.longitude)&ll=\(locValue.latitude),\(locValue.longitude)&z=17"
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
}

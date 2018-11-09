//
//  GroupProfileViewController.swift
//  SteadyFit
//
//  Created by Dickson Chum on 2018-10-28.
//  Copyright © 2018 Daycar. All rights reserved.
//
//  Team Daycar
//  Edited by: Dickson Chum
//  List of Changes: added labels, table and arrays for table, created segues for table view, added emergency button and GPS related code
//
//  GroupProfileViewController.swift is linked to Group Profile of the UI, which shows group information.
//  The emergency button is implemented to obtain iPhone's GPS location and bring up iPhone's messaging app with a default message.
//

import UIKit
import MessageUI
import CoreLocation
import Firebase
import FirebaseDatabase
import FirebaseAuth

class GroupProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMessageComposeViewControllerDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var groupDesc: UILabel!
    @IBOutlet weak var groupDescInfo: UILabel!
    @IBOutlet weak var activityLevel: UILabel!
    @IBOutlet weak var activityLevelInfo: UILabel!
    @IBOutlet weak var groupStatus: UILabel!
    @IBOutlet weak var groupStatusInfo: UILabel!
    @IBOutlet weak var eventTableView: UITableView!
    
    @IBAction func emergencyButton(_ sender: UIButton) {sendText()}
    var ref:DatabaseReference? = Database.database().reference()
    var refHandle:DatabaseHandle?
    var getDescriptionHandle:DatabaseHandle?
    var getEventsHandle:DatabaseHandle?
    var locationManager = CLLocationManager()
    var groupText : String!
    var groupTableSections = ["Members", "Events"]
    var groupTableContents = [["More"], ["A Event on Jan 1, 2018", "B Event on Feb 1, 2018", "C Event on Mar 1, 2018"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventTableView.delegate = self
        eventTableView.dataSource = self
        
        var groupID : Int
        
        let currentuserID = Auth.auth().currentUser?.uid
        refHandle = self.ref?.child("Users").child(currentuserID!).child("Groups").observe(DataEventType.value, with: { (snapshot) in
        
            var groupNamesArr = [String]()
            for groupNames in snapshot.children.allObjects as! [DataSnapshot] {
                //groupNamesArr = groupNames.components(separatedBy: "\"")
                //if (groupNamesArr[1] == self.groupText){
                    // set groupID to the groupID of thise group
                //}
            }
        })
        
        let groupTextArr = groupText.components(separatedBy: " ")
        
        groupDesc.text = "Group Description:"
        groupDescInfo.text = groupText
        activityLevel.text = "Activity Level:"
        if (groupTextArr.count == 4) {
            activityLevelInfo.text = groupTextArr[3]
        } else {
            activityLevelInfo.text = groupTextArr[3] + " " + groupTextArr[4]
        }
        groupStatus.text = "Group Status:"
        groupStatusInfo.text = groupTextArr[0]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return groupTableSections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return groupTableSections[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupTableContents[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = eventTableView.dequeueReusableCell(withIdentifier: "memberCell", for: indexPath)
        cell.textLabel?.text = groupTableContents[indexPath.section][indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: groupTableSections[indexPath.section], sender: self)
        eventTableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var indexPath = self.eventTableView.indexPathForSelectedRow!
        if(indexPath.section == 0){
            let post = segue.destination as! GroupMemberListTableViewController
            post.navigationItem.title = groupTableContents[indexPath.section][indexPath.row]
        }
        else{
            let post = segue.destination as! UserEventsViewController
            post.navigationItem.title = groupTableContents[indexPath.section][indexPath.row]
        }
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

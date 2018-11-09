//
//  GroupsViewController.swift
//  SteadyFit
//
//  Created by Raheem Mian on 2018-10-23.
//  Copyright © 2018 Daycar. All rights reserved.
//
//  Team Daycar
//
//  Edited by: Dickson Chum, Alexa Chen
//  List of Changes: added segmented control, table and arrays for table, created segues for table view, added database automatic population for user "My Group"
//
//  List of Bugs:
//  When group node changes in database, the view append groups, hence create duplicate groups.
//
//  GroupsViewController.swift is connected to Groups section of the UI, which shows user joined groups and recommmented groups by toggling on segmented control
//  The emergency button is implemented to obtain iPhone's GPS location and bring up iPhone's messaging app with a default message.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import CoreLocation
import MessageUI

class GroupsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMessageComposeViewControllerDelegate, CLLocationManagerDelegate {
    var myGroups = [String]()
    var suggestedGroups = ["Group X", "Group Y", "Group Z"]
    var p: Int!
    
    var queryMyGroups = [UserGroup]()
    var ref:DatabaseReference?
    var refHandle:DatabaseHandle?
    var groupsRef:DatabaseReference?
    var groupsHandle:DatabaseHandle?
    var currentUserCity: String?
    var currentUserActivityLevel: String?

    @IBOutlet weak var groupTableView: UITableView!
    @IBAction func groupSegmentedControl(_ sender: UISegmentedControl) {
        p = sender.selectedSegmentIndex
        groupTableView.reloadData()
    }
    var locationManager = CLLocationManager()
    @IBAction func emergencyButton(_ sender: Any) {
        sendText()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        groupTableView.tableFooterView = UIView(frame: .zero)
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        //  Database initialization
        ref = Database.database().reference()
        
        //  Firebase fetch start
        //  Get current authenticated user
        let currentuserID = Auth.auth().currentUser?.uid
        refHandle = ref?.child("Users").child(currentuserID!).observe(DataEventType.value, with: {
            (snapshot) in
            // Clear group lists
            self.myGroups.removeAll()
            self.queryMyGroups.removeAll()
            self.suggestedGroups.removeAll()
            
            // get user groups
            for rest in snapshot.childSnapshot(forPath: "Groups").children.allObjects as! [DataSnapshot]{
                guard let dictionary = rest.value as? [String: AnyObject] else {continue}
                let myGroup = UserGroup()
                myGroup.name = dictionary["name"] as?String
                myGroup.chatid = dictionary["chatid"] as?String
                myGroup.GroupType = dictionary["GroupType"] as?String
                self.queryMyGroups.append(myGroup)
                if myGroup.name != nil {
                    let sampleGroup: String = myGroup.name!
                    self.myGroups.append(sampleGroup)
                }
            }
            // Get user city and activity level for recommending algorithm
            if let dictionary2 = snapshot.value as? [String: AnyObject]{
                let myCity = dictionary2["city"] as?String
                let myActivityLevel = dictionary2["activitylevel"] as?String
                if myCity != nil{
                    self.currentUserCity = myCity
                }
                if myActivityLevel != nil{
                    self.currentUserActivityLevel = myActivityLevel
                }
            }
            
            //  Recommend user with groups from the same location,
            //  TO DO: algorithm to be improved!!!
            self.groupsHandle = self.ref?.child("Groups").queryOrdered(byChild: "location").queryEqual(toValue:self.currentUserCity!).observe(DataEventType.value, with: {
                (groupsnapshot) in
                self.suggestedGroups.removeAll()
                //check if any of the groups are in user's groups, if yes append
                for rest in groupsnapshot.children.allObjects as! [DataSnapshot] {
                    guard let Groupdictionary = rest.value as? [String: AnyObject] else {continue}
                    // if user requested to join group, but not yet accepted
                    if rest.childSnapshot(forPath: "users").hasChild(currentuserID!){
                        guard let checkUserdictionary = rest.childSnapshot(forPath: "users").childSnapshot(forPath: currentuserID!).value as? [String:AnyObject] else {continue}
                        
                        let myUserJoined = checkUserdictionary["joined"] as?Int
                        if myUserJoined != nil &&  myUserJoined == 0
                        {
                            let myRecommendedGroup = Groupdictionary["name"] as?String
                            if myRecommendedGroup != nil{
                                self.suggestedGroups.append(myRecommendedGroup!)
                            }
                        }
                    }
                    // if user is not in the group and never requested to join group
                    else{
                        let myRecommendedGroup = Groupdictionary["name"] as?String
                        if myRecommendedGroup != nil{
                            self.suggestedGroups.append(myRecommendedGroup!)
                        }
                    }
                }
            })
            DispatchQueue.main.async{
                self.groupTableView.reloadData()
            }
        })
        // End of Database initialization
        p = 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var returnValue = 0
        switch (p) {
        case 0:
            returnValue = myGroups.count
            break
        case 1:
            returnValue = suggestedGroups.count
            break
        default:
            break
        }
        return returnValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = groupTableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath)
        switch (p) {
        case 0:
            cell.textLabel?.text = myGroups[indexPath.row]
            break
        case 1:
            cell.textLabel?.text = suggestedGroups[indexPath.row]
            break
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showGroupDetail", sender: self)
        groupTableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var indexPath = self.groupTableView.indexPathForSelectedRow!
        switch (p) {
        case 0:
            let destination = segue.destination as! GroupProfileViewController
            destination.navigationItem.title = myGroups[indexPath.row]
            destination.groupText = myGroups[indexPath.row]
            break
        case 1:
            let destination = segue.destination as! GroupProfileViewController
            destination.navigationItem.title = suggestedGroups[indexPath.row]
            destination.groupText = suggestedGroups[indexPath.row]
            break
        default:
            break
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

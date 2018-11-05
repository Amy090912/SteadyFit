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
//  GroupsViewController.swift is connected to Groups section of the UI, which shows user joined groups and recommmented groups by toggling on segmented control
//  The emergency button is implemented to obtain iPhone's GPS location and bring up iPhone's messaging app with a default message.
//


//    func groupInit(text: String){
//        self.groupName.text = text
//        self.groupName.textColor = UIColor.black
//        self.contentView.backgroundColor = UIColor.lightGray
//    }



import UIKit
import FirebaseDatabase
import FirebaseAuth
import CoreLocation
import MessageUI

class GroupsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMessageComposeViewControllerDelegate, CLLocationManagerDelegate {
    var myGroups = [String]()
    var suggestedGroups = ["Group X", "Group Y", "Group Z"]
    var p: Int!
    
    var queryMyGroups = [userGroup]()
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
    @IBAction func emergencyButton(_ sender: Any) {sendText()}
    override func viewDidLoad() {
        super.viewDidLoad()
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
            // clear group lists
            self.myGroups.removeAll()
            self.queryMyGroups.removeAll()
            self.suggestedGroups.removeAll()
            
            // get user groups
            for rest in snapshot.childSnapshot(forPath: "Groups").children.allObjects as! [DataSnapshot]{
                guard let dictionary = rest.value as? [String: AnyObject] else {continue}
                let myGroup = userGroup()
                myGroup.name = dictionary["name"] as?String
                myGroup.chatid = dictionary["name"] as?String
                myGroup.GroupType = dictionary["GroupType"] as?String
                self.queryMyGroups.append(myGroup)
                if myGroup.name != nil {
                    let sampleGroup: String = myGroup.name!
                    self.myGroups.append(sampleGroup)
                }
            }
            // get user city and activity level for recommending algorithm
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
            
            // recommend user with groups from the same location, TO DO: algorithm to be improved!!!
            self.groupsHandle = self.ref?.child("Groups").queryOrdered(byChild: "location").queryEqual(toValue:self.currentUserCity!).observe(DataEventType.value, with: {
                (groupsnapshot) in
                print(groupsnapshot)
                for rest in groupsnapshot.children.allObjects as! [DataSnapshot] {
                    guard let checkUserdictionary = rest.childSnapshot(forPath: "users").childSnapshot(forPath: currentuserID!).value as? [String:AnyObject] else {continue}
                    guard let Groupdictionary = rest.value as? [String: AnyObject] else {continue}
                    print(checkUserdictionary)
                    let myUserJoined = checkUserdictionary["joined"] as?Int
                    //check if any of the groups are in user's groups, if yes append
                    if myUserJoined != nil && myUserJoined == 0
                    {
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
        
        
        /*
        let currentuserID = Auth.auth().currentUser?.uid
        refHandle = ref?.child("Users").child(currentuserID!).child("Groups").observe(DataEventType.value, with: {
            (snapshot) in
            self.myGroups.removeAll()
            self.queryMyGroups.removeAll()
            for rest in snapshot.children.allObjects as! [DataSnapshot]{
                guard let dictionary = rest.value as? [String: AnyObject] else {continue}
                let myGroup = userGroup()
                myGroup.name = dictionary["name"] as?String
                myGroup.chatid = dictionary["name"] as?String
                myGroup.GroupType = dictionary["GroupType"] as?String
                self.queryMyGroups.append(myGroup)
                if myGroup.name != nil {
                    let sampleGroup: String = myGroup.name!
                    self.myGroups.append(sampleGroup)
                }
                DispatchQueue.main.async{
                    self.groupTableView.reloadData()
                }
            }
        })
        //  End of Database initialization
         */
        
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
            break
        case 1:
            let destination = segue.destination as! GroupProfileViewController
            destination.navigationItem.title = suggestedGroups[indexPath.row]
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

//
//  SecondViewController.swift
//  SteadyFit
//
//  Created by Raheem Mian on 2018-10-23.
//  Copyright © 2018 Raheem Mian. All rights reserved.
//

//Groups
import UIKit
import FirebaseDatabase

class SecondViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var myGroups = [String]() //= ["Group A", "Group B", "Group C"]
    var suggestedGroups = ["Group X", "Group Y", "Group Z"]
    var p: Int!
    
    var queryMyGroups = [userGroup]()
    var ref:DatabaseReference?
    var refHandle:DatabaseHandle?

    @IBOutlet weak var groupTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        ref = Database.database().reference()
        
        // load data from firebase ======
        refHandle = ref?.child("Users/User1").child("Groups").observe(DataEventType.value, with: {
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
        // end of load data from firebase ======
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
            cell.textLabel!.text = myGroups[indexPath.row]
            break
        case 1:
            cell.textLabel!.text = suggestedGroups[indexPath.row]
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
            let destination = segue.destination as! GroupViewController
            destination.navigationItem.title = myGroups[indexPath.row]
            
//            if let destination = segue.destination as? GroupViewController{
//                destination.groupName = myGroups[(groupTableView.indexPathForSelectedRow?.row)!]
//            }
            break
        case 1:
            
            let destination = segue.destination as! GroupViewController
            destination.navigationItem.title = suggestedGroups[indexPath.row]
//            if let destination = segue.destination as? GroupViewController{
//                destination.groupName = suggestedGroups[(groupTableView.indexPathForSelectedRow?.row)!]
//            }
            break
        default:
            break
        }
        
    }
    
    
    
    
    
    @IBAction func groupSegmentedControl(_ sender: UISegmentedControl) {
        p = sender.selectedSegmentIndex
        groupTableView.reloadData()
    }
}




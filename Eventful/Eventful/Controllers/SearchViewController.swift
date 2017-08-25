//
//  SearchViewController.swift
//  Eventful
//
//  Created by Shawn Miller on 8/12/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class EventSearchController: UICollectionViewController, UISearchBarDelegate, UICollectionViewDelegateFlowLayout{
    
    //resue identifier for the cell that you are constructing
    let cellId = "cellID"
    var scopeIndex: Int = 0
    let cellID2 = "newCellID"
    let userProfileController = ProfileeViewController(collectionViewLayout: UICollectionViewFlowLayout())
    let currentEventDetailController = EventDetailViewController()
    
    //ui search bar that will allow you to type in text and filter out results
    //most of the code here is straight forward 
    //must set delegate to self to get control over certain aspects of search bar
//    lazy var searchBar: UISearchBar = {
//        let sb = UISearchBar()
//        sb.placeholder = "Enter Event"
//        sb.barTintColor = .gray
//        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
//        sb.delegate = self
//        return sb
//    }()
    

    
    //detects when search bar text is done editing
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("Stopped Editing")
        print(searchBar.text ?? "")
        guard let searchText = searchBar.text else{
            return
        }
        let lowerText = searchText.lowercased()
        
        if scopeIndex == 0 {
            fetchEvents(searchString: lowerText)
        }else if scopeIndex == 1{
            fetchUsers(stringValue: lowerText)
        }
       
       
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if searchBar.text?.isEmpty == true
        {
            filteredEvents.removeAll()
            self.collectionView?.reloadData()
        }
    }

    
    
    
//    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
       return CGSize(width: view.frame.width, height: 80)
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
       let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerID", for: indexPath) as! SearchHeader
        header.searchBar.delegate = self
        return header
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //Changes the first responder to the search bar
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        switch selectedScope {
        case 0:
            searchBar.text = ""
            self.scopeIndex = selectedScope
            self.filteredEvents.removeAll()
            self.collectionView?.reloadData()
            break
        case 1:
            searchBar.text = ""
            self.scopeIndex = selectedScope
            self.filteredUsers.removeAll()
            self.collectionView?.reloadData()
            break
        default:
            break
        }
    }
    
    // this function will detect change in the search bar and filter out the results returned based off what is entered in the search bar
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        
        //navigationController?.navigationBar.addSubview(searchBar)
        collectionView?.register(SearchHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerID")
        
        self.navigationController?.navigationBar.isHidden = true
       // searchBar.anchor(top: navBar?.topAnchor, left: navBar?.leftAnchor, bottom: navBar?.bottomAnchor, right: navBar?.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        //will register a cell to the screen
        //notice the EventSearchCell that is one of the parameters
        //that is there so it creates the cell in the way that I want it to based off the EventSearchCell Swift File
     self.collectionView?.register(EventSearchCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.alwaysBounceVertical = true
        collectionView?.keyboardDismissMode = .onDrag 
     self.collectionView?.register(UserSearchCell.self, forCellWithReuseIdentifier: cellID2)

    }
    //two arrays both of type Event
    //one for appending the results of the database search
    //one for grabbing the results of the search bar
    var filteredEvents = [Event]()
    var eventsArray = [Event]()
    fileprivate func fetchEvents(searchString: String){
        print("Fetching events....")
        //create a reference to the location in the database that you want to pull from and observe the value there
        let ref = Database.database().reference().child("events")
        // this will retur a snapshot with all the data at that location in the database and cast the results as a dictionary for later use
        let endString = searchString + "\\uf8ff"
        let query = ref.queryOrdered(byChild: "event:name").queryStarting(atValue: searchString).queryEnding(atValue: endString)
        print(query)
        query.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else{
                print(snapshot.value)
                return
            }
            print(snapshot.value)
            dictionary.forEach({ (key,value) in
                print(key,value)
                guard let eventDictionary = value as? [String: Any] else{
                    return
                }
                let events = Event(currentEventKey: key, dictionary:eventDictionary)
                
                let filteredEvents = self.eventsArray.filter { (event) -> Bool in
                    return event.currentEventKey == events.currentEventKey
                }
                
                if filteredEvents.count == 0 {
                    //append
                    self.eventsArray.append(events)
                }
                
                
                self.filteredEvents = self.eventsArray.filter { (event) -> Bool in
                    return event.currentEventName.lowercased().contains(searchString.lowercased())
                    
                }
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
                
                
            })
          

        }) { (err) in
            print("Failed to fetch event data", err)
        }
        }
    
    
    
    var filteredUsers = [User]()
    var usersArray = [User]()
    
    fileprivate func fetchUsers(stringValue: String){
        
        //create a reference to the location in the database that you want to pull from and observe the value there
        let ref = Database.database().reference().child("users")
        // this will retur a snapshot with all the data at that location in the database and cast the results as a dictionary for later use
        
        
        // Originally how it worked
        //ref.observe(.value, with: { (snapshot) in
        //print(snapshot)
        //let query = ref.queryOrdered(byChild: "posts/title").queryEqual(toValue:value)
        //        print(query)
        
        //        let startString = "Made"
        
        //        ref.queryOrdered(byChild: "title").queryEqual(toValue:stringValue)
        //            .queryLimited(toFirst: 10).observeSingleEvent(of: .value, with: { (snapshot : DataSnapshot) in
        
        let endString = stringValue + "\\uf8ff"
        ref.queryOrdered(byChild: "username").queryStarting(atValue: stringValue).queryEnding(atValue: endString).observeSingleEvent(of: .value, with: { (snapshot) in
            
            print(snapshot)
            
            
            guard let dictionaries = snapshot.value as? [String: Any] else{
                return print(snapshot.value ?? "nil")
            }
            
            print(dictionaries)
            //does the job of sorting dictionary elements by key and value
            //displaying the key and each corresponding value
            dictionaries.forEach({ (key,value) in
                // print(key, value)
                //creating an eventDictionary to store the results of previous call
                
                guard let userDictionary = value as? [String: Any] else{
                    return
                }
                
                //                userDictionaries.forEach({ (key, value) in
                //
                //                    guard let postDictionary = value as? [String: Any] else{
                //                        return
                //                    }
                
                //print(postDictionary)
                //will cast each of the values as an Event based off my included struct
                //Make sure to create a model it is the only way to have the data in the format you want for easy access
                
                print(key)
                let newUser = User(key: key, postDictionary: userDictionary)
                
                //guard let newUser != nil { return nil }
                
                //Filtering for duplicates in array
                let filteredArr = self.usersArray.filter { (user) -> Bool in
                    print(user.uid)
                    return user.uid == newUser?.uid
                }
                
                
                print(newUser?.uid ?? "nil")
                
                //If arrat equals 0 append newPost
                if filteredArr.count == 0 {
                    //append
                    self.usersArray.append(newUser!)
                }
                
                
                
                self.filteredUsers = self.usersArray.filter { (user) -> Bool in
                    return (user.username?.lowercased().contains(stringValue.lowercased()))!
                }
                
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
                
            })
            
            print(self.usersArray)
            // will sort the array elements based off the name
            
            
            print(self.usersArray)
            // will again reload the data
            
        }) { (err) in
            print("Failed to fetch posts for search")
        }
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //make sure that the screen is loaded with the proper number of cells when you first go to the screen
        switch scopeIndex {
        case 0:
            return filteredEvents.count
        case 1:
            return filteredUsers.count
        default:
            return 0
        }    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        searchBar.isHidden = true
//        searchBar.resignFirstResponder()
        switch scopeIndex {
        case 0:
            let event = filteredEvents[indexPath.item]
            print(event.currentEventKey)
            currentEventDetailController.eventImage = event.currentEventImage
            currentEventDetailController.eventName = event.currentEventName
            currentEventDetailController.eventDescription = event.currentEventDescription
            currentEventDetailController.eventStreet = event.currentEventStreetAddress
            currentEventDetailController.eventCity = event.currentEventCity
            currentEventDetailController.eventState = event.currentEventState
            currentEventDetailController.eventZip = event.currentEventZip
            currentEventDetailController.eventKey = event.currentEventKey
            currentEventDetailController.eventDate = event.currentEventDate!
            currentEventDetailController.eventTime = event.currentEventTime!
            self.filteredEvents.removeAll(keepingCapacity: true)
            self.eventsArray.removeAll(keepingCapacity: true)
            self.collectionView?.reloadData()
            navigationController?.pushViewController(currentEventDetailController, animated: true)
            navigationController?.navigationBar.isHidden = false
            break
        case 1:
            navigationController?.navigationBar.isHidden = false
            let user = filteredUsers[indexPath.item]
            print(user.username)
            userProfileController.userId = user.uid
            userProfileController.navigationItem.title = user.username
            userProfileController.navigationItem.hidesBackButton = true
            let backButton = UIBarButtonItem(image: UIImage(named: "icons8-Back-64"), style: .plain, target: self, action: #selector(GoBack))
            userProfileController.navigationItem.leftBarButtonItem = backButton
            navigationController?.pushViewController(userProfileController, animated: true)
            break
        default:
            break
        }
   
    }
    
    func GoBack(){
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // searchBar.text = ""
        self.collectionView?.reloadData()
        navigationController?.navigationBar.isHidden = true
        filteredEvents.removeAll()
      //  searchBar.isHidden = false
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //creates a cell and cast it as the Appropriate type
        let eventCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! EventSearchCell
        let userCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID2, for: indexPath) as! UserSearchCell

        switch scopeIndex {
        case 0:
            eventCell.event = filteredEvents[indexPath.row]
            return eventCell
        case 1:
            userCell.user = filteredUsers[indexPath.row]
            return userCell
        default:
            return eventCell
        }
        
    }
    
    //constrols size of the cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 66)
    }
    
}

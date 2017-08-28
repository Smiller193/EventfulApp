    //
//  ProfileeViewController.swift
//  Eventful
//
//  Created by Shawn Miller on 7/30/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import UIKit
import SwiftyJSON
import  AlamofireImage
import Alamofire
import AlamofireNetworkActivityIndicator
import Foundation
import Firebase
import FirebaseDatabase
import FirebaseStorage


class ProfileeViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var userEventHandle: DatabaseHandle = 0
    var userEventRef: DatabaseReference? = nil
    let cellID = "cellID"
    let profileSetupTransition = AlterProfileViewController()
    let settingView = SettingsViewController()
    var profileHandle: DatabaseHandle = 0
    var profileRef: DatabaseReference?
    var userEvents = [Event]()
    var userId: String?
    var user: User?
    
    var currentUserName: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = UIColor.white
        fetchUser()
        
collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerID")
        
        collectionView?.register(EventsAttendingCell.self, forCellWithReuseIdentifier: cellID)
//        fetchEvents()
        collectionView?.alwaysBounceVertical = true
    }
    

    
    fileprivate func fetchEvents(uid: String){
        print("123")
   
         userEventRef = Database.database().reference().child("users").child(uid).child("Attending")
        userEventRef?.observe(.childAdded, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else{
                return
            }
            
            dictionaries.forEach({ (key,value) in
                print(key)
                EventService.show(forEventKey: key, completion: { (event) in
                    let currentEvent = Event(currentEventKey: key, dictionary: (event?.eventDictionary)!)
                    self.userEvents.append(currentEvent)
                    self.collectionView?.reloadData()
                })
            })
            
        }) { (err) in
            print("Failed to fetch events that a user is attending", err)
        }
    

    }
    
    
    fileprivate func fetchUser(){
        let uid = userId ?? Auth.auth().currentUser?.uid ?? ""
        profileHandle = UserService.observeProfile(for: uid) { [unowned self] (ref, user) in
            self.profileRef = ref
            self.user = user
            if let user = user{
                //User.setCurrent(user, writeToUserDefaults: true)
                let url = user.profilePic
                let imageURL = URL(string: url!)
                if imageURL == nil{
                    //self.profileImage.image = UIImage(named: "no-profile-pic")
                }else{
                    DispatchQueue.main.async {
                        guard let profileImageUrl = user.profilePic else{
                            return
                        }
                        //  self.profileImage.af_setImage(withURL: imageURL!)
                    }
                }
                guard let username = user.username else{
                    return
                }
                
                self.navigationItem.title = username

                self.collectionView?.reloadData()
                self.fetchEvents(uid: uid)

                //self.userNameLabel.text = currentUserName
                let currentBio = user.bio
                if currentBio == ""{
                    //   self.userBio.text = "[Bio]"
                }else{
                    // self.userBio.text = currentBio
                    
                }
            }
        }
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerID", for: indexPath) as! UserProfileHeader
        header.profileeSettings.addTarget(self, action: #selector(profileSettingsTapped), for: .touchUpInside)
        header.settings.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
        header.user = self.user
        return header
    }
    
    func settingsButtonTapped(){
        self.navigationController?.pushViewController(settingView, animated: true)

    }
    
    func profileSettingsTapped(){
        self.navigationController?.pushViewController(profileSetupTransition, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
   
    
    deinit {
        userEventRef?.removeObserver(withHandle: userEventHandle)
        profileRef?.removeObserver(withHandle: profileHandle)
    }
   
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userEvents.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2)/3
       return CGSize(width: width, height: width)
        
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! EventsAttendingCell
        cell.layer.cornerRadius = 70/2
        cell.event = userEvents[indexPath.item]
        
        return cell
    }
    
    
    
    }
    
  

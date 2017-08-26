//
//  EventSearchHeader.swift
//  Eventful
//
//  Created by Shawn Miller on 8/23/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import Foundation
import UIKit

class SearchHeader: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        addSubview(searchBar)
        searchBar.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    

    lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Enter Event"
        sb.showsScopeBar = true
        sb.scopeButtonTitles = ["Events", "Users"]
        sb.barTintColor = UIColor.white
    
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        
      //  sb.delegate = self
        return sb
    }()
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


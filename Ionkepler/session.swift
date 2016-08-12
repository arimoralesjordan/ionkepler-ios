//
//  session.swift
//  Ionkepler
//
//  Created by Ari Morales on 5/16/16.
//  Copyright © 2016 Coreveillance. All rights reserved.
//

import UIKit

class iksession: NSObject {
	// MARK: Properties
	
	var user: String
	var password: String
	
	// MARK: Archiving Paths
	
	let defaults = NSUserDefaults.standardUserDefaults()
	
	// MARK: Types
	
	struct PropertyKey {
		static let userKey = "user"
		static let passwordKey = "password"
	}
	
	// MARK: Initialization
	
	init(us:String,psw:String) {
		// Initialize stored properties.
		self.user = us
		self.password = psw
	}
	
	// MARK: Save Session
	
	func SaveSession()  {
		defaults.setValue(user, forKey: PropertyKey.userKey)
		defaults.setValue(password, forKey: PropertyKey.passwordKey)
		
		defaults.synchronize()
	}
	
	// MARK: Get last session
	
	func GetSession() -> Bool {
		var ret=false
		if let suser = defaults.stringForKey(PropertyKey.userKey) {
			user=suser
		}
		if let spassword = defaults.stringForKey(PropertyKey.passwordKey) {
			password=spassword
		}
		if user.isEmpty || password.isEmpty {
			ret=true
		}
		return ret
	}
}
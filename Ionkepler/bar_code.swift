//
//  bar_code.swift
//  Ionkepler
//
//  Created by Ari Morales on 3/30/16.
//  Copyright © 2016 Coreveillance. All rights reserved.
//

import UIKit
class bar_codes{
    // MARK: Properties
    var serials = [Serials]()
    
    init?() {}
    func add_serial(serial_number: String, product: String) {
        if self.check_serial(serial_number, product: product) {
            serials += [Serials(number: serial_number, product: product)!]
        }
    }
    func check_serial(serial_number: String, product: String) -> Bool {
        var retorno = true
        for serial in self.serials {
            if serial.number==serial_number {
                retorno = false
            }
        }
        return retorno
    }
    class Serials {
        // MARK: Properties
        var number: String
        var product: String
        // MARK: Initialization
        init?(number: String, product: String) {
            // Initialize stored properties.
            self.number = number
            self.product = product
            // Initialization should fail if there is no name or if the rating is negative.
            if number.isEmpty {
                return nil
            }
        }
    }
}



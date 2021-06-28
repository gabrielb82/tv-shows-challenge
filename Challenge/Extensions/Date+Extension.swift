//
//  Date+Extension.swift
//  Challenge
//
//  Created by Gabriel Barbosa on 24/06/21.
//

import Foundation

extension Date {
    
    /**
        Retrieves the components of a given Date.
    */
    func getComponents() -> DateComponents {
        let calendar = Calendar.current
        return calendar.dateComponents([.day, .month, .year], from: self)
    }
    
    /**
        Retrieves the day of a given Date
    */
    func getDay() -> Int {
        return self.getComponents().day ?? 0
    }
    
    /**
        Retrieves the month of a given Date
    */
    func getMonth() -> Int {
        return self.getComponents().month ?? 0
    }
    
    /**
        Retrieves the year of a given Date
    */
    func getYear() -> Int {
        return self.getComponents().year ?? 0
    }
    
}

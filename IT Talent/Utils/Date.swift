//
//  Date.swift
//  IT Talent
//
//  Created by Mauricio García S on 30/01/23.
//

import Foundation

struct DateTime {
    
    let fmt = ISO8601DateFormatter()
    let months = ["Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio",
                  "Agosto","Septiembre","Octubre","Noviembre","Diciembre"]
    
    func getYearsBetweenTwoDates(montI: String, yearI: String, montF: String, yearF: String) -> Int {
        let month1 = months.firstIndex(of: montI)!+1
        let month2 = months.firstIndex(of: montF)!+1
        
        let date1 = DateComponents(calendar: .current, year: Int(yearI), month: month1, day: 15, hour: 0, minute: 0).date!
        let date2 = DateComponents(calendar: .current, year: Int(yearF), month: month2, day: 15, hour: 0, minute: 0).date!
        
        return date2.getYears(from: date1)
    }
}

extension Date {
    func getYears(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
}

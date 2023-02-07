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
    
    func getRelativeTimeAbbreviated(date: String, time: String) -> String {
        let stringDate = "\(date) \(time)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let fromDate = dateFormatter.date(from: stringDate)
        
        let relFormatter = RelativeDateTimeFormatter()
        relFormatter.unitsStyle = .abbreviated
        let time = relFormatter.localizedString(for: fromDate!, relativeTo: Date())
        
        return time
    }
    func getRelativeTimeFull(date: String, time: String) -> String {
        let stringDate = "\(date) \(time)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let fromDate = dateFormatter.date(from: stringDate)
        
        let relFormatter = RelativeDateTimeFormatter()
        relFormatter.unitsStyle = .full
        let time = relFormatter.localizedString(for: fromDate!, relativeTo: Date())
        
        return time
    }
}

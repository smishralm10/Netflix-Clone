//
//  Utils.swift
//  Netflix Clone
//
//  Created by Shreyansh Mishra on 06/09/22.
//

import Foundation

func convertToTitleDateString(_ dateString: String) -> String? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    
    guard let date = dateFormatter.date(from: dateString) else {
        return nil
    }
    
    let dateString = date.formatted(date: .abbreviated, time: .omitted).split(separator: ",")[0]
    return String(dateString)
}

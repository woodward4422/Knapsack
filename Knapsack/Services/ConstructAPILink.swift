//
//  ConstructAPILink.swift
//  Knapsack
//
//  Created by Noah Woodward on 8/1/18.
//  Copyright © 2018 Noah Woodward. All rights reserved.
//

import Foundation

struct ConstructAPILink{
    
    static func constructWeatherLink(latitude: Double , longitude: Double) -> String{
        var weatherLink = "https://api.darksky.net/forecast/f169470b0e9484eb75680a0a9d5b51b3/\(latitude),\(longitude),2018-07-22T06:24:15?exclude=currently,flags"
        return weatherLink
    }
    
    static func constructLocationLink(latitude: Double, longitude: Double) -> String {
        var locationLink = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(latitude),\(longitude)&key=AIzaSyBwSvp514RGEiCmMuVrZ5_L_o98yvnTd-k"
        return locationLink
    
    }
    
}

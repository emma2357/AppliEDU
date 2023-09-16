//
//  AppEnvironmentInfo.swift
//  AppliEDU
//
//  Created by Emma Capaldi on 4/27/23.
//

import SwiftUI

// color and formatting information
struct AppInfo {
    // color information
    var accentTabColor = Color(hue: 0.611, saturation: 0.871, brightness: 0.724)
    var backgroundBlueColor = Color(hue: 0.624, saturation: 0.629, brightness: 0.514)
    var accentBlueColor = Color(hue: 0.624, saturation: 0.128, brightness: 0.95)
    var whiteAccent = Color(.white)
    
    // size information
    var maxWidth = UIScreen.main.bounds.size.width
    
    // font information
    var font = "Times New Roman"
    var body: CGFloat = 20
    var title: CGFloat = 28
    var title2: CGFloat = 24
    var smallBody: CGFloat = 16
}

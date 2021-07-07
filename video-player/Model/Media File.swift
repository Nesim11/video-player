//
//  Media File.swift
//  video-player
//
//  Created by Nesim Alma on 2.07.2021.
//

import Foundation

// Sample Model And Reels Videos...

struct MediaFile: Identifiable {
    var id  = UUID().uuidString
    var url: String
    var title: String
    var isExpanded: Bool = false
    
    
}

var MediaFileJSON = [
    
    MediaFile(url: "Reel1" , title: "Apple AirTag.....") ,
    MediaFile(url: "Reel2" , title: "omg.....Animal crossing") ,
    MediaFile(url: "Reel3" , title: "So hybed for Halo....") ,
    MediaFile(url: "Reel4" , title: "SponsorShip.....") ,
    MediaFile(url: "Reel5" , title: "Hi.. What are you ?") ,
    MediaFile(url: "Reel6" , title: "Wonderfull") 

]

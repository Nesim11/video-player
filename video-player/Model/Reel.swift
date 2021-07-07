//
//  Reel.swift
//  video-player
//
//  Created by Nesim Alma on 4.07.2021.
//

import SwiftUI
import AVKit

struct Reel: Identifiable {
    
    var id = UUID().uuidString
    var player: AVPlayer?
    var mediFile: MediaFile 
    
}


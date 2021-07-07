//
//  ReelsView.swift
//  video-player
//
//  Created by Nesim Alma on 3.07.2021.
//

import SwiftUI
import AVKit
struct ReelsView: View {
    @State var currentReel = ""
    
    // Extracting Avplayer from media File...
    @State var reels = MediaFileJSON.map{ item -> Reel in
        
        let url = Bundle.main.path(forResource: item.url,
                                   ofType: "mp4") ?? ""
        let player = AVPlayer(url: URL(fileURLWithPath: url))
        
        return Reel(player: player, mediFile: item)
        
    }
    var body: some View {
        
        // Setting Width and height for rotated view....
        GeometryReader{proxy in
            
            let size = proxy.size
            
            
            // Vertical Page Tab View....
            TabView(selection: $currentReel){
                
                ForEach($reels) {$reel in
                    
                    ReelsPlayer(reel: $reel, currentReel: $currentReel)
                    
                    // Setting width...
                    .frame(width: size.width)
                    .padding()
                    // Rotating Content...
                    .rotationEffect(.init(degrees: -90))
                        .ignoresSafeArea(.all, edges: .top)
                        .tag(reel.id)
                    
                }
                
            }
            // Rotating View....
            .rotationEffect(.init(degrees: 90))

            //  Since view is rotated setting height as width...
            .frame(width: size.height)
            .tabViewStyle(.page(indexDisplayMode: .never))
            // setting max width...
            .frame(width: size.width)
            }
        .ignoresSafeArea(.all, edges: .top)
        .background(Color.black.ignoresSafeArea())
        // setting intial reel...
        .onAppear {
            currentReel = reels.first?.id ?? ""
        }
           }
    
    }

struct ReelsView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ReelsPlayer: View{
    @Binding var reel: Reel
    
    @Binding var currentReel: String
    
    // Expading title if its clicked...
    @State var  showMore = false
    
    @State var isMuted = false
    @State var volumeAnimation = false
    
    var body: some View{
        
        ZStack{
         // safe Check...
            if let player = reel.player{
                
                CustomVideoPlayer(player: player)
                
                // Playing Video Based on Offset...
                
                GeometryReader{proxy -> Color in
                    
                    let minY = proxy.frame(in: .global).minY
                    
                    DispatchQueue.main.async {
                        
                        // since we have many cards and ofset goes beyond
                        // so it starts playing the below videos...
                        // to avoid this checking the current one with current reel id....
                         
                        if  -minY < (size.height / 2) && minY < (size.height / 2)
                                && currentReel == reel.id{
                            player.play()
                    
                            }
                        else{
                            player.pause()
                        }
                    }
                    
                    return Color.clear
                    
                }
                
                // Volume COntrol....
                // allowing control for set of area...
                // its your wish...
                Color.black
                    .opacity(0.01)
                    .frame(width: 120, height: 150)
                    .onTapGesture {
                        if volumeAnimation{
                            return
                        }
                        isMuted.toggle()
                        // Muting player...
                        player.isMuted = isMuted
                        withAnimation{volumeAnimation.toggle()}
                        
                        // Closing animation after 0.8 sec...
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                            
                            withAnimation{volumeAnimation.toggle()}
                            
                            
                        }
                        
                    }
                
                // Dimming background when showing more  content...
                Color.black.opacity(showMore ? 0.35 : 0)
                onTapGesture {
                    // closing it...
                    withAnimation{showMore.toggle()}
                }
                
                VStack{
                        
                    HStack(alignment: .bottom){
                        
                        VStack(alignment: .leading, spacing: 10) {
                            
                            HStack(spacing: 15){
                                
                                
                                
                                
                                Image("profile")
                                    .resizable()
                                    .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                                    .frame(width: 30, height: 30 )
                                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                                
                                Text("Nesim")
                                    .font(.system(size: 24.0))
                                
                                Button {
                                } label: {
                                        Text("Follow")
                                            .font(.system(size: 24.0))
                                    }
                                }
                            
                            // Title Custom View...
                            ZStack{
                                if showMore {
                                    
                                    ScrollView(.vertical, showsIndicators: false) {
                                        
                                        // your extra text...
                                        HStack{
                                            Text(reel.mediaFile.title + sampleText)
                                                .font(.system(size: 24.0))
                                                .fontWeight(.semibold)
                                        
                                        
                                    }
                                        .frame(height: 120)
                                        .onTapGesture {
                                            withAnimation{showMore.toggle()}
                                        }
                                }
                                
                                    else{
                                  
                                    Button{
                                        
                                        withAnimation{showMore.toggle()}
                                        
                                    } label:{
                                        
                                        HStack{
                                            Text(reel.mediaFile.title)
                                                .font(.system(size: 24.0))
                                                .fontWeight(.semibold)
                                                .lineLimit(1)
                                            
                                            Text("more")
                                                .font(.system(size: 24.0))
                                                .foregroundColor(.gray)
                                            
                                        }
                                    }
                                    .padding(.top,6)
                                    .frame(maxWidth: .inifity, alignment:
                                            .leading)
                                }
                            }
                            }
                        
                            Spacer(minLength: 20)
                            
                            // List of Buttons....
                            
                            ActionButtons(reel: reel)
                      }
                        
                        // Music View...
                        HStack {
                            Text("Hold on bro")
                                .font(.system(size: 24.0))
                                .fontWeight(.semibold)
                            
                            Spacer(minLength: 20)
                            
                            Image("album")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 30, height: 30    )
                                .cornerRadius(6)
                                .background(
                                
                                  RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color.white, lineWidth: 3)
                                )
                                .offset(x: -5)
                        }()
                        .padding(.top,6)
                        
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                .foregroundColor(.white)
                 .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    Image(systemName: isMuted ? "speaker.slash.fill" : "speaker.wave.2.fill")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
                    .background(.secondary)
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    .foregroundStyle(.black)
                    .opacity(volumeAnimation ? 1 : 0)
            }
            
        }
    }
}
    
    struct ActionButtons: View{
        var reel: Reel
        
        var body: some View{
            
            VStack(spacing: 25) {
                
                Button{
                    
                } label: {
                    VStack (spacing: 10){
                        
                        Image(systemName: "suit.heart")
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        
                        Text("233K")
                            .font(.system(size: 24.0))
                    }
                    
                    
                }
                
                Button{
                    
                } label: {
                    VStack (spacing: 10){
                        
                        Image(systemName: "bubble.right")
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        
                        Text("120")
                            .font(.system(size: 24.0))
                    }
                    
                    
                }
                
                Button{
                    
                } label: {
                    VStack (spacing: 10){
                        
                        Image(systemName: "paperplane")
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        
                    }
                    
                    
                }
                
                Button {
                    
                } label: {
                    Image("menu")
                        .resizable()
                        .renderingMode(/*@START_MENU_TOKEN@*/.template/*@END_MENU_TOKEN@*/)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                    // rotating...
                        .rotationEffect(.init(degrees: 90))
                }
                
            }
        }
    }
    
let sampleText = "How much very simle. can ı do you speak "
}

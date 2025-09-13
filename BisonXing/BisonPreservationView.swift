//
//  BisonPreservationView.swift
//  BisonXing
//
//  Created by Bryan Sanchez on 9/6/25.
//

import SwiftUI

struct BisonPreservationView: View {
    var body: some View {
        GeometryReader { geo in
            ZStack {
                
                Image("BisonMap")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .bottomLeading)
                    .clipped()
                    .ignoresSafeArea(.all)
                VStack(spacing: 40){
                    YouTubeView(videoID: "OtF9QBQGMt4")
                        .frame(width:200, height: 120)
                        .aspectRatio(16/9, contentMode: .fit)
                        .cornerRadius(12)
                        .padding(.horizontal)
                        .offset(x: -10,y: -70)
                    YouTubeView(videoID: "XcjjOanUDcg")
                        .frame(width:200, height: 120)
                        .aspectRatio(16/9, contentMode: .fit)
                        .cornerRadius(12)
                        .padding(.horizontal)
                        .offset(x: 40,y: 0)
                    YouTubeView(videoID: "98Iff1lG8DY")
                        .frame(width:200, height: 120)
                        .aspectRatio(16/9, contentMode: .fit)
                        .cornerRadius(12)
                        .padding(.horizontal)
                        .offset(x: 70,y: 175)

                }
                
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    BisonPreservationView()
}

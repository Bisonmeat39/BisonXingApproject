//
//  BisonHIstoryView.swift
//  BisonXing
//
//  Created by Bryan Sanchez on 9/6/25.
//

import SwiftUI

struct BisonHistoryView: View {
    var body: some View {
        GeometryReader { geo in
            ZStack {
                
                Image("BisonMap")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .bottomLeading)
                    .clipped()
                    .ignoresSafeArea(.all)
                VStack{
                    Spacer()
                    YouTubeView(videoID: "sruWXhladJs")
                        .aspectRatio(16/9, contentMode: .fit)
                        .cornerRadius(12)
                        .padding(.horizontal)
                    Spacer()
                    Text("History")
                    Spacer()
                }
                
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    BisonHistoryView()
}

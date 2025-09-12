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
                Text("Preservation")
                
                
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    BisonPreservationView()
}

//
//  BisonHIstoryView.swift
//  BisonXing
//
//  Created by Bryan Sanchez on 9/6/25.
//

import SwiftUI

struct BisonHistoryView: View {
    var body: some View {
        VStack {
            
                Image("Bison Xing")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300)
                    .padding()
            Text("History")
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RadialGradient(
                gradient: Gradient(colors: [ .green, .black]), center: .center, startRadius: 50,endRadius: 500))
    }
}

#Preview {
    BisonHistoryView()
}

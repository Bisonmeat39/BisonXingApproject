//
//  TableOfContentsView.swift
//  BisonXing
//
//  Created by Bryan Sanchez on 9/6/25.
//

import SwiftUI

struct TableOfContentsView: View {
    var body: some View {
        NavigationStack {
            VStack {
                
                Image("Bison Xing")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150)
                    .padding()
                    .offset(y: -200)
                NavigationLink(destination: BisonHistoryView()){
                    Text("Bison History")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.green)
                                .cornerRadius(10)
                }
                NavigationLink(destination: BisonPreservationView()){
                    Text("Bison Preservation")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.green)
                                .cornerRadius(10)
                }
                NavigationLink(destination: BisonSafetyView()){
                    Text("Bison Safety")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.green)
                                .cornerRadius(10)
                }
                NavigationLink(destination: QuizView()){
                    Text("Bison Quiz")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.green)
                                .cornerRadius(10)
                }
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                RadialGradient(
                    gradient: Gradient(colors: [ .green, .black]), center: .center, startRadius: 50,endRadius: 500))
        }
    }
}

#Preview {
    TableOfContentsView()
}

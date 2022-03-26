//
//  PlayerTabView.swift
//  SwiftUiApp
//
//  Created by Дмитрий Никишов on 24.02.2022.
//

import SwiftUI

struct PlayerDetailView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Text("Player details")
            Button("Back") {
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct PlayerTabView: View {
    @State private var showingDetail = false
    
    var body: some View {
        Button(action: {
            self.showingDetail.toggle()
        }) {
            Text("Show detail")
        }.sheet(isPresented: $showingDetail) {
            PlayerDetailView()
        }
    }
}

struct PlayerTabView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerTabView()
    }
}

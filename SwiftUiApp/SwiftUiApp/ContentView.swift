//
//  ContentView.swift
//  SwiftUiApp
//
//  Created by Дмитрий Никишов on 24.02.2022.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedView = 0
    @State private var isProfileTabDisabled = false
    
    var body: some View {
        TabView(selection: $selectedView) {
            ProfileTabView(tabSelection: $selectedView, isViewDisabled: $isProfileTabDisabled).tabItem {
                Image(systemName: "person")
                Text("Profile")
            }
            .tag(0)
            .disabled(isProfileTabDisabled)
            
            FeedTabView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Feed")
                }.tag(1)
            
            PlayerTabView()
                .tabItem {
                    Image(systemName: "music.note")
                    Text("Player")
                }.tag(2)

            VideoTabView()
                .tabItem {
                    Image(systemName: "video")
                    Text("Video")
                }.tag(3)

            RecorderTabView()
                .tabItem {
                    Image(systemName: "mic")
                    Text("Recorder")
                }.tag(4)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

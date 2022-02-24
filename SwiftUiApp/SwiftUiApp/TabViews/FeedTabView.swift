//
//  FeedTabView.swift
//  SwiftUiApp
//
//  Created by Дмитрий Никишов on 24.02.2022.
//

import SwiftUI

struct FeedItem {
    var name : String
}

struct FeedListItem : View {
    var contentItem : FeedItem
    var body: some View {
        Text("\(contentItem.name)")
    }
}

struct FeedTabView: View {
    var body: some View {
        List {
            Section(header: Text("Driver")) {
                FeedListItem(contentItem: FeedItem(name: "Senna"))
                FeedListItem(contentItem: FeedItem(name: "Raikkonen"))
                FeedListItem(contentItem: FeedItem(name: "Hakkinen"))
            }.listRowBackground(Color.mint)
            
            Section(header: Text("Team")) {
                FeedListItem(contentItem: FeedItem(name: "McLaren"))
                FeedListItem(contentItem: FeedItem(name: "Ferrari"))
                FeedListItem(contentItem: FeedItem(name: "Williams"))
            }.listRowBackground(Color.orange)
        }.listStyle(.grouped)
    }
}

struct FeedTabView_Previews: PreviewProvider {
    static var previews: some View {
        FeedTabView()
    }
}

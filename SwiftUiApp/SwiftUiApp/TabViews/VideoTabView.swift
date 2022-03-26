//
//  VideoTabView.swift
//  SwiftUiApp
//
//  Created by Дмитрий Никишов on 24.02.2022.
//

import SwiftUI

struct Movie : Identifiable {
    var id = UUID()
    var name: String
}

struct MovieRow : View {
    var movie : Movie
    
    var body: some View {
        Text(movie.name)
    }
}

struct MovieDetails : View {
    var movie : Movie
    var body : some View {
        Text("Details for \(movie.name)")
            .font(.largeTitle)
    }
}

struct VideoTabView: View {
    var body: some View {
        let first = Movie(name: "Brilliant hand")
        let second = Movie(name: "God Father")
        let movies = [first, second]
        
        return NavigationView {
            List(movies) { item in
                NavigationLink(destination: MovieDetails(movie: item)) {
                MovieRow(movie: item)
                }
            }.navigationBarTitle("Choose a film")
        }
    }
}

struct VideoTabView_Previews: PreviewProvider {
    static var previews: some View {
        VideoTabView()
    }
}

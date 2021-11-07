//
//  ContentView.swift
//  labbtwo
//
//  Created by William Branth on 2021-11-06.
//

import SwiftUI
import Combine

/*final class Resturant: ObservableObject, Identifiable {
    let id = UUID()
    @Published var name: String
    @Published var description: String
    @Published var image: String
    @Published var menu: String
    @Published var phone: String

    init(name: String, description: String, image: String, menu: String, phone: String){
        self.name = name
        self.description = description
        self.image = image
        self.menu = menu
        self.phone = phone
    }
}*/

struct JSONData: Decodable {
    let restaurants: [Restaurant]
}
// youtube.com/watch?v=bMKpsmvYkKQ
// stackoverflow.com/questions/60677622/how-to-display-image-from-a-url-in-swiftui

struct Restaurant: Decodable, Identifiable, Hashable {
    let id: Int
    let name: String
    let description: String
    let image: String
    let telefon: String
    let menu: String
}

struct FavoritesView: View {
    let favorites: [Restaurant]
    var body: some View {

        Section(header: Text("Your favorites")){
            ForEach(favorites, id: \.self) { favorite in
                Text("Your favorites")
                HStack {
                    Text(favorite.name)
                    Text(favorite.telefon)
                }
            }
        }
    
    }
}

struct RestaurantView: View {
    let restaurant: Restaurant
    
    var body: some View {
        // developer.apple.com/documentation/swiftui/asyncimage
        AsyncImage(url: URL(string: restaurant.image)) { image in
            image.resizable()
        } placeholder: {
            ProgressView()
        }
        .frame(width: 300, height: 200)
        .border(Color.blue)
        
    
        List {
            Section(header: Text("Telefon")) {
                Text("\(restaurant.telefon)")
            }
            Section(header: Text("Information")) {
                Text("\(restaurant.description)")
            }
            Section(header: Text("Meny")) {
                Text("\(restaurant.menu)")
            }
        }
    }
}

struct ContentView: View {
    @State private var restaurants: [Restaurant] = []
    @State private var favorites: [Restaurant] = []
    var body: some View {
        NavigationView {
        ZStack {
            VStack (alignment: .leading) {
                List {
                    Section(header: Text("All restaurants")){
                        ForEach(restaurants, id: \.self) { restaurant in
                            HStack {
                                Text(restaurant.name)
                                    .fontWeight(Font.Weight.heavy)
                                Spacer()
                                Image(systemName: "plus.square")
                            }
                            Text(restaurant.telefon)
                            NavigationLink("Further Details", destination: RestaurantView(restaurant: restaurant))
                        }
                    }
                    FavoritesView(favorites: favorites)
                }
            }
            //.background(Color(red: 245 / 255 , green: 245 / 255 , blue: 245 / 255))
        }
            .navigationTitle("Restaurants 4U")
            .onAppear(perform: readFile)
        }
    }
    private func readFile() {
        if let url = Bundle.main.url(forResource: "restaurants", withExtension: "json"),
           let data = try? Data(contentsOf: url) {
            let decoder = JSONDecoder()
            if let jsonData = try? decoder.decode(JSONData.self, from: data) {
                print(jsonData.restaurants)
                self.restaurants = jsonData.restaurants
            }
        }
    }
    private func addRestaurant(restaurant: Restaurant) {
        favorites.append(restaurant)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

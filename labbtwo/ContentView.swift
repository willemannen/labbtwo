//
//  ContentView.swift
//  labbtwo
//
//  Created by William Branth on 2021-11-06.
//

import SwiftUI
import Combine

// youtube.com/watch?v=bMKpsmvYkKQ
// stackoverflow.com/questions/60677622/how-to-display-image-from-a-url-in-swiftui

struct JSONData: Decodable {
    let restaurants: [Restaurant]
}

struct dayAndHour {
    let day: String
    let hour: String
}

struct Restaurant: Decodable, Hashable {
    let id: Int
    let name: String
    let description: String
    let image: String
    let telefon: String
    let menu: String
    let categories: [String]
    let opening_hours: [String: String]
    let location: [String: Double]
 
}


struct FavoritesView: View {
    @Binding var favorites: [Restaurant]
    var body: some View {

        Section(header: Text("Your favorites")){
            ForEach(Array(zip(favorites.indices, favorites)), id: \.0) { (index, favorite) in
                HStack {
                    Text(favorite.name)
                    Spacer()
                    Text(favorite.telefon)
                    Button {
                        favorites.remove(at: index)
                    } label: {
                        Image(systemName: "minus.square")
                    }
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
            Section(header: Text("Opening Hours")) {
                ForEach(restaurant.opening_hours.keys.sorted(by: sortedWeekDay), id: \.self) { openDay in
                    HStack {
                        Text(openDay)
                        Spacer()
                        Text(restaurant.opening_hours[openDay]!)
                    }
                }
            }
            Section(header: Text("Categories")) {
                ForEach(restaurant.categories, id: \.self) { category in
                    Text(category)
                }
            }
        }
    }
    private func sortedWeekDay(first: String, second: String) -> Bool {
        let weekDaysSorted = [
            "mon": 6,
            "tue": 5,
            "wed": 4,
            "thu": 3,
            "fri": 2,
            "sat": 1,
            "sun": 0
        ]
        
        return weekDaysSorted[first]! > weekDaysSorted[second]!
    }
    /*
    private func getSortedOpeningDays(restaurant: Restaurant) -> [[String]]
    {
        
        var sorted: [[String]] = [[]]
        let weekDaysSorted = [
            "mon",
            "tue",
            "wed",
            "thu",
            "fri",
            "sat",
            "sun",
        ]
        
        for weekDay in weekDaysSorted {
            let dayStr = weekDay
            let openingTimeStr = restaurant.opening_hours[dayStr]!
            sorted.append([dayStr, openingTimeStr])
        }
        return sorted
    }*/
}


struct RandomRestaurantView: View {
    @Binding var restaurants: [Restaurant]
    @State var randomRestaurant: Restaurant?

    
    var body: some View
    {
        Button {
                randomRestaurant = restaurants.randomElement()!
            }
         label: {
             VStack {
                 if randomRestaurant != nil {
                     NavigationLink(randomRestaurant!.name, destination: RestaurantView(restaurant: randomRestaurant!))
                 }
                 Circle()
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
                NavigationLink("I am lucky", destination: RandomRestaurantView(restaurants: $restaurants, randomRestaurant: nil))

                List {
                    
                    Section(header: Text("All restaurants")){
                        ForEach(restaurants, id: \.self) { restaurant in
                            HStack {
                                Text(restaurant.name)
                                    .fontWeight(Font.Weight.heavy)
                                Spacer()
                                Button {
                                    if !isFavorited(restaurant: restaurant){
                                        self.addRestaurantToFavorite(restaurant: restaurant)
                                    }
                                } label: {
                                    Image(systemName: "plus.square")
                                }
                            }
                            Text(restaurant.telefon)
                            NavigationLink("Further Details", destination: RestaurantView(restaurant: restaurant))
                        }
                    }
                    FavoritesView(favorites: $favorites)
                }
            }
        }
            .navigationTitle("Restaurants 4U")
            .onAppear(perform: readFile)
        }
    }
    private func readFile() {
        print("HEHE")
        if let url = Bundle.main.url(forResource: "restaurants", withExtension: "json"),
           let data = try? Data(contentsOf: url) {
            let decoder = JSONDecoder()
            if let jsonData = try? decoder.decode(JSONData.self, from: data) {
                print(jsonData.restaurants)
                self.restaurants = jsonData.restaurants
            }
        }
    }
    
    private func addRestaurantToFavorite(restaurant: Restaurant) {
        favorites.append(restaurant)
    }
    
    private func isFavorited(restaurant: Restaurant) -> Bool {
        let isRestaurantFavorited = favorites.contains(restaurant)
        return isRestaurantFavorited
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

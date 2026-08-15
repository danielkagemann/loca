//
//  PlaceListView.swift
//  loca
//
//  Created by Daniel Kagemann on 11.08.26.
//

import SwiftData
import SwiftUI

struct PlaceListView: View {
   // environment
   @Environment(\.modelContext) private var modelContext

   // queries
   @Query private var places: [Place]

   // state
   @State private var showAddPlace: Bool = false

   var body: some View {
      Group {
         if places.isEmpty {
            Empty(title: "No places", message: "There are no places available yet.", cta: "+ Add your first place") {
               showAddPlace = true
            }
         } else {
            VStack {
               // headline
               HStack {
                  Text("Loca").bold()
                  Spacer()
                  Image(systemName: "magnifyingglass")
                  Image(systemName: "plus.app").onTapGesture { showAddPlace = true }
               }.padding(.horizontal, 16)

               // list
               List {
                  ForEach(places) { place in
                     PlaceRow(place: place)
                  }
               }
               .listStyle(.plain)
            }
         }
      }
      .sheet(isPresented: $showAddPlace) {
         AddPlaceView(visible: $showAddPlace)
      }
   }
}

#Preview {
   PlaceListView()
}

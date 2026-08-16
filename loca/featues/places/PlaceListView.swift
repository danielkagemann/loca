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
   @State private var filter: PlaceFilter.FilterType = .all

   func filteredPlaces() -> [Place] {
      do {
         switch filter {
         case .all:
            return try modelContext.fetch(FetchDescriptor<Place>())
         case .visited:
            let descriptor = FetchDescriptor<Place>(predicate: #Predicate { $0.visited != nil })
            return try modelContext.fetch(descriptor)
         case .favorites:
            let descriptor = FetchDescriptor<Place>(predicate: #Predicate { $0.favorite == true })
            return try modelContext.fetch(descriptor)
         }
      } catch {
         // In case of a fetch failure, return the current in-memory list as a fallback
         return places
      }
   }

   @ViewBuilder func NoData() -> some View {
      if places.isEmpty {
         Empty(title: "No places", message: "There are no places available yet.", cta: "+ Add your first place") {
            showAddPlace = true
         }
      }
   }

   @ViewBuilder func Content() -> some View {
      if !places.isEmpty {
         VStack {
            // headline
            HStack {
               Text("Loca").bold().font(.title)
               Spacer()
               Image(systemName: "plus.app")
                  .resizable()
                  .frame(width: 24, height: 24)
                  .onTapGesture { showAddPlace = true }
            }.padding(.horizontal, 16)

            // filter
            PlaceFilter(filter: $filter)
               .padding(.horizontal, 16)

            // list
            List(filteredPlaces()) { pl in
               NavigationLink(value: pl.id) {
                  PlaceRow(place: pl)
               }
            }
            .listStyle(.plain)
            .navigationDestination(for: UUID.self) { placeId in
               if let place = places.first(where: { $0.id == placeId }) {
                  PlaceDetails(place: place)
               }
            }
         }
      }
   }

   var body: some View {
      Group {
         NoData()
         Content()
      }
      .sheet(isPresented: $showAddPlace) {
         AddPlaceView(visible: $showAddPlace)
      }
   }
}

#Preview {
   NavigationStack {
      PlaceListView()
   }
}

//
//  PlaceListView.swift
//  loca
//
//  Created by Daniel Kagemann on 11.08.26.
//

import SwiftData
import SwiftUI

let NO_COUNTRY = "No country"

struct PlaceListView: View {
   private struct PlaceCountryGroup: Identifiable {
      let country: String
      let places: [Place]

      var id: String { country }
   }

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

   private func country(for place: Place) -> String {
      guard let address = place.address else {
         return NO_COUNTRY
      }

      let addressParts = address
         .replacingOccurrences(of: "\n", with: ",")
         .split(separator: ",")
         .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
         .filter { !$0.isEmpty }

      return addressParts.last ?? NO_COUNTRY
   }

   private func groupedPlaces() -> [PlaceCountryGroup] {
      Dictionary(grouping: filteredPlaces(), by: country)
         .map { country, places in
            PlaceCountryGroup(
               country: country,
               places: places.sorted { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending }
            )
         }
         .sorted {
            if $0.country == NO_COUNTRY { return false }
            if $1.country == NO_COUNTRY { return true }
            return $0.country.localizedCaseInsensitiveCompare($1.country) == .orderedAscending
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
            List {
               ForEach(groupedPlaces()) { group in
                  Section(group.country) {
                     ForEach(group.places) { pl in
                        NavigationLink(value: pl.id) {
                           PlaceRow(place: pl)
                        }
                     }
                  }
               }
            }
            .listStyle(.insetGrouped)
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
   .modelContainer(PreviewData.container)
}

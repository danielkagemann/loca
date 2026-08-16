//
//  PreviewData.swift
//  loca
//
//  Created by Daniel Kagemann on 16.08.26.
//

import Foundation
import SwiftData

@MainActor
enum PreviewData {
   static let container: ModelContainer = {
      do {
         let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
         let container = try ModelContainer(for: Place.self, configurations: configuration)

         samplePlaces.forEach { place in
            container.mainContext.insert(place)
         }

         return container
      } catch {
         fatalError("Could not create preview ModelContainer: \(error)")
      }
   }()

   static var samplePlace: Place {
      samplePlaces[0]
   }

   static var samplePlaces: [Place] {
      [
         Place(
            title: "Cafe am Neuen See",
            address: "Lichtensteinallee 2, 10787 Berlin, Deutschland",
            latitude: 52.5146,
            longitude: 13.3456,
            notes: "Good outdoor seating and a quiet spot for an afternoon coffee.",
            website: "https://www.cafeamneuensee.de",
            favorite: true,
            category: "Cafe",
            visited: Date(),
            rating: 5
         ),
         Place(
            title: "Museo del Prado",
            address: "C. de Ruiz de Alarcon 23, 28014 Madrid, Spanien",
            latitude: 40.4138,
            longitude: -3.6921,
            notes: "Save at least half a day for the permanent collection.",
            website: "https://www.museodelprado.es",
            favorite: false,
            category: "Museum",
            visited: Calendar.current.date(byAdding: .day, value: -12, to: Date()),
            rating: 4
         ),
         Place(
            title: "Alicante Central Market",
            address: "Av. Alfonso El Sabio 10, 03004 Alicante, Spanien",
            latitude: 38.3489,
            longitude: -0.4865,
            notes: "Great stop before heading to the beach.",
            favorite: true,
            category: "Food",
            visited: Calendar.current.date(byAdding: .month, value: -2, to: Date()),
            rating: 5
         ),
         Place(
            title: "Tempelhofer Feld",
            address: "Tempelhofer Damm, 12101 Berlin, Deutschland",
            latitude: 52.4730,
            longitude: 13.4039,
            notes: "Bring a bike when the weather is good.",
            favorite: false,
            category: "Park",
            rating: 3
         )
      ]
   }
}

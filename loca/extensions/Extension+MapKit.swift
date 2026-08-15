//
//  Extension+MapKit.swift
//  loca
//
//  Created by Daniel Kagemann on 13.08.26.
//

import MapKit

extension MKPointOfInterestCategory {
   var displayName: String {
      switch self {
      case .restaurant:
         return "Restaurant"
      case .cafe:
         return "Cafe"
      case .hotel:
         return "Hotel"
      case .parking:
         return "Parking"
      case .gasStation:
         return "Gas Station"
      case .hospital:
         return "Hospital"
      case .pharmacy:
         return "Pharmacy"
      case .school:
         return "School"
      case .bank:
         return "Bank"
      case .atm:
         return "ATM"
      case .store:
         return "Store"
      case .bakery:
         return "Bakery"
      case .beach:
         return "Beach"
      case .park:
         return "Park"
      case .museum:
         return "Museum"
      case .movieTheater:
         return "Movie Theater"
      case .fitnessCenter:
         return "Fitness Center"
      case .airport:
         return "Airport"
      case .publicTransport:
         return "Public Transport"
      default:
         return "---"
      }
   }

   static var allCategories: [MKPointOfInterestCategory] {
      [
         .restaurant,
         .cafe,
         .hotel,
         .parking,
         .gasStation,
         .hospital,
         .pharmacy,
         .school,
         .bank,
         .atm,
         .store,
         .bakery,
         .beach,
         .park,
         .museum,
         .movieTheater,
         .fitnessCenter,
         .airport,
         .publicTransport,
      ]
   }

   static func getAllCategories() -> [String] {
      allCategories.map { $0.displayName }.sorted()
   }
}

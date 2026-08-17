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
      case .foodMarket:
         return "Market"
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
      case .brewery:
         return "Brewery"
      case .beach:
         return "Beach"
      case .campground:
         return "Campground"
      case .park:
         return "Park"
      case .nationalPark:
         return "National Park"
      case .museum:
         return "Museum"
      case .library:
         return "Library"
      case .movieTheater:
         return "Movie Theater"
      case .theater:
         return "Theater"
      case .musicVenue:
         return "Music Venue"
      case .fitnessCenter:
         return "Fitness Center"
      case .stadium:
         return "Stadium"
      case .baseball:
         return "Baseball"
      case .basketball:
         return "Basketball"
      case .bowling:
         return "Bowling"
      case .golf:
         return "Golf"
      case .hiking:
         return "Hiking"
      case .miniGolf:
         return "Mini Golf"
      case .skatePark:
         return "Skate Park"
      case .skiing:
         return "Skiing"
      case .soccer:
         return "Soccer"
      case .swimming:
         return "Swimming"
      case .tennis:
         return "Tennis"
      case .airport:
         return "Airport"
      case .publicTransport:
         return "Public Transport"
      case .carRental:
         return "Car Rental"
      case .evCharger:
         return "EV Charger"
      case .postOffice:
         return "Post Office"
      case .police:
         return "Police"
      case .fireStation:
         return "Fire Station"
      case .university:
         return "University"
      case .zoo:
         return "Zoo"
      default:
         return "---"
      }
   }

   static var customCategories: [String] {
      [
         "Doctor",
         "Physio",
         "Dentist",
         "Nail Salon",
         "Hair Salon",
         "Optometrist",
         "Podiatrist",
         "Pet Store",
         "Garden Center",
         "Coffee Shop",
         "Pub",
      ]
   }

   static var allCategories: [MKPointOfInterestCategory] {
      [
         .restaurant,
         .cafe,
         .foodMarket,
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
         .brewery,
         .beach,
         .campground,
         .park,
         .nationalPark,
         .museum,
         .library,
         .movieTheater,
         .theater,
         .musicVenue,
         .fitnessCenter,
         .stadium,
         .baseball,
         .basketball,
         .bowling,
         .golf,
         .hiking,
         .miniGolf,
         .skatePark,
         .skiing,
         .soccer,
         .swimming,
         .tennis,
         .airport,
         .publicTransport,
         .carRental,
         .evCharger,
         .postOffice,
         .police,
         .fireStation,
         .university,
         .zoo,
      ]
   }

   static func getAllCategories() -> [String] {
      Array(Set(allCategories.map { $0.displayName } + customCategories)).sorted()
   }
}

extension MKMapItem {
   /// Ländername garantiert auf Englisch, unabhängig vom Gerätegebietsschema
   var englishCountryName: String? {
      guard let isoCode = placemark.isoCountryCode, !isoCode.isEmpty else { return nil }
      return Locale(identifier: "en_US").localizedString(forRegionCode: isoCode)
   }

   /// Volle Adresse mit erzwungenem englischem Ländernamen
   var formattedAddressEnglishCountry: String {
      guard let reps = addressRepresentations else {
         return (address?.fullAddress ?? name ?? "").components(separatedBy: "\n").joined(separator: ", ")
      }

      let full = (reps.fullAddress(includingRegion: true, singleLine: true) ?? "")
         .components(separatedBy: "\n").joined(separator: ", ")

      // replace last element with english country
      let englishCountry = englishCountryName ?? ""

      // drop last element
      let components = full.components(separatedBy: ", ")
      let withoutCountry = components.dropLast().joined(separator: ", ")

      return [withoutCountry, englishCountry]
         .filter { !$0.isEmpty }
         .joined(separator: ", ")
   }
}

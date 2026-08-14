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
         return "Café"
      case .hotel:
         return "Hotel"
      case .parking:
         return "Parkplatz"
      case .gasStation:
         return "Tankstelle"
      case .hospital:
         return "Krankenhaus"
      case .pharmacy:
         return "Apotheke"
      case .school:
         return "Schule"
      case .bank:
         return "Bank"
      case .atm:
         return "Geldautomat"
      case .store:
         return "Geschäft"
      case .bakery:
         return "Bäckerei"
      case .beach:
         return "Strand"
      case .park:
         return "Park"
      case .museum:
         return "Museum"
      case .movieTheater:
         return "Kino"
      case .fitnessCenter:
         return "Fitnessstudio"
      case .airport:
         return "Flughafen"
      case .publicTransport:
         return "Öffentliche Verkehrsmittel"
      default:
         return "Ort"
      }
   }
}

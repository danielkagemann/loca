//
//  Place.swift
//  loca
//
//  Created by Daniel Kagemann on 11.08.26.
//

import Foundation
import SwiftData

@Model
final class Place {
   var title: String
   var address: String?
   var latitude: Double?
   var longitude: Double?
   var notes: String?
   var image: Data?
   var website: String?
   var favorite: Bool
   var category: String?
   var visited: Bool
   var rating: Int


   init(title: String = "",
        address: String? = nil,
        latitude: Double? = nil,
        longitude: Double? = nil,
        notes: String? = nil,
        image: Data? = nil,
        website: String? = nil,
        favorite: Bool = false,
        category: String? = nil,
        visited: Bool = false,
        rating: Int = 0) {
      self.title = title
      self.address = address
      self.latitude = latitude
      self.longitude = longitude
      self.notes = notes
      self.image = image
      self.website = website
      self.favorite = favorite
      self.category = category
      self.visited = visited
      self.rating = rating
   }
   
   func hasValidCoordinates() -> Bool {
      latitude != nil && longitude != nil
   }
}

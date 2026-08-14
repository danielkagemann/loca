//
//  PlaceRow.swift
//  loca
//
//  Created by Daniel Kagemann on 12.08.26.
//

import SwiftUI
import CoreLocation

struct PlaceRow: View {
   // input
   let place: Place

   var body: some View {
      HStack {
         
      }
   }
}

#Preview {
   let place = Place(
      title: "Berlin",
      favorite: true,
      visited: true,
      rating: 4
   )
   PlaceRow(place: place)
}

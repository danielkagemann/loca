//
//  PlaceCategories.swift
//  loca
//
//  Created by Daniel Kagemann on 16.08.26.
//

import Foundation
import MapKit
import SwiftUI

struct PlaceCategories: View {
   // input
   let selected: String
   let action: (String) -> Void

   // state
   @State private var searchQuery = ""

   var body: some View {
      NavigationView {
         List(filteredCategories, id: \.self) { category in
            Text(category)
               .fontWeight(selected == category ? .bold : .regular)
               .contentShape(.rect)
               .onTapGesture {
               action(category)
            }
         }
         .listStyle(.plain)
         .navigationTitle("Select cateogory")
      }
      .searchable(text: $searchQuery)
   }

   var filteredCategories: [String] {
      if searchQuery.isEmpty {
         return MKPointOfInterestCategory.getAllCategories()
      } else {
         return MKPointOfInterestCategory.getAllCategories().filter { $0.localizedCaseInsensitiveContains(searchQuery) }
      }
   }
}

#Preview {
   PlaceCategories(selected: "") {_ in
   }
}

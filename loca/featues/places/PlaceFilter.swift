//
//  PlaceFilter.swift
//  loca
//
//  Created by Daniel Kagemann on 16.08.26.
//

import SwiftData
import SwiftUI

struct PlaceFilter: View {
   // expose
   enum FilterType {
      case all
      case favorites
      case visited
   }

   // input
   @Binding var filter: FilterType

   // queries
   @Query var places: [Place]
   
   // derived state
   var allCategories: Set<String> {
      Set(places.compactMap(\.category))
   }

   @ViewBuilder func Tag(_ text: String, _ amount: Int, _ active: Bool) -> some View {
      HStack (spacing: 4) {
         Text(text).fontWeight(active ? .bold : .regular)
         Text("\(amount)").font(.caption)
      }
      .padding(.horizontal, 10)
      .padding(.vertical, 6)
      .background(active ? .accent : .gray.opacity(0.2))
      .clipShape(.capsule)
      .foregroundStyle(active ? .white : .black)
   }

   var body: some View {
      HStack(spacing: 6) {
         Tag("All", places.count, filter == .all)
            .onTapGesture {
               filter = .all
            }
         Tag("Visited", places.filter { $0.visited != nil }.count, filter == .visited)
            .onTapGesture {
               filter = .visited
            }
         Tag("Favorites", places.filter { $0.favorite }.count, filter == .favorites)
            .onTapGesture {
               filter = .favorites
            }

         Spacer()
      }
      /*
         ScrollView(.horizontal, showsIndicators: false) {
            HStack (spacing: 8){
               ForEach(Array(allCategories).sorted(), id: \.self) { category in
                  Text(category)
               }
            }.font(.callout)
         }*/
   }
}

#Preview {
   PlaceFilter(filter: .constant(.all))
      .modelContainer(PreviewData.container)

}


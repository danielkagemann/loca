//
//  PlaceRow.swift
//  loca
//
//  Created by Daniel Kagemann on 12.08.26.
//

import SwiftUI

struct PlaceRow: View {
   // Input
   let place: Place
   
   // state
   @State private var showDetails: Bool = false

   // Renamed function to avoid shadowing the SwiftUI `Image` type
   @ViewBuilder func placeImage() -> some View {
      Group {
         if let data = place.image,
            let uiImage = UIImage(data: data) {
            Image(uiImage: uiImage)
               .resizable()
               .scaledToFill()
         } else {
            RoundedRectangle(cornerRadius: 12)
               .fill(Color.gray)
         }
      }
      .frame(width: 64, height: 64)
   }

   var body: some View {
      HStack (alignment: .top) {
         placeImage()
         VStack (alignment: .leading){
            Text(place.title).bold()
            Text(place.address ?? "").font(.caption).foregroundStyle(Color.gray)
            HStack {
               if let cat = place.category {
                  Chip(content: cat)
               }
               Image(systemName: "star.fill")
                  .resizable()
                  .frame(width: 14, height: 14)
                  .foregroundColor(Color.orange)
               Text("\(place.rating)").font(.caption2).bold()
            }
         }
      }
      .onTapGesture {
         showDetails.toggle()
      }
      .sheet(isPresented: $showDetails, content: {
         PlaceDetails(place: place)
      })
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

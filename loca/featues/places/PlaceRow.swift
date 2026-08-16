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
   
   // Renamed function to avoid shadowing the SwiftUI `Image` type
   @ViewBuilder func placeImage() -> some View {
      ZStack (alignment: .bottomTrailing) {
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
         .clipShape(RoundedRectangle(cornerRadius: 12))
         
         if place.favorite {
            Image(systemName: "heart.fill")
               .renderingMode(.template)
               .resizable()
               .foregroundStyle(.red)
               .frame(width: 12,height: 12)
               .padding(4)
         }
      }
   }

   var body: some View {
      HStack (alignment: .top) {
         placeImage()
         VStack (alignment: .leading){
            Text(place.title).bold()
            PlaceAddress(place:place)
            HStack {
               if let cat = place.category {
                  Chip(content: cat)
               }
               Image(systemName: "star.fill")
                  .resizable()
                  .frame(width: 14, height: 14)
                  .foregroundColor(Color.orange)
               Text("\(place.rating)").font(.caption2).bold()
               Spacer()
               if let date = place.visited {
                  let days = date.days(to: Date())
                  Text(days == 0 ? "Today" : "\(days) ago").font(.caption2)
               }
            }
         }
      }
   }
}

#Preview {
   let place = Place(
      title: "Berlin",
      favorite: true,
      visited: Date(),
      rating: 4
   )
   PlaceRow(place: place)
}

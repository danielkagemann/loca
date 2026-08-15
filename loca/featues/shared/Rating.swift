//
//  Rating.swift
//  myorders
//
//  Created by Daniel Kagemann on 14.08.23.
//

import SwiftUI

struct Rating: View {
   @Binding var rating: Int
   var size: Double = 18
   
   var maximumRating: Int = 5
   
   var offColor = Color.gray
   var onColor = Color.orange
     
   var body: some View {
      HStack (spacing: 2){
         ForEach(1..<maximumRating + 1, id: \.self) { number in
            Image(systemName: "star.fill")
               .resizable()
               .frame(width: size, height: size)
               .foregroundColor(number > rating ? offColor : onColor)
               .onTapGesture {
                  rating = number
               }
         }
      }
   }
}

#Preview {
   Rating(rating: .constant(3))
}

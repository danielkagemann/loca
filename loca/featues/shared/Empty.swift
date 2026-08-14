//
//  Empty.swift
//  loca
//
//  Created by Daniel Kagemann on 12.08.26.
//

import SwiftUI

struct Empty: View {
   // input
   let title: String
   let message: String
   let cta: String
   let action: () -> Void

   var body: some View {
      ContentUnavailableView {
         Image("empty")
            .resizable()
            .frame(width: 100, height: 100)
            .foregroundStyle(.secondary)
         Text(title)
            .font(.title2)
            .fontWeight(.semibold)
      } description: {
         Text(message)
      } actions: {
         Button(cta) {
            action()
         }
         .buttonStyle(.glassProminent)
      }
   }
}

#Preview {
   Empty(title: "no places", message: "there are no places available yet",cta: "+ add your first place") {}
}

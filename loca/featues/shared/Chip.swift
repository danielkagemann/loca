//
//  Chip.swift
//  loca
//
//  Created by Daniel Kagemann on 13.08.26.
//

import SwiftUI

struct Chip: View {
   // input
   let content: String
   
   var body: some View {
      Text(content)
         .padding(.horizontal, 8)
         .padding(.vertical, 3)
         .background(.accent.opacity(0.1))
         .foregroundStyle(.accent)
         .clipShape(RoundedRectangle(cornerRadius: 8))
         .font(.caption2)
         .bold()
   }
}

#Preview {
   Chip(content: "Cafe")
}

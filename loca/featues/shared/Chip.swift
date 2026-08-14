//
//  Chip.swift
//  loca
//
//  Created by Daniel Kagemann on 13.08.26.
//

import SwiftUI

enum ChipVariant: CaseIterable {
   case primary
   case black
   case outline
}

struct Chip: View {
   // input
   let content: String
   let variant: ChipVariant = .primary
   
   var fgColor: Color {
      switch variant {
      case .primary:
         return .white
      case .black:
         return .white
      case .outline:
         return .accent
      }
   }
   var bgColor: Color {
      switch variant {
      case .primary:
         return .accent
      case .black:
         return .black
      case .outline:
         return .clear
      }
   }

   var body: some View {
      Text(content)
         .padding(.horizontal, 6)
         .padding(.vertical, 2)
         .background(bgColor)
         .foregroundStyle(fgColor)
         .clipShape(.capsule)
         .font(.caption)
   }
}

#Preview {
   Chip(content: "Cafe")
}

//
//  ContentView.swift
//  loca
//
//  Created by Daniel Kagemann on 11.08.26.
//

import SwiftData
import SwiftUI

struct ContentView: View {
   var body: some View {
      NavigationStack {
         PlaceListView()
      }
   }
}

#Preview {
   ContentView()
}

//
//  PlaceAddress.swift
//  loca
//
//  Created by Daniel Kagemann on 16.08.26.
//

import SwiftUI

struct PlaceAddress: View {
   // env
   @Environment(\.openURL) private var openURL

   // input
   let place: Place
   let noAction: Bool

   init(place: Place, noAction: Bool = false) {
      self.place = place
      self.noAction = noAction
   }

   var body: some View {
      if place.address != nil {
         HStack {
            Image(systemName: "mappin.and.ellipse")
            Text((place.address ?? "").split(separator: "\n").joined(separator: ", ")).lineLimit(1)
         }
         .font(.caption)
         .foregroundStyle(.secondary)
         .onTapGesture {
            guard !noAction else { return }

            let lat = place.latitude ?? 0
            let long = place.longitude ?? 0
            let urlString = "http://maps.apple.com/?ll=\(lat),\(long)"

            if let url = URL(string: urlString) {
               openURL(url)
            }
         }
      }
   }
}

#Preview {
   PlaceAddress(place: .init(address: "1234\nFake St\nUnited States", latitude: 89.222, longitude: 12.333))
}

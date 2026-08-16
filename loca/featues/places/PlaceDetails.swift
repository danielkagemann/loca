//
//  PlaceDetails.swift
//  loca
//
//  Created by Daniel Kagemann on 15.08.26.
//

import MapKit
import SwiftData
import SwiftUI

struct PlaceDetails: View {
   // env
   @Environment(\.dismiss) var dismiss
   @Environment(\.modelContext) var modelContext

   // state
   @State private var showEdit: Bool = false

   // input
   var place: Place

   var body: some View {
      ScrollView {
         // image or placeholder
         ZStack(alignment: .bottomTrailing) {
            Group {
               if let data = place.image,
                  let uiImage = UIImage(data: data) {
                  Image(uiImage: uiImage)
                     .resizable()
                     .scaledToFill()
               } else {
                  Rectangle()
                     .fill(Color.gray)
               }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 200)

            HStack {
               Image(systemName: "chevron.left")
                  .padding(8)
                  .foregroundStyle(.white)
                  .background(.black.opacity(0.5))
                  .clipShape(Circle())
                  .onTapGesture {
                     dismiss()
                  }

               Spacer()
               Image(systemName: place.visited ? "person.fill" : "person")
                  .padding(8)
                  .foregroundStyle(place.visited ? .accent : .white)
                  .background(.black.opacity(0.5))
                  .clipShape(Circle())
                  .onTapGesture {
                     place.visited.toggle()
                  }

               Image(systemName: place.favorite ? "heart.fill" : "heart")
                  .padding(8)
                  .foregroundStyle(place.favorite ? .red : .white)
                  .background(.black.opacity(0.5))
                  .clipShape(Circle())
                  .onTapGesture {
                     place.favorite.toggle()
                  }
            }.padding(8)
         }

         VStack(alignment: .leading, spacing: 12) {
            // address
            if let addr = place.address {
               Text(addr).font(.caption).foregroundStyle(Color.secondary)
            }

            // rating + category
            HStack(spacing: 6) {
               Rating(rating: .constant(place.rating))
               if let cat = place.category {
                  Chip(content: cat)
               }
            }

            // website
            if let url = place.website {
               Text("Web \(url)").foregroundStyle(.accent)
            }

            // notes
            if let notes = place.notes {
               VStack(alignment: .leading) {
                  Text(notes).foregroundStyle(.secondary)
                     .alignLeft()
               }
               .frame(maxWidth: .infinity)
               .padding(8)
               .background(Color.gray.opacity(0.15))
               .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            // map
            if let latitude = place.latitude,
               let longitude = place.longitude {
               PlaceMap(
                  title: place.title,
                  latitude: latitude,
                  longitude: longitude
               )
            }

            // actions
            HStack {
               Button(action: {
                  modelContext.delete(place)
                  dismiss()
               }) {
                  HStack {
                     Image(systemName: "trash")
                     Text("Delete place")
                  }
               }
               .buttonStyle(.borderedProminent)
               .tint(.red)

               Button {
                  showEdit.toggle()
               } label: {
                  Text("Edit place")
                     .frame(maxWidth: .infinity)
               }
               .buttonStyle(.borderedProminent)
            }
            .font(.callout)

         }.padding(.horizontal, 16)
      }
      .navigationTitle(place.title)
      .navigationBarBackButtonHidden()
      .scrollIndicators(.hidden)
      .sheet(isPresented: $showEdit, content: {
         AddPlaceView(visible: $showEdit, reference: place)
      })
   }
}

private struct PlaceMap: View {
   let title: String
   let latitude: Double
   let longitude: Double

   private var coordinate: CLLocationCoordinate2D {
      CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
   }

   var body: some View {
      Map(initialPosition: .region(region)) {
         Marker(title, coordinate: coordinate)
      }
      .frame(height: 200)
      .clipShape(RoundedRectangle(cornerRadius: 12))
   }

   private var region: MKCoordinateRegion {
      MKCoordinateRegion(
         center: coordinate,
         span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
      )
   }
}

#Preview {
   NavigationStack {
      let place: Place = .init(
         title: "Goldstadt Padel",
         address: "Strietweg 90A, 75181 Pforzheim",
         latitude: 49.81,
         longitude: 8.65,
         notes: "Padelplatz mit tollen Aussichten",
         website: "https://padel.de"
      )
      PlaceDetails(place: place)
   }
}

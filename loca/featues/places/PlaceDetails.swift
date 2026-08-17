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
   @Environment(\.openURL) private var openURL

   // state
   @State private var showEdit: Bool = false
   @State private var showRelative: Bool = true

   // input
   var place: Place

   @ViewBuilder func Card(_ title: String, _ value: String) -> some View {
      VStack {
         Text(title)
            .bold()
            .font(.caption2)
            .alignLeft()
         Text(value)
            .font(.caption)
            .foregroundStyle(.secondary)
            .alignLeft().lineLimit(1)
      }
      .padding(8)
      .background(.accent.opacity(0.1))
      .clipShape(RoundedRectangle(cornerRadius: 8))
      .overlay(
         RoundedRectangle(cornerRadius: 8)
            .stroke(Color.accent.opacity(0.8), lineWidth: 1)
      )
   }

   func getVisitedDate() -> String {
      if let visited = place.visited {
         if showRelative {
            let days = visited.days(to: Date())
            if days == 0 {
               return "today"
            }
            return "\(days) days ago"
         }

         return visited.toFormat("dd.MM.yyyy")
      }
      return "---"
   }

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
            .clipped()

            HStack {
               Spacer()

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

         VStack(alignment: .leading) {
            // address
            PlaceAddress(place: place)

            // title
            Text(place.title).font(.title).bold()

            // rating + category
            HStack(spacing: 6) {
               Rating(rating: .constant(place.rating))
               if let cat = place.category {
                  Chip(content: cat)
               }
            }

            // website + last visit
            HStack(spacing: 8) {
               Card("Last visit", getVisitedDate()).onTapGesture {
                  showRelative.toggle()
               }
               Card("Website", place.website ?? "---")
                  .onTapGesture {
                     if let web = place.website, let url = URL(string: web) {
                        openURL(url)
                     }
                  }
            }

            // notes
            if let notes = place.notes {
               if !notes.isEmpty {
                  Text(notes).foregroundStyle(.secondary).padding(.top,8)
                     .alignLeft()
               }
            }

            // map
            if let latitude = place.latitude,
               let longitude = place.longitude {
               PlaceMap(
                  title: place.title,
                  latitude: latitude,
                  longitude: longitude
               )
               .padding(.top,8)
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
            .padding(.top, 16)
            .font(.callout)

         }.padding(.horizontal, 16)
      }
      .navigationTitle(place.title)
      .navigationBarTitleDisplayMode(.inline)
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
      PlaceDetails(place: PreviewData.samplePlace)
   }
   .modelContainer(PreviewData.container)
}

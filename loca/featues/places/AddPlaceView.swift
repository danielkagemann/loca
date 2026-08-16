import MapKit
import SwiftData
import SwiftUI

struct AddPlaceView: View {
   // env
   @Environment(\.modelContext) private var modelContext

   // input
   @Binding var visible: Bool
   var reference: Place? = nil

   // state
   @State private var place: Place = .init()
   @State private var isVisited: Bool = false

   @State private var searchText: String = ""
   @State private var searchResults: [MKMapItem] = []
   @State private var showImage: Bool = false
   @State private var showCamera: Bool = false

   @ViewBuilder fileprivate func renderSearchItem(_ item: MKMapItem) -> some View {
      VStack(alignment: .leading, spacing: 2) {
         Text(item.name ?? "Unknown")
            .font(.body).bold()
         Text(item.address?.fullAddress ?? "no address").font(.caption)
         if let category = item.pointOfInterestCategory {
            Chip(content: category.displayName)
         }
      }
      .onTapGesture {
         place.address = item.address?.fullAddress
         place.title = item.name ?? place.title
         place.category = item.pointOfInterestCategory?.displayName
         place.latitude = item.location.coordinate.latitude
         place.longitude = item.location.coordinate.longitude
         place.website = item.url?.absoluteString ?? place.website

         searchResults.removeAll()
      }
   }

   @ViewBuilder fileprivate func sectionSearch() -> some View {
      if !place.hasValidCoordinates() {
         Section("Search the place") {
            Text("Enter the address or the name of the place and select from the suggestions").font(.callout).foregroundStyle(.secondary)
            TextField("Name of the place or address...", text: $searchText)
               .textInputAutocapitalization(.words)
               .autocorrectionDisabled()
               .onChange(of: searchText) { _, newValue in
                  performSearch(query: newValue)
               }

         }
         
         if !searchResults.isEmpty {
            Section ("Found places") {
               List {
                  ForEach(Array(searchResults.prefix(5).enumerated()), id: \.offset) { _, item in
                     renderSearchItem(item)
                  }
               }
            }
         }
      }
   }

   @ViewBuilder fileprivate func RowItem<Content: View>(
      _ title: String,
      @ViewBuilder content: () -> Content
   ) -> some View {
      HStack {
         Text(title).foregroundStyle(.secondary)
         Spacer()
         content()
      }
   }

   @ViewBuilder func sectionImage() -> some View {
      Section {
         ZStack(alignment: .topTrailing) {
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

            HStack(spacing: 12) {
               Image(systemName: "photo")
                  .onTapGesture {
                     showImage = true
                  }
               Image(systemName: "camera")
                  .onTapGesture {
                     showCamera = true
                  }

               if let pbImage = UIPasteboard.general.image {
                  Image(systemName: "document.on.clipboard")
                     .onTapGesture {
                        let raw = pbImage.compressImage()!
                        place.image = raw
                     }
               }

               if place.image != nil {
                  Image(systemName: "trash")
                     .onTapGesture {
                        place.image = nil
                     }
               }
            }
            .font(.system(size: 18, weight: .semibold))
            .padding(10)
            .background(.ultraThinMaterial)
            .clipShape(Capsule())
            .padding(12)
         }
         .listRowInsets(EdgeInsets())
      }
   }

   var body: some View {
      NavigationStack {
         Form {
            sectionSearch()

            if place.hasValidCoordinates() {
               sectionImage()

               Section("Details") {
                  RowItem("Title") {
                     TextField("Name",
                               text: $place.title).multilineTextAlignment(.trailing)
                        .font(.callout)
                  }
                  RowItem("Address") {
                     Text(place.address ?? "")
                        .multilineTextAlignment(.trailing)
                        .font(.callout)
                  }
               }
               
               Section("Notes") {
                  TextField("", text: Binding(
                     get: { place.notes ?? "" },
                     set: { place.notes = $0 }))
               }

               Section("Information") {
                  RowItem("Category") {
                     Picker("", selection: Binding(
                        get: { place.category ?? "" },
                        set: { place.category = $0 }
                     )) {
                        ForEach(MKPointOfInterestCategory.getAllCategories(), id: \.self) {
                           Text($0)
                              .tag($0)
                        }
                     }
                     .pickerStyle(.navigationLink)
                  }
                  RowItem("Favorite") {
                     Toggle("", isOn: $place.favorite)
                  }
                  RowItem("Rating") {
                     Rating(rating: $place.rating)
                  }
                  RowItem("Website") {
                     TextField("URL", text: Binding(
                        get: { place.website ?? "" },
                        set: { place.website = $0 }
                     ))
                     .multilineTextAlignment(.trailing)
                     .font(.callout)
                  }
                  RowItem("Visited") {
                     Toggle("", isOn: $isVisited)
                  }
                  if isVisited {
                     DatePicker("", selection: Binding(
                        get: { place.visited ?? Date() },
                        set: { place.visited = $0 }),
                     displayedComponents: .date)
                        .datePickerStyle(.wheel)
                  }
               }
            }
         }
         .navigationTitle(reference == nil ? "Add new place" : "Edit place")
         .navigationBarTitleDisplayMode(.inline)
         .toolbar {
            ToolbarItem(placement: .topBarLeading, content: {
               Button("Cancel") {
                  visible = false
               }
            })
            ToolbarItem(placement: .topBarTrailing, content: {
               Button("Save") {
                  if reference != nil {
                     reference!.title = self.place.title
                     reference!.image = self.place.image
                     reference!.website = self.place.website
                     reference!.address = self.place.address
                     reference!.favorite = self.place.favorite
                     reference!.visited = self.place.visited
                     reference!.category = self.place.category
                     reference!.latitude = self.place.latitude
                     reference!.longitude = self.place.longitude
                     reference!.notes = self.place.notes
                     reference!.rating = self.place.rating
                  } else {
                     modelContext.insert(place)
                  }

                  visible = false
               }
            })
         }
         .sheet(isPresented: $showCamera) {
            CameraView { outImage in
               let raw = outImage.compressImage()!
               place.image = raw
            }
         }
         .sheet(isPresented: $showImage) {
            CustomImagePicker { metadata in
               if let outImage = metadata.image {
                  let raw = outImage.compressImage()!
                  place.image = raw
               }
            }
         }
      }
      .onAppear {
         if reference != nil {
            // copy from reference to place
            self.place.title = reference?.title ?? ""
            self.place.image = reference?.image
            self.place.website = reference?.website
            self.place.address = reference?.address
            self.place.favorite = reference?.favorite ?? false
            if reference?.visited != nil {
               self.isVisited = true
            } else {
               self.isVisited = false
            }
            self.place.visited = reference?.visited
            self.place.category = reference?.category
            self.place.latitude = reference?.latitude
            self.place.longitude = reference?.longitude
            self.place.notes = reference?.notes
            self.place.rating = reference?.rating ?? 0
         }
      }
   }

   private func performSearch(query: String) {
      let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)

      guard !trimmed.isEmpty else {
         searchResults = []
         return
      }
      let request = MKLocalSearch.Request()
      request.naturalLanguageQuery = trimmed
      let search = MKLocalSearch(request: request)
      search.start { response, _ in
         DispatchQueue.main.async {
            if let items = response?.mapItems {
               self.searchResults = items
            } else {
               self.searchResults = []
            }
         }
      }
   }
}

#Preview {
   AddPlaceView(visible: .constant(true))
}

//
//  ImagePicker.swift
//  laiba
//
//  Created by Daniel Kagemann on 19.11.23.
//

import SwiftUI
import PhotosUI

struct CustomImagePickerData {
   var image: UIImage?
   var date: Date?
   var location: CLLocationCoordinate2D?
}

struct CustomImagePicker: UIViewControllerRepresentable {
   
   var action: (CustomImagePickerData) -> Void
   
   @Environment(\.presentationMode) var presentationMode
   
   func makeUIViewController(context: Context) -> PHPickerViewController {
      var config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
      config.filter = .images
      config.selectionLimit = 1
      let controller = PHPickerViewController(configuration: config)
      controller.delegate = context.coordinator
      return controller
   }
   
   func makeCoordinator() -> CustomImagePicker.Coordinator {
      return Coordinator(self)
   }
   
   
   func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
   }
   
   class Coordinator: PHPickerViewControllerDelegate {
      func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
         parent.presentationMode.wrappedValue.dismiss()
         guard !results.isEmpty else {
            return
         }
         
         let imageResult = results[0]
         
         if imageResult.itemProvider.canLoadObject(ofClass: UIImage.self) {
            imageResult.itemProvider.loadObject(ofClass: UIImage.self) { (selectedImage, error) in
               if let error = error {
                  print(error.localizedDescription)
               } else {
                  
                  // we have an image so continue
                  var response: CustomImagePickerData = .init(image: selectedImage as? UIImage)
                  
                  if let assetId = imageResult.assetIdentifier {
                     let assetResults = PHAsset.fetchAssets(withLocalIdentifiers: [assetId], options: nil)
                     
                     response.date = assetResults.firstObject?.creationDate
                     response.location = assetResults.firstObject?.location?.coordinate
                  }
                  
                  DispatchQueue.main.async {
                     self.parent.action(response)
                  }
               }
            }
         }
      }
      
      private let parent: CustomImagePicker
      init(_ parent: CustomImagePicker) {
         self.parent = parent
      }
   }
}

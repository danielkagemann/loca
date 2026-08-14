//
//  CameraView.swift
//  laiba
//
//  Created by Daniel Kagemann on 16.01.23.
//
import UIKit
import SwiftUI

class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
   var picker: CameraView
   
   init(picker: CameraView) {
      self.picker = picker
   }
   
   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
      guard let selectedImage = info[.originalImage] as? UIImage else { return }
      self.picker.action (selectedImage)
      self.picker.isPresented.wrappedValue.dismiss()
   }
}

struct CameraView: UIViewControllerRepresentable {
   
   var action: (UIImage) -> Void
   
   @Environment(\.presentationMode) var isPresented
   
   func makeUIViewController(context: Context) -> UIImagePickerController {
      let imagePicker = UIImagePickerController()
      imagePicker.sourceType = .camera
      imagePicker.delegate = context.coordinator // confirming the delegate
      return imagePicker
   }
   
   func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
      
   }
   
   // Connecting the Coordinator class with this struct
   func makeCoordinator() -> Coordinator {
      return Coordinator(picker: self)
   }
}

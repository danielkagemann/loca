//
//  Extensions.swift
//  morements
//
//  Created by Daniel Kagemann on 18.01.23.
//

import SwiftUI
import Combine

extension UIImage {
   func aspectFittedToWidth(_ newWidth: CGFloat) -> UIImage {
      let scale = newWidth / self.size.width
      let newHeight = self.size.height * scale
      let newSize = CGSize(width: newWidth, height: newHeight)
      let renderer = UIGraphicsImageRenderer(size: newSize)
      
      return renderer.image { _ in
         self.draw(in: CGRect(origin: .zero, size: newSize))
      }
   }
   
   func compressImage() -> Data? {
      let resizedImage = self.aspectFittedToWidth(400)
      return resizedImage.jpegData(compressionQuality: 0.8)
   }
   
   func fixOrientation() -> UIImage {
         if self.imageOrientation == UIImage.Orientation.up {
            return self
         }
         
         UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
         
         self.draw(in: CGRectMake(0, 0, self.size.width, self.size.height))
         
         let normalizedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
         
         UIGraphicsEndImageContext()
         
         return normalizedImage;
         
      }
}


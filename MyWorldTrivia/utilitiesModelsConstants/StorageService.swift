//
//  StorageService.swift
//  MyIOSWhatsappCloneChat
//
//  Created by pc on 14/08/2019.
//  Copyright © 2019 yonsProject. All rights reserved.
//

import Foundation
import FirebaseStorage
import Firebase



struct StorageService {
    
    static func uploadImage(_ image: UIImage, at reference: StorageReference, completion: @escaping (URL?) -> Void) {
        // 1 First we change the image from an UIImage to Data and reduce the quality of the image. It is important to reduce the quality of the image because otherwise the images will take a long time to upload and download from Firebase Storage. If we can't convert the image into Data, we return nil to the completion callback to signal something went wrong.
        guard let imageData = image.jpegData(compressionQuality: 0.1) else {
            return completion(nil)
        }
        
        // 2 We upload our media data to the path provided as a parameter to the method.
        reference.putData(imageData, metadata: nil, completion: { (metadata, error) in
            // 3 After the upload completes, we check if there was an error. If there is an error, we return nil to our completion closure to signal there was an error. Our assertFailure will crash the app and print the error when we're running in debug mode.
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }
            
            // 4 If everything was successful, call downloadURL to get a URL reference and return it to the completion handler.
            reference.downloadURL(completion: { (url, error) in
                if let error = error {
                    assertionFailure(error.localizedDescription)
                    return completion(nil)
                }
                completion(url)
            })
        })
    }
    
    
    
    
}

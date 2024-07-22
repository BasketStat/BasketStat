//
//  FirebaseService.swift
//  BasketStat_UIKit
//
//  Created by 양승완 on 7/19/24.
//

import Foundation
import Firebase
import FirebaseStorage
import RxSwift
final class FirebaseService {
    
    let shared = FirebaseService()

    func uploadImage(imageData: Data?, pathRoot: String ) -> Single<String> {
        return Single.create { single in
            guard let imageData = imageData else {
                single(.success(""))
                return Disposables.create()  }
            
            
            let metaData = StorageMetadata()
            
            metaData.contentType = "image/jpeg"
            
            let imageName = UUID().uuidString + String(Date().timeIntervalSince1970)
            
            let firebaseReference = Storage.storage().reference().child("\(pathRoot)/\(imageName)")
            
            
            firebaseReference.putData(imageData, metadata: metaData) { _, _ in
                firebaseReference.downloadURL { url, _ in
                    single(.success(url?.absoluteString ?? ""))
                }
            }
            
            return Disposables.create()
        }
    }
}

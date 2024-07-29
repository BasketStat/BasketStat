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
    
    let db = Firestore.firestore()
    
    func getPlayer() -> Single<PlayerModel> {
        
        Single.create { single in
            
            guard let uid = UserDefaults.standard.string(forKey: "uid") else { return Disposables.create() }
            self.db.collection("Players").document(uid).getDocument { doc, err in
                
                if let err {
                    single(.failure(err))
                } else {
                    
                    if let data = doc?.data() {
                        do {
                            let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                            let playerModel = try JSONDecoder().decode(PlayerModel.self, from: jsonData)
                            single(.success(playerModel))
                        } catch {
                            
                            single(.failure(CustomError.CustomNil))
                        }
                        
                    }
                 

                }
               
                    
                }
            
            return Disposables.create()
        }
        
    }
    
    
    
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
    
    func signInCredential(credential: OAuthCredential) -> Completable {
        return Completable.create { com in
            Auth.auth().signIn(with: credential){ (authResult, error) in
                if let error {
                    // Error. If error.code == .MissingOrInvalidNonce, make sure
                    // you're sending the SHA256-hashed nonce as a hex string with
                    // your request to Apple.
                    print(error.localizedDescription)
                    com(.error(error))
                    
                    
                    return
                } else {
                    UserDefaults.standard.set(authResult?.user.uid, forKey: "uid")
                    
                    com(.completed)
                    
                }
            }
            
            
            return Disposables.create()
            
        }
    }
    
    func signIn(email: String, password: String) -> Completable {
        
        return Completable.create { com in
            
            Auth.auth().createUser(withEmail: email, password: password, completion: { _, error in
                
                Auth.auth().signIn(withEmail: email, password: password){ (authResult, error) in
                    if let error {
                        com(.error(error))
                        return
                    }else {
                        UserDefaults.standard.set(authResult?.user.uid, forKey: "uid")
                        
                        com(.completed)
                    }
                }
                
            })
            
            
            
            
            
            return Disposables.create()
            
        }
    }
    
    
}

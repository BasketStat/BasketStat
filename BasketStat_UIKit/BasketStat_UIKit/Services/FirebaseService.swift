//
//  FirebaseService.swift
//  BasketStat_UIKit
//
//  Created by 양승완 on 7/19/24.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseStorage
import RxSwift

protocol FirebaseServiceProtocol {
    func getPlayer() -> Single<PlayerModel>
    func uploadImage(imageData: Data?, pathRoot: String) -> Single<String>
    func signInCredential(credential: AuthCredential) -> Completable
    func signIn(email: String, password: String) -> Completable
    func setPlayer(playerModel: PlayerModel) -> Completable
    func signOut() -> Completable
}

final class FirebaseService: BaseService, FirebaseServiceProtocol {
  
    
    let db = Firestore.firestore()
    var disposeBag = DisposeBag()
    
  
    
    
    func getPlayer() -> Single<PlayerModel> {
        
        Single.create { single in
            guard let uid = UserDefaults.standard.string(forKey: "uid") else {
                return Disposables.create() }
            self.db.collection("BasketStat_Player").document(uid).getDocument { doc, err in
                
                if let err {
                    single(.failure(err))
                } else {
                    
                    if let data = doc?.data() {
                        do {
                            let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                            let playerDto = try JSONDecoder().decode(PlayerDto.self, from: jsonData)
                            
                            single(.success(playerDto.getModel()))
                        } catch {
                            print("catch")
                            single(.failure(CustomError.CustomNil))
                        }
                        
                    } else {
                        print("else")
                        single(.failure(CustomError.CustomNil))
                        
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
            
            let path = pathRoot + "/" + "profile"
            
            let metaData = StorageMetadata()
            
            metaData.contentType = "image/jpeg"
            
            let imageName = UUID().uuidString + String(Date().timeIntervalSince1970)
            
            let firebaseReference = Storage.storage().reference().child("\(path)/\(imageName)")
            
            
            firebaseReference.putData(imageData, metadata: metaData) { _, err in
                if let err {
                    single(.success(""))
                    return
                } else {
                    
                    firebaseReference.downloadURL { url, err in
                        if err != nil {
                            single(.success(""))
                            return
                            
                        } else {
                            print("성공")
                            print("\(url?.absoluteString ?? "") url")
                            single(.success(url?.absoluteString ?? ""))
                            
                        }
                    }
                }
            }
            
            return Disposables.create()
        }
    }
    
    func signInCredential(credential: AuthCredential) -> Completable {
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
                    } else {
                        UserDefaults.standard.set(authResult?.user.uid, forKey: "uid")
                        
                        com(.completed)
                    }
                }
                
            })
            
            
            
            
            
            return Disposables.create()
            
        }
    }
    
    func setStore(playerDto: PlayerDto, uid: String) -> Completable {
        
        Completable.create { com in
            
            print(playerDto.profileImageUrl)
            guard let playerDto = playerDto.toDictionary else {return Disposables.create()}
            do {
                self.db.collection("BasketStat_Player").document("\(uid)").setData(playerDto)
                com(.completed)
                
            } catch let error {
                print("Error writing city to Firestore: \(error)")
                com(.error(error))
            }
            return Disposables.create()
        }
        
        
        
    }
    
    
    func setPlayer(playerModel: PlayerModel) -> Completable {
     
        var playerDto = playerModel.getDto(profileImageUrl: "")
        
        // 이미지 데이터를 준비합니다.
        let data = playerModel.profileImage?.jpegData(compressionQuality: 0.9)
        
        // 이미지를 업로드하고 URL을 받아 설정합니다.
        
        
        return self.uploadImage(imageData: data, pathRoot: playerModel.playerUid)
            .flatMapCompletable { url in
                playerDto.profileImageUrl = url
                return self.setStore(playerDto: playerDto, uid: playerModel.playerUid)
            }
    }
    
    
    func signOut() -> Completable {
        
        return Completable.create { com in
            if Auth.auth().currentUser != nil {
                
                // <- Firebase Auth
                let firebaseAuth = Auth.auth()
                do {
                    try firebaseAuth.signOut()
                    com(.completed)
                } catch let signOutError as NSError {
                    print("Error signing out: %@", signOutError)
                    com(.error(signOutError))
                }
            }
            
            return Disposables.create()
        }
        
    }
    
    
}

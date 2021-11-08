//
//  SaveImageManager.swift
//  A Selfie Every Day
//
//  Created by canella riccardo on 08/11/21.
//

import Foundation
import Photos
import SwiftUI

import Foundation
import Photos


class SaveImageManager: NSObject {
    static let albumName = "ASelfieEveryDay"
    static let instance = SaveImageManager()

    private var assetCollection: PHAssetCollection!

    private override init() {
       super.init()

       if let assetCollection = fetchAssetCollectionForAlbum() {
           self.assetCollection = assetCollection
           return
       }
    }

    private func checkAuthorizationWithHandler(completion: @escaping ((_ success: Bool) -> Void)) {
       if PHPhotoLibrary.authorizationStatus() == .notDetermined {
           PHPhotoLibrary.requestAuthorization({ (status) in
               self.checkAuthorizationWithHandler(completion: completion)
           })
       }
       else if PHPhotoLibrary.authorizationStatus() == .authorized {
           self.createAlbumIfNeeded()
           completion(true)
       }
       else {
           completion(false)
       }
    }

    private func createAlbumIfNeeded() {
       if let assetCollection = fetchAssetCollectionForAlbum() {
           // Album already exists
           self.assetCollection = assetCollection
       } else {
           PHPhotoLibrary.shared().performChanges({
               PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: SaveImageManager.albumName)   // create an asset collection with the album name
           }) { success, error in
               if success {
                   self.assetCollection = self.fetchAssetCollectionForAlbum()
               } else {
                   // Unable to create album
               }
           }
       }
    }

    private func fetchAssetCollectionForAlbum() -> PHAssetCollection? {
       let fetchOptions = PHFetchOptions()
       fetchOptions.predicate = NSPredicate(format: "title = %@", SaveImageManager.albumName)
       let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)

       if let _: AnyObject = collection.firstObject {
           return collection.firstObject
       }
       return nil
    }

    func save(image: UIImage) {
       self.checkAuthorizationWithHandler { (success) in
           if success, self.assetCollection != nil {
               PHPhotoLibrary.shared().performChanges({
                   let assetChangeRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
                   let assetPlaceHolder = assetChangeRequest.placeholderForCreatedAsset
                   let albumChangeRequest = PHAssetCollectionChangeRequest(for: self.assetCollection)
                   let enumeration: NSArray = [assetPlaceHolder!]
                   albumChangeRequest!.addAssets(enumeration)

               }, completionHandler: nil)
           }
       }
    }
}


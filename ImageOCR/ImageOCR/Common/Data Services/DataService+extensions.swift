//  DataService+extensions.swift
//  Created by Krzysztof Lech on 11/01/2023.

import CoreData
import UIKit

protocol ImageDataServiceProtocol {
    var images: [CDImage] { get }
    func createImage(name: String?, imageData: Data, text: String?) -> CDImage
    func deleteImage(_ image: CDImage)
    func deleteAllImages()
    func saveChanges()
}

extension DataService: ImageDataServiceProtocol {
    var images: [CDImage] {
        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: true)
        let images: [CDImage] = fetch(sortDescriptors: [sortDescriptor])
        print("CoreDataService: All images:", images.count)
        return images
    }

    func createImage(name: String?, imageData: Data, text: String?) -> CDImage {
        let image = CDImage(context: context)
        image.id = UUID().uuidString
        image.name = name
        image.data = imageData
        image.text = text
        image.createdAt = Date()

        saveContext()
        print("CoreDataService: Image added!")

        return image
    }

    func deleteImage(_ image: CDImage) {
        delete(image)
        print("CoreDataService: Image deleted!")
    }

    func deleteAllImages() {
        images.forEach { delete($0) }
        print("CoreDataService: All images deleted!")
    }

    func saveChanges() {
        saveContext()
    }
}

// Preview
extension DataService {
    static let preview: ImageDataServiceProtocol = {
        let dataService: ImageDataServiceProtocol = DataService(inMemory: true)
        if let image = UIImage(named: "TestImage"), let imageData = image.jpegData(compressionQuality: 0.9) {
            _ = dataService.createImage(name: "Test image", imageData: imageData, text: "Recognised text")
        }
        return dataService
    }()

    static let previewItem: CDImageViewModel = {
        let cdImage = DataService.preview.images.first!
        return CDImageViewModel(cdImage: cdImage)
    }()
}

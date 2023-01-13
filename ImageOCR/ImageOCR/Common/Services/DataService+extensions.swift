//  DataService+extensions.swift
//  Created by Krzysztof Lech on 11/01/2023.

import CoreData

protocol ImageDataServiceProtocol {
    var images: [CDImage] { get }
    func createImage(name: String?, imageData: Data) -> CDImage
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

    func createImage(name: String?, imageData: Data) -> CDImage {
        let image = CDImage(context: context)
        image.id = UUID().uuidString
        image.name = name
        image.data = imageData
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

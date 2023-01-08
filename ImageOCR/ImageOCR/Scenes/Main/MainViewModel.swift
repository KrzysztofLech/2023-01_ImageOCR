//  MainViewModel.swift
//  Created by Krzysztof Lech on 07/01/2023.

import PhotosUI
import SwiftUI

class MainViewModel: ObservableObject {
    let screenTitle = Strings.MainView.title
    @Published var images: [OcrImage] = []

    // MARK: - Photos Picker methods -

    @Published var imageSelection: PhotosPickerItem? {
        didSet {
            if let imageSelection {
                Task {
                    try await loadTransferable(from: imageSelection)
                }
            }
        }
    }

    private func loadTransferable(from imageSelection: PhotosPickerItem) async throws {
        do {
            if let data = try await imageSelection.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                let ocrImage = OcrImage(with: image)

                DispatchQueue.main.async { [weak self] in
                    self?.images.append(ocrImage)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    // MARK: - Camera Picker methods -

    @Published var isCameraPickerPresented = false
    @Published var selectedPhoto: UIImage? {
        didSet {
            if let selectedPhoto {
                addPhoto(selectedPhoto)
            }
        }
    }

    private func addPhoto(_ photo: UIImage) {
        let ocrImage = OcrImage(with: photo)
        images.append(ocrImage)
    }
}

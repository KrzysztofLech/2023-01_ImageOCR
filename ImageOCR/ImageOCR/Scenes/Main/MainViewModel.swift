//  MainViewModel.swift
//  Created by Krzysztof Lech on 07/01/2023.

import PhotosUI
import SwiftUI

class MainViewModel: ObservableObject {
    private var dataService: ImageDataServiceProtocol
    private let textRecognitionService: TextRecognitionServiceProtocol?

    init(dataService: ImageDataServiceProtocol, textRecognitionService: TextRecognitionServiceProtocol?) {
        self.dataService = dataService
        self.textRecognitionService = textRecognitionService

        let images = dataService.images
        self.images = images.map { CDImageViewModel(cdImage: $0) }
    }

    let screenTitle = Strings.MainView.title
    @Published var images: [CDImageViewModel] = []

    // MARK: - Data methods -

    private func createNewImage(with data: Data) {
        let image = dataService.createImage(name: "No title", imageData: data, text: nil)
        let imageViewModel = CDImageViewModel(cdImage: image)
        images.append(imageViewModel)
    }

    internal func saveNewName(_ name: String, itemId: String) {
        images.first(where: { $0.id == itemId })?.name = name

        objectWillChange.send()
        dataService.saveChanges()
    }

    private func saveRecognisedText(_ text: String, itemId: String) {
        images.first(where: { $0.id == itemId })?.text = text

        objectWillChange.send()
        dataService.saveChanges()
    }

    func delete(_ item: CDImageViewModel) {
        dataService.deleteImage(item.cdImage)
        images.removeAll(where: { $0.id == item.id })
    }

    func removeRecognisedText(_ item: CDImageViewModel) {
        item.text = ""
        objectWillChange.send()
        dataService.saveChanges()
    }

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
            if let data = try await imageSelection.loadTransferable(type: Data.self) {
                DispatchQueue.main.async { [weak self] in
                    self?.createNewImage(with: data)
                }
            }
        } catch {
            Logger.log(error: error.localizedDescription)
        }
    }

    // MARK: - Camera Picker methods -

    @Published var isCameraPickerPresented = false
    @Published var cameraPickerSelectedPhoto: UIImage? {
        didSet {
            if let cameraPickerSelectedPhoto, let imageData = cameraPickerSelectedPhoto.jpegData(compressionQuality: 0.9) {
                createNewImage(with: imageData)
            }
        }
    }

    // MARK: - OCR methods -

    @Published var isRecognising = false

    func recogniseTextFromImage(withId id: String) {
        isRecognising = true

        guard let image = images.first(where: { $0.id == id })?.image else { return }

        textRecognitionService?.recogniseTextFromImage(image) { [weak self] recognisedText in
            DispatchQueue.main.async {
                self?.isRecognising = false

                if let recognisedText, !recognisedText.isEmpty {
                    Logger.log(info: "Recognised text:\n\(recognisedText)")
                    self?.saveRecognisedText(recognisedText, itemId: id)
                } else {
                    Logger.log(error: "No recognised text!")
                }
            }
        }
    }
}

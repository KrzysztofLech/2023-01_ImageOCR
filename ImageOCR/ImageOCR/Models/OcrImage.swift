//  OcrImage.swift
//  Created by Krzysztof Lech on 07/01/2023.

import SwiftUI

struct OcrImage: Identifiable {
    let id: String
    let image: Image
    var name: String?
    var recognizedText: String?

    init(with image: UIImage) {
        self.id = UUID().uuidString
        self.image = Image(uiImage: image)
    }
}

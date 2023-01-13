//  CDImageViewModel.swift
//  Created by Krzysztof Lech on 07/01/2023.

import UIKit

struct CDImageViewModel: Identifiable {
    let cdImage: CDImage

    init(cdImage: CDImage) {
        self.cdImage = cdImage
    }

    var id: String {
        cdImage.id ?? ""
    }

    var name: String {
        cdImage.name ?? Strings.MainView.noImageNameText
    }

    var image: UIImage {
        guard let data = cdImage.data, let image = UIImage(data: data) else { return UIImage() }
        return image
    }

    var createdAt: Date {
        cdImage.createdAt ?? Date()
    }

    var text: String {
        get {
            cdImage.text ?? Strings.MainView.noRecognizedText
        }
        set {
            cdImage.text = newValue
        }
    }
}

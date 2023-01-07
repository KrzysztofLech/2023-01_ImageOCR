//  MainViewItemView.swift
//  Created by Krzysztof Lech on 07/01/2023.

import SwiftUI

struct MainViewItemView: View {
    let item: OcrImage

    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            item.image
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .border(.gray, width: 1)

            Text(item.name ?? "No title")
                .fontWeight(.light)

            Spacer()
        }
    }
}

struct MainViewItemView_Previews: PreviewProvider {
    private static let ocrImage: OcrImage = {
        let image = UIImage(named: "test_image_1") ?? UIImage()
        var ocrImage = OcrImage(with: image)
        ocrImage.name = "test image 1"
        return ocrImage
    }()

    static var previews: some View {
        MainViewItemView(item: ocrImage)
            .previewLayout(.sizeThatFits)
    }
}

//  ImageDetailsView.swift
//  Created by Krzysztof Lech on 13/01/2023.

import SwiftUI

struct ImageDetailsView: View {
    @EnvironmentObject var viewModel: MainViewModel
    let item: CDImageViewModel

    @State private var name: String
    @FocusState private var isTextFieldFocused: Bool

    init(image: CDImageViewModel) {
        self.item = image
        self.name = image.name
    }

    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            Image(uiImage: item.image)
                .resizable()
                .scaledToFit()
                .padding(.horizontal, 64)

            TextField("", text: $name)
                .font(.system(size: 28, weight: .thin))
                .multilineTextAlignment(.center)
                .focused($isTextFieldFocused)

            Spacer()
        }
        .onChange(of: isTextFieldFocused) { isFocused in
            guard !isFocused else { return }
            viewModel.setupNewName(name, itemId: item.id)
        }
    }
}

//struct ImageDetailsView_Previews: PreviewProvider {
//    @State private static var viewModel = MainViewModel(dataService: DataService())
//    static var previews: some View {
//        ImageDetailsView()
//            .environmentObject(viewModel)
//    }
//}

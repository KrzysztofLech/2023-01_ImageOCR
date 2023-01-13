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
            // Image
            Image(uiImage: item.image)
                .resizable()
                .scaledToFit()
                .padding(.horizontal, 64)

            Group {
                // Image name
                TextField("", text: $name)
                    .font(.system(size: 28, weight: .thin))
                    .multilineTextAlignment(.center)
                    .focused($isTextFieldFocused)

                if item.text.isEmpty {
                    // Recognise button
                    Button(
                        action: {
                            viewModel.recogniseTextFromImage(withId: item.id)
                        },
                        label: {
                            Text(Strings.DetailsView.recogniseButtonTitle)
                                .padding(8)
                        }
                    ).buttonStyle(.borderedProminent)
                } else {
                    // Recognised text
                    Text(item.text)
                        .font(.system(size: 18, weight: .regular))
                        .lineLimit(0)
                }
            }.padding(.horizontal, 32)

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

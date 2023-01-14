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
                            ZStack {
                                if viewModel.isRecognising {
                                    ProgressView().tint(.blue)
                                }
                                Text(Strings.DetailsView.recogniseButtonTitle)
                                    .padding(8)
                                    .foregroundColor(viewModel.isRecognising ? .clear : .white)
                            }
                        }
                    )
                    .buttonStyle(.borderedProminent)
                    .disabled(viewModel.isRecognising)
                } else {
                    // Recognised text
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(Strings.DetailsView.recognisedTextTitle)
                                .font(.system(size: 12))
                            Spacer()
                        }

                        HStack {
                            Text(item.text)
                                .font(.system(size: 18, weight: .regular))
                                .padding(8)
                            Spacer(minLength: 0)
                        }
                        .background {
                            RoundedRectangle(cornerRadius: 4).stroke(.gray, lineWidth: 1)
                        }
                    }
                }
            }
            .padding(.horizontal, 32)

            Spacer()
        }
        .onChange(of: isTextFieldFocused) { isFocused in
            guard !isFocused else { return }
            viewModel.saveNewName(name, itemId: item.id)
        }
    }
}

struct ImageDetailsView_Previews: PreviewProvider {
    @State private static var viewModel = MainViewModel(dataService: DataService.preview)
    static var previews: some View {
        ImageDetailsView(image: DataService.previewItem)
            .environmentObject(viewModel)
    }
}

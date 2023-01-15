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
        ScrollView(.vertical, showsIndicators: false) {
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
                        contentWithNoRecognisedText
                    } else {
                        // Recognised text and reset button
                        contentWithRecognisedText
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

    private var contentWithNoRecognisedText: some View {
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
    }

    private var contentWithRecognisedText: some View {
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

            Button(
                action: {
                    viewModel.removeRecognisedText(item)
                },
                label: {
                    HStack {
                        Spacer()

                        Text(Strings.DetailsView.clearText)
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.red)
                            .padding(8)

                        Spacer()
                    }
                }
            )
        }
    }
}

struct ImageDetailsView_Previews: PreviewProvider {
    @State private static var viewModel = MainViewModel(
        dataService: DataService.preview,
        textRecognitionService: nil
    )
    static var previews: some View {
        ImageDetailsView(image: DataService.previewItem)
            .environmentObject(viewModel)
    }
}

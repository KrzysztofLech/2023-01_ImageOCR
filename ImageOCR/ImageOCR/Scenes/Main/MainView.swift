//  ContentView.swift
//  Created by Krzysztof Lech on 06/01/2023.

import PhotosUI
import SwiftUI

struct MainView: View {
    @EnvironmentObject var viewModel: MainViewModel

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.images.isEmpty {
                    Text(Strings.MainView.noImagesText)
                        .font(.system(size: 28, weight: .thin))
                } else {
                    List(viewModel.images) { item in
                        NavigationLink(
                            destination: ImageDetailsView(image: item),
                            label: {
                                listItemView(item: item)
                            }
                        )
                    }
                }
            }
            .navigationTitle(viewModel.screenTitle)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    PhotosPicker(
                        selection: $viewModel.imageSelection,
                        matching: .images,
                        label: {
                            Image(systemName: "photo")
                                .imageScale(.large)
                        }
                    )
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(
                        action: {
                            viewModel.isCameraPickerPresented = true
                        },
                        label: {
                            Image(systemName: "camera.fill")
                                .imageScale(.large)
                        }
                    )
                }
            }
            .fullScreenCover(
                isPresented: $viewModel.isCameraPickerPresented,
                content: {
                    CameraPicker(photo: $viewModel.cameraPickerSelectedPhoto)
                        .ignoresSafeArea()
                }
            )
        }
    }

    @ViewBuilder
    private func listItemView(item: CDImageViewModel) -> some View {
        HStack(alignment: .center, spacing: 16) {
            Image(uiImage: item.image)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .border(.gray, width: 1)

            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .fontWeight(.bold)
                Text(item.text)
                    .fontWeight(.light)
            }

            Spacer()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    @State private static var viewModel = MainViewModel(dataService: DataService())
    static var previews: some View {
        MainView()
            .environmentObject(viewModel)
    }
}

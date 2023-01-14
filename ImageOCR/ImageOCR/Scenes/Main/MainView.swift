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
                                MainViewListItemView(item: item)
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
}

struct MainView_Previews: PreviewProvider {
    @State private static var viewModel = MainViewModel(dataService: DataService.preview)
    static var previews: some View {
        MainView()
            .environmentObject(viewModel)
    }
}

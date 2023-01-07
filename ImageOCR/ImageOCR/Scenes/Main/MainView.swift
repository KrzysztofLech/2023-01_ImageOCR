//  ContentView.swift
//  Created by Krzysztof Lech on 06/01/2023.

import PhotosUI
import SwiftUI

struct MainView: View {
    @StateObject var viewModel: MainViewModel

    var body: some View {
        NavigationStack {
            List(viewModel.images) { item in
                MainViewItemView(item: item)
            }

            .navigationTitle("Images")
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
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(viewModel: MainViewModel())
    }
}

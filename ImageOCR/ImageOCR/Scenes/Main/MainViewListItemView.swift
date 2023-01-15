//  MainViewListItemView.swift
//  Created by Krzysztof Lech on 13/01/2023.

import SwiftUI

struct MainViewListItemView: View {
    @EnvironmentObject var viewModel: MainViewModel
    let item: CDImageViewModel

    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            Image(uiImage: item.image)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .border(.gray, width: 1)

            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .fontWeight(.bold)

                Text(Strings.MainView.ocrIconTitle)
                    .font(.system(size: 8, weight: .bold))
                    .foregroundColor(.white)
                    .padding(4)
                    .background {
                        RoundedRectangle(cornerRadius: 4)
                            .foregroundColor(item.text.isEmpty ? .gray.opacity(0.7) : .green)
                    }
            }

            Spacer()
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(
                role: .destructive,
                action: {
                    viewModel.delete(item)
                },
                label: {
                    Image(systemName: "trash")
                }
            )
        }
    }
}

struct MainViewListItemView_Previews: PreviewProvider {
    @State private static var viewModel = MainViewModel(
        dataService: DataService.preview,
        textRecognitionService: nil
    )
    static var previews: some View {
        MainViewListItemView(item: DataService.previewItem)
            .environmentObject(viewModel)
    }
}

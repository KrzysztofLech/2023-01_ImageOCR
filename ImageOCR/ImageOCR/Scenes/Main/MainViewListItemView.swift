//  MainViewListItemView.swift
//  Created by Krzysztof Lech on 13/01/2023.

import SwiftUI

struct MainViewListItemView: View {
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
                Text(item.text.isEmpty ? Strings.MainView.noRecognisedText : item.text)
                    .fontWeight(.light)
                    .lineLimit(1)
            }

            Spacer()
        }
    }
}

struct MainViewListItemView_Previews: PreviewProvider {
    static var previews: some View {
        MainViewListItemView(item: DataService.previewItem)
    }
}

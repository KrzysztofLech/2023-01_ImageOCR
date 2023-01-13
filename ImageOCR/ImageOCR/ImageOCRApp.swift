//  ImageOCRApp.swift
//  Created by Krzysztof Lech on 06/01/2023.

import SwiftUI

@main
struct ImageOCRApp: App {
    private let dataService: ImageDataServiceProtocol = DataService()

    var body: some Scene {
        WindowGroup {
            let mainViewModel = MainViewModel(dataService: dataService)
            MainView()
                .environmentObject(mainViewModel)
        }
    }
}

//
//  AstraTech_SwiftUiApp.swift
//  AstraTech-SwiftUi
//
//  Created by MacBook Pro on 22/05/2025.
//

import SwiftUI

@main
struct AstraTech_SwiftUiApp: App {
    init(){
        UINavigationBar.appearance().tintColor = .white

    }

    var body: some Scene {
        WindowGroup {
            HomeView()
                .preferredColorScheme(.dark)
                .onAppear {
                    UINavigationBar.appearance().largeTitleTextAttributes = [
                        .foregroundColor: UIColor.white
                    ]
                    UINavigationBar.appearance().titleTextAttributes = [
                        .foregroundColor: UIColor.white
                    ]
                }
        }
    }
}

//
//  ContentView.swift
//  SwiftUIBankingApp
//
//  Created by Vladimir Kratinov on 2023-04-20.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader {
            let size = $0.size
            let safeArea = $0.safeAreaInsets
            
            ScrollViewReader { proxy in
                Home(proxy: proxy, size: size, safeArea: safeArea)
            }
            .preferredColorScheme(.light)
            .ignoresSafeArea()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//
//  OffsetReader.swift
//  SwiftUIBankingApp
//
//  Created by Vladimir Kratinov on 2023-04-20.
//

import SwiftUI

/// Offset Preference Key
struct OffsetKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

extension View {
    /// Offset View Modifier
    @ViewBuilder
    func offsetX(_ addObserver: Bool, completion: @escaping (CGRect) -> ()) -> some View {
        self
            .frame(maxWidth: .infinity)
            .overlay {
                if addObserver {
                    GeometryReader {
                        let rect = $0.frame(in: .global)
                        
                        Color.clear
                            .preference(key: OffsetKey.self, value: rect)
                            .onPreferenceChange(OffsetKey.self, perform: completion)
                        /// See most recent video on Page Tab View Scrolling Indicator for more information on Page Tab View Offset,
                        /// where I used those offsets to make an elegant scrolling indicator
                        /// https://youtu.be/W-uSGXhuFHY
                    }
                }
            }
    }
}

//
//  Background.swift
//  Day Out
//
//  Created by Aarav Sinha on 13/08/24.
//

import SwiftUI

struct GlobalBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                Color.black
                    .ignoresSafeArea(edges: .all)
            )
    }
}

extension View {
    func globalBackground() -> some View {
        self.modifier(GlobalBackgroundModifier())
    }
}

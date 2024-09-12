//
//  BaseView.swift
//  Day Out
//
//  Created by Aarav Sinha on 13/08/24.
//

import SwiftUI

struct BaseView<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .globalBackground()
    }
}

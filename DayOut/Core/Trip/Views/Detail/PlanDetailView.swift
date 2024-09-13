//
//  PlanDetailView.swift
//  DayOut
//
//  Created by Aarav Sinha on 13/09/24.
//

import SwiftUI

struct PlanDetailView: View {
    let plan: Plan
    var body: some View {
        NavigationStack {
            HStack {
                VStack(alignment: .leading) {
                    
                }
            
                Spacer()
                    .navigationTitle(plan.type == "Flight" ? plan.route ?? "Flight" : plan.name)
            }
        }
    }
}

#Preview {
    PlanDetailView(plan: .example)
}

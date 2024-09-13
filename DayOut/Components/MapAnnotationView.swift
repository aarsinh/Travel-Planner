//
//  MapAnnotationView.swift
//  DayOut
//
//  Created by Aarav Sinha on 13/09/24.
//

import SwiftUI

struct MapAnnotationView: View {
    let annotation: PlanAnnotation
    var imageName: String {
        switch annotation.type {
        case "Flight": return "airplane.circle.fill"
        case "Restaurant": return "fork.knife.circle.fill"
        case "Accommodation": return "bed.double.circle.fill"
        case "Activity": return "figure.walk.circle.fill"
        default: return "questionmark.circle.fill"
        }
    }
    var body: some View {
        VStack {
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .font(.headline)
                .padding(6)
                
            
            Image(systemName: "triangle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .rotationEffect(Angle(degrees: 180))
                .offset(y: -21)
                .padding(.bottom, 40)
                
        }
    }
}

#Preview {
    MapAnnotationView(annotation: .example)
}

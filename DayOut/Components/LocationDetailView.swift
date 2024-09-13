//
//  LocationDetailView.swift
//  DayOut
//
//  Created by Aarav Sinha on 12/09/24.
//

import SwiftUI
import CoreLocation

struct LocationDetailView: View {
    let annotation: PlanAnnotation
    @ObservedObject var viewModel = MapViewModel()
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d MMM yyy"
        return formatter
    }
    
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
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 10)
                .fill(.ultraThinMaterial)
                .frame(width: 350, height: 170)
            
            VStack(alignment: .leading) {
                Text(dateFormatter.string(from: annotation.date))
                    .font(.title3.bold())
                
                HStack(spacing: 20) {
                    Image(systemName: imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                    VStack(alignment: .leading) {
                        Text(annotation.title)
                            .bold()
                            .padding(.top)

                        Text(annotation.subtitle)
                            .frame(width: 270, height: 60, alignment: .topLeading)
                            .multilineTextAlignment(.leading)
                    }

                }
                
            }
            .padding()
        }
    }
}

#Preview {
    LocationDetailView(annotation: PlanAnnotation(coordinates: CLLocationCoordinate2D(latitude: 0, longitude: 0), title: "Aldona", subtitle: "Indigo", date: Date.now, type: "Restaurant"))
}

//
//  TripViewModel.swift
//  Day Out
//
//  Created by Aarav Sinha on 28/07/24.
//

import Firebase
import CoreLocation
import MapKit

protocol AddFormProtocol {
    var formIsValid: Bool { get }
}

protocol AddPlanProtocol {
    var formIsValid: Bool { get }
}


class TripViewModel: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    //MARK: - properties
    private var userService: UserService
    private var airlineService: AirlineService
    @Published var queryFragment: String = "" {
        didSet {
            completer.queryFragment = queryFragment
        }
    }
    
    @Published var selectedLocation = ""
    @Published var searchResults: [MKLocalSearchCompletion] = []
    @Published var selectedCoordinates: CLLocationCoordinate2D = CLLocationCoordinate2D()
    @Published var airlineQuery: String = ""
    @Published var selectedAirline: String = ""
    @Published var address: String = ""
    @Published var airlineIcao: String = ""
    @Published var error: Error?
    @Published var selectedTripPlans: [Plan] = []
    @Published var trips: [Trip] = []
    @Published var shouldDismissToTripView = false
    private var completer: MKLocalSearchCompleter
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, d MMM yyy"
        return formatter
    }
    
    @Published var isLoading = true
    
    //MARK: - init
    init(userService: UserService, airlineService: AirlineService) {
        self.userService = userService
        self.airlineService = airlineService
        self.completer = MKLocalSearchCompleter()
        super.init()
        self.completer.delegate = self
        self.completer.region = MKCoordinateRegion(.world)
    }
    
    //MARK: - functions
    func selectLocation(completion: MKLocalSearchCompletion, completionHandler: @escaping(CLLocationCoordinate2D?, String?) -> Void) {
        self.selectedLocation = completion.title
        
        let searchRequest = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: searchRequest)
        search.start { response, error in
            if let placemark = response?.mapItems.first?.placemark {
                let coordinate = placemark.coordinate
                
                let address = [
                    placemark.name,
                    placemark.subLocality,
                    placemark.locality,
                    placemark.administrativeArea,
                    placemark.postalCode,
                    placemark.country
                ]
                    .compactMap{ $0 }
                    .joined(separator: ", ")
                completionHandler(coordinate, address)
            } else {
                completionHandler(nil, nil)
            }
        }
        print("DEBUG: \(completion.title)")
        print("DEBUG: \(completion.subtitle)")
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.searchResults = completer.results
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: any Error) {
        print("DEBUG: Error with search completer: \(error.localizedDescription)")
    }
    
    func saveTrip(tripId: String, tripName name: String, coordinates: CLLocationCoordinate2D, startDate: String, endDate: String, plans: [Plan]) async throws {
        try await userService.saveTrip(tripId: tripId, tripName: name, coordinates: coordinates, startDate: startDate, endDate: endDate, plans: [])
    }
    
    func loadTrips() async throws -> [Trip] {
        try await userService.loadTrips()
    }
    
    
    func updatePlans(tripId: String, plan: Plan) async throws {
        try await userService.updatePlans(plan: plan, tripId: tripId)
    }
    
    func fetchTripId(by tripId: String) async throws -> String? {
        try await userService.fetchTripId(by: tripId)
    }
    
    func deleteTrip(withId id: String) async throws {
        try await userService.deleteTrip(withId: id)
    }
    
    func loadPlans(for trip: Trip) {
        self.selectedTripPlans = trip.plans.sorted { $0.startDate < $1.startDate }
    }
    
    func refreshTrip(id: String) async throws -> Trip {
        try await userService.refreshTrip(id: id)
    }
    
    @MainActor
    func fetchAirlines(query: String) async throws -> [Airline] {
        do {
            return try await airlineService.fetchAirlines(query: query)
        } catch {
            self.error = error
            return []
        }
    }
    
    @MainActor
    func fetchRoute(airlineIcao: String, flightNumber: String) async throws -> Route {
        do {
            return try await airlineService.fetchRoutes(airlineIcao: airlineIcao, flightNumber: flightNumber)
        } catch {
            self.error = error
            throw error
        }
    }
    
    @MainActor
    func fetchAirport(iataCode: String) async throws -> [Airport] {
        do {
            return try await airlineService.fetchAirport(iataCode: iataCode)
        } catch {
            self.error = error
            throw error
        }
    }
    
    func planIcon(for type: String) -> String {
        switch type {
        case "Flight": return "airplane.circle.fill"
        case "Accommodation": return "bed.double.circle.fill"
        case "Restaurant": return "fork.knife.circle.fill"
        case "Activity": return "figure.walk.circle.fill"
        default: return "circle.fill"
        } 
    }
}

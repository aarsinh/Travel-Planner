//
//  AirlineService .swift
//  Day Out
//
//  Created by Aarav Sinha on 30/08/24.
//

import Foundation

@MainActor
class AirlineService: ObservableObject {
    private let ninjasApiKey = Bundle.main.object(forInfoDictionaryKey: "NINJAS_API_KEY") as? String
    
    static let shared = AirlineService()
    
    func fetchAirlines(query: String) async throws -> [Airline] {
        guard let ninjasApiKey = ninjasApiKey, !ninjasApiKey.isEmpty else {
            throw AirlineError.invalidKey
        }
        guard let url = URL(string: "https://api.api-ninjas.com/v1/airlines?name=\(query)") else { throw AirlineError.invalidURL }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(ninjasApiKey, forHTTPHeaderField: "X-Api-Key")
        
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
//            print("\((response as? HTTPURLResponse)?.statusCode ?? 0)")
            print("DEBUG: airlines not working")
            throw AirlineError.serverError }
        
        guard let airlines = try? JSONDecoder().decode([Airline].self, from: data) else { throw AirlineError.invalidData }
        
        return airlines
    }
    
    func fetchRoutes(airlineIcao: String, flightNumber: String) async throws -> Route {
        guard let url = URL(string: "https://api.adsbdb.com/v0/callsign/\(airlineIcao)\(flightNumber)") else { throw AirlineError.invalidURL }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            print("DEBUG: routes not working")
            throw AirlineError.serverError
        }
        
        guard let route = try? JSONDecoder().decode(Route.self, from: data) else { throw AirlineError.invalidData }
        
        return route
    }
    
    func fetchAirport(iataCode: String) async throws -> [Airport] {
        guard let url = URL(string: "https://api.api-ninjas.com/v1/airports/?iata=\(iataCode)") else { throw AirlineError.invalidURL }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(ninjasApiKey, forHTTPHeaderField: "X-Api-Key")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            print("DEBUG: airports not working")
            throw AirlineError.serverError
        }
        
        guard let airport = try? JSONDecoder().decode([Airport].self, from: data) else { throw AirlineError.invalidData }
        
        return airport
    }
}

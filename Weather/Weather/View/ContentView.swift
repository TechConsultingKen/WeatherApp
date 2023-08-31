//
//  ContentView.swift
//  Weather
//
//  Created by Consultant on 8/29/23.
//

import SwiftUI
import CoreLocation
import CoreLocationUI

struct ContentView: View {
    @StateObject var locationManager = LocationManager()
    var weatherManager = WeatherManager()
    @State var currentData: CurrentData?
    @State var fiveDayData: FiveDayData?
    @State var showingAlert = false
    @State var error: Error?
    
    var body: some View {
        VStack {
            if let location = locationManager.location {
                if let currentData = currentData , let fiveDayData = fiveDayData {
                    WeatherView(fiveDayData: fiveDayData, currentData: currentData, weatherManager: weatherManager, locationManager: locationManager)
            } else {
                ProgressView()
                    .task {
                        do {
                            currentData = try await weatherManager.getCurrentWeather(latitude: location.latitude, longitude: location.longitude)
                            
                            fiveDayData = try await weatherManager.getForecast(latitude: location.latitude, longitude: location.longitude)
                            
                        } catch {
                            print("Error getting weather: \(error)")
                            self.error = error
                            
                        }
                    }
            }
        } else {
            if locationManager.isLoading {
                        ProgressView()
                    } else {
                        Text("No Location Found")
                        LocationButton(.shareCurrentLocation) {
                            locationManager.requestLocation()
                        }
                        
                }
            }
        }
        .alert(isPresented: $showingAlert, content: {
            Alert(title:
                    Text("Error"),
                  message: Text(error?.localizedDescription ?? "NEtwork Error"),
                  dismissButton: .default(Text("OK"))
            )
        })
        .background()
        .onAppear {
            locationManager.requestLocation()
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}

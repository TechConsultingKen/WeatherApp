//
//  WeatherView.swift
//  Weather
//
//  Created by Consultant on 8/29/23.
//

import SwiftUI
import CoreLocation

struct WeatherView: View {
    
    @State var fiveDayData: FiveDayData
    @State var currentData: CurrentData
    @State private var isRefreshing = false
    var weatherManager: WeatherManager
    var locationManager: LocationManager
    
    
    @State var animationAmount = 0.0
    @State private var isAnimating = false
    @State var slideup = false
    @State var slideleft = false
    
    var body: some View {
        
        ZStack(alignment: .leading) {
            
            LinearGradient(colors: [.blue,.white], startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack {
                    WeatherHeader
                    
                    CurrentWeatherView
                    
                    ForecastView
                    
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            } .refreshable {
                refreshAction()
            }
            
            
        }
        .edgesIgnoringSafeArea(.bottom)
        
    }
}

extension WeatherView{
    
    
    
    

    private var WeatherHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(currentData.name ?? "No City Found")
                    .bold().font(.title)
                
                let welcome = "Today, \(Date().formatted(.dateTime.month().day().hour().minute()))"
                Text(welcome)
                    .fontWeight(.light)
            }
            .padding(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
        }
    }
    
    private var CurrentWeatherView: some View {
        HStack {
            Spacer()
            VStack(spacing: 10) {
                AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(currentData.weather?.first?.icon ?? "")@2x.png")) { image in
                    image
                        .frame(width: 100, alignment: .leading)
//                                    .padding(.leading, 2)
                        .rotation3DEffect(.degrees(animationAmount), axis: (x: 0, y:1, z: 0))
                        .onAppear{
                            withAnimation(.interpolatingSpring(stiffness: 5, damping: 1)){
                                animationAmount += 360
                            }
                        }
                } placeholder: {
                    Image(systemName: "photo")
                        .frame(width: 100, alignment: .leading)

                }
                Text(currentData.weather?[0].description ?? "")
                    .padding(.leading, 4)
                    .bold()
                  
            }
            
            Spacer()
            
            Text((((currentData.main?.temp ?? 0) - 273.15).roundDouble()) + "°C")
                .font(.system(size: 80))
                .padding(.trailing, 3)
                .fontWeight(.bold)
              
        }
        
    }
    
    private var ForecastView: some View {
        VStack {
            Spacer().frame(height: 70)
            
            if slideleft == true {
                Text("Five Day Forecast")
                    .font(.title.bold())
                    .transition(.move(edge: .trailing))
                    .animation(.easeInOut(duration: 1))
            } else{
                    Text("Five Day Forecast")
                        .font(.title.bold())
                      
                }
            
            if slideup == true {
                FiveDayForecast
                    .transition(.move(edge: .bottom))
                    .animation(.easeInOut(duration: 1))
            }
            else {
                FiveDayForecast
            }
            Spacer()
        }.onAppear{
            
            withAnimation {
                slideup = true
                slideleft = true
            }
        }
    }
    
    
    private var FiveDayForecast: some View {
        ScrollView(.horizontal){
            HStack(alignment: .center){
                Forecast(date: String(fiveDayData.list?[0].dtTxt?.prefix(10).suffix(5) ?? ""), image: fiveDayData.list?[0].weather?.first?.icon ?? "", high: ((((fiveDayData.list?[0].main?.tempMax ?? 0) - 273.15).roundDouble()) + "°"), low: ((((fiveDayData.list?[0].main?.tempMin ?? 0) - 273.15).roundDouble()) + "°"))
                
                Forecast(date: String(fiveDayData.list?[8].dtTxt?.prefix(10).suffix(5) ?? ""), image: fiveDayData.list?[8].weather?.first?.icon ?? "", high: ((((fiveDayData.list?[8].main?.tempMax ?? 0) - 273.15).roundDouble()) + "°"), low: ((((fiveDayData.list?[8].main?.tempMin ?? 0) - 273.15).roundDouble()) + "°"))
                
                Forecast(date: String(fiveDayData.list?[16].dtTxt?.prefix(10).suffix(5) ?? ""), image: fiveDayData.list?[16].weather?.first?.icon ?? "", high: ((((fiveDayData.list?[16].main?.tempMax ?? 0) - 273.15).roundDouble()) + "°"), low: ((((fiveDayData.list?[16].main?.tempMin ?? 0) - 273.15).roundDouble()) + "°"))
                Forecast(date: String(fiveDayData.list?[24].dtTxt?.prefix(10).suffix(5) ?? ""), image: fiveDayData.list?[24].weather?.first?.icon ?? "", high: ((((fiveDayData.list?[24].main?.tempMax ?? 0) - 273.15).roundDouble()) + "°"), low: ((((fiveDayData.list?[24].main?.tempMin ?? 0) - 273.15).roundDouble()) + "°"))
                Forecast(date: String(fiveDayData.list?[32].dtTxt?.prefix(10).suffix(5) ?? ""), image: fiveDayData.list?[32].weather?.first?.icon ?? "", high: ((((fiveDayData.list?[32].main?.tempMax ?? 0) - 273.15).roundDouble()) + "°"), low: ((((fiveDayData.list?[32].main?.tempMin ?? 0) - 273.15).roundDouble()) + "°"))
                
            }
        }
    }
    
    @ViewBuilder
    private func Forecast(date: String, image: String, high: String, low: String) -> some View{
        VStack{
            Text(date)
                .font(.headline.bold())
            
            
            ZStack{
                Rectangle()
                    .foregroundColor(.blue) // Example background color
                    .frame(width: 140, height: 140) // Square dimensions
                    .border(Color.blue, width: 4)
                    .cornerRadius(12.0)
                HStack{
                    AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(image)@2x.png")) { image in
                        image
                            .padding(.leading, 8)
                    } placeholder: {
                        Image(systemName: "photo")
                    }
                    
                    VStack{
                        Text("H:" + high)
                            .foregroundColor(.orange.opacity(1.5))
                            .padding(.trailing, 22)
                            .font(.headline.bold())
                        Text("L:" + low)
                            .foregroundColor(.white)
                            .padding(.trailing, 22)
                            .font(.headline.bold())
                    }
                    
                }
            }
            
        }.padding(.vertical, 50)
    }
    
    private func refreshAction(){
        
            animationAmount = 0
            withAnimation(.interpolatingSpring(stiffness: 5, damping: 1)){
                animationAmount += 360
            }
        
            guard let location = locationManager.location else { return }
            Task {
                try await weatherManager.getCurrentWeather(latitude: location.latitude, longitude: location.longitude)
                try await weatherManager.getForecast(latitude: location.latitude, longitude: location.longitude)
            }
    }
}



//struct WeatherView_Previews: PreviewProvider {
//    static var previews: some View {
//        WeatherView(weather: previewWeather)
//    }
//}

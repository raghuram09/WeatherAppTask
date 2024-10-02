//
//  ContentView.swift
//  WeatherAppTask
//
//  Created by Raghu on 03/10/24.
//

import SwiftUI

struct WeatherReportView: View {
    @StateObject var viewModel = WeatherViewModel()
    @State var citySearchText: String = ""
    
    var locationManager = LocationManager()
    
    // Size class
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    var body: some View {
        ZStack {
            Image("WeatherImage")
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .clipped()
                .ignoresSafeArea()
            
            GeometryReader { geometry in
                ScrollView {
                    VStack {
                        SearchBar(text: $citySearchText,
                                  placeHolder: "Search by City", viewModel: viewModel)
                        .padding(.top, 40)
                        
                        if viewModel.weatherDetails?.name != nil {
                            WeatherReportDisplayView(viewModel: viewModel)
                        } else {
                            Text("🔎 No Search Results.")
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                                .font(.system(size: 20, weight: .light))
                                .foregroundColor(.white)
                        }
                        Spacer()
                    }
                    //Size classes
                    .padding(horizontalSizeClass == .compact ? 20 : 40)
                    .frame(width: horizontalSizeClass == .compact ? geometry.size.width : geometry.size.width * 0.8)
                    .frame(maxHeight: verticalSizeClass == .regular ? geometry.size.height : geometry.size.height * 0.7)
                }
            }
        }
        .padding()
        .onAppear {
            locationManager.getCurrentLocation { location, country in
                viewModel.getWeatherDeatails(location: location)
            }
        }
    }
}

#Preview {
    WeatherReportView()
}

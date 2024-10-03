//
//  WeatherReportDisplayView.swift
//  WeatherAppTask
//
//  Created by Raghu on 03/10/24.
//

import SwiftUI

struct WeatherReportDisplayView: View {
    @ObservedObject var viewModel = WeatherViewModel()
    
    // Size class 
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 5) {
                Text("My Location")
                    .foregroundColor(Color.white)
                    .font(.system(size: horizontalSizeClass == .compact ? 24 : 30, weight: .bold))
                
                Text(viewModel.weatherDetails?.name.capitalized ?? "")
                    .foregroundColor(Color.white)
                    .font(.system(size: horizontalSizeClass == .compact ? 18 : 20, weight: .bold))
                
                Text("\(Int(viewModel.weatherDetails?.main?.temp ?? 0))° C")
                    .foregroundColor(Color.white)
                    .font(.system(size: horizontalSizeClass == .compact ? 24 : 30, weight: .bold))
                
                Rectangle()
                    .fill(Color.blue)
                    .overlay(
                        VStack {
                            Text("Date: \((viewModel.weatherDetails?.dt ?? 0).convertToFormat())")
                                .foregroundColor(Color.white)
                                .font(.system(size: 15, weight: .bold))
                                .padding(.bottom, 20)
                            
                            Text("Average Temperature: \(Int(viewModel.weatherDetails?.main?.temp ?? 0))° C")
                                .foregroundColor(Color.white)
                                .font(.subheadline)
                            
                            Text("Pressure: \(viewModel.weatherDetails?.main?.pressure ?? 0) hPa")
                                .foregroundColor(Color.white)
                                .font(.subheadline)
                            Text("Visibility: \((viewModel.weatherDetails?.visibility ?? 0)/1000) km")
                                .foregroundColor(Color.white)
                                .font(.subheadline)
                                .padding(.bottom, 25)
                            
                            HStack(spacing: 30) {
                                Text("Humidity: \(viewModel.weatherDetails?.main?.humidity ?? 0)%")
                                    .foregroundColor(Color.white)
                                    .font(.subheadline)
                                Text("Feels Like: \(Int(viewModel.weatherDetails?.main?.feelsLike ?? 0))° C")
                                    .foregroundColor(Color.white)
                                    .font(.subheadline)
                            }
                        })
                    .cornerRadius(20)
                    .padding(.top, 30)
                    .frame(width:  horizontalSizeClass == .compact ? UIScreen.main.bounds.width * 0.85 : UIScreen.main.bounds.width * 0.6,height: verticalSizeClass == .compact ? 250 : 350)
            }
        }
       
    }
}

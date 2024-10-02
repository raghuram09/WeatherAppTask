//
//  WeatherAppTaskTests.swift
//  WeatherAppTaskTests
//
//  Created by Raghu on 03/10/24.
//

import XCTest
@testable import WeatherAppTask

final class WeatherAppTaskTests: XCTestCase {

    var viewModel: WeatherViewModel!
    var mockNetworkManager: MockHttpClient!
    
    override func setUpWithError() throws {
        // Put setup code here. Initialize the mock network manager and view model
        mockNetworkManager = MockHttpClient()
        viewModel = WeatherViewModel()
        viewModel.httpClient = mockNetworkManager
    }

    override func tearDownWithError() throws {
        // Clean up
        viewModel = nil
        mockNetworkManager = nil
    }


    func testGetWeather_Success() {
        // Given
        let kelvinTemp: Double = 293.15
        let expectedCelsiusTemp: Double = kelvinTemp - 273.15
        
        let expectedWeather = WeatherModel(
            coord: Coord(lon: -96.8236, lat: 33.1507),
            weather: [Weather(id: 800, main: "Clear", description: "clear sky", icon: "01n")],
            base: "stations",
            main: Main(temp: kelvinTemp, feelsLike: kelvinTemp - 3, tempMin: kelvinTemp, tempMax: kelvinTemp, pressure: 1013, humidity: 80, seaLevel: 1013, grndLevel: 1013),
            visibility: 10000,
            wind: Wind(speed: 4.47, deg: 347),
            clouds: Clouds(all: 0),
            dt: 1724293605,
            sys: Sys(type: 2, id: 2003174, country: "US", sunrise: 1724241288, sunset: 1724288770),
            timezone: -18000,
            id: 4692559,
            name: "Frisco",
            cod: 200
        )
        
        mockNetworkManager.mockWeatherModel = expectedWeather
        
        let expectation = XCTestExpectation(description: "Weather details should be set")
        
        // When
        viewModel.getWeatherDeatails(location: "Dallas")
        
        // Then
        DispatchQueue.main.async {
            print("WeatherDetails Temp: \(self.viewModel.weatherDetails?.main?.temp ?? 0)")
            print("Expected Temp: \(expectedCelsiusTemp)")
            
            XCTAssertEqual(self.viewModel.weatherDetails?.name, expectedWeather.name)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }



    func testGetWeather_Failure() {
        // Given
        mockNetworkManager.shouldReturnError = true
        let expectation = XCTestExpectation(description: "Weather details should not be set on error")
        
        // When
        viewModel.getWeatherDeatails(location: "InvalidLocation")
        
        // Then
        DispatchQueue.main.async {
            XCTAssertNil(self.viewModel.weatherDetails)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testGetWeather_EmptyResponse() {
        // Given
        mockNetworkManager.mockWeatherModel = nil // Simulate empty response
        let expectation = XCTestExpectation(description: "Weather details should not be set on empty response")
        
        // When
        viewModel.getWeatherDeatails(location: "Dallas")
        
        // Then
        DispatchQueue.main.async {
            XCTAssertNil(self.viewModel.weatherDetails)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testGetWeather_EmptyLocation() {
        // Given
        mockNetworkManager.mockWeatherModel = WeatherModel(
            coord: Coord(lon: 0, lat: 0),
            weather: [],
            base: "stations",
            main: nil,
            visibility: 0,
            wind: Wind(speed: 0, deg: 0),
            clouds: Clouds(all: 0),
            dt: 0,
            sys: Sys(type: 0, id: 0, country: "", sunrise: 0, sunset: 0),
            timezone: 0,
            id: 0,
            name: "",
            cod: 200
        )
        let expectation = XCTestExpectation(description: "Weather details should be set even with empty location")
        
        // When
        viewModel.getWeatherDeatails(location: "")
        
        // Then
        DispatchQueue.main.async {
            XCTAssertEqual(self.viewModel.weatherDetails?.name, "") // Should handle empty location gracefully
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }

    func testGetWeather_EventHandlerCalledOnSuccess() {
        // Given
        let expectedWeather = WeatherModel(
            coord: Coord(lon: -96.8236, lat: 33.1507),
            weather: [Weather(id: 800, main: "Clear", description: "clear sky", icon: "01n")],
            base: "stations",
            main: Main(temp: 293.15, feelsLike: 290.15, tempMin: 293.15, tempMax: 293.15, pressure: 1013, humidity: 80, seaLevel: 1013, grndLevel: 1013),
            visibility: 10000,
            wind: Wind(speed: 4.47, deg: 347),
            clouds: Clouds(all: 0),
            dt: 1724293605,
            sys: Sys(type: 2, id: 2003174, country: "US", sunrise: 1724241288, sunset: 1724288770),
            timezone: -18000,
            id: 4692559,
            name: "Frisco",
            cod: 200
        )
        mockNetworkManager.mockWeatherModel = expectedWeather
        
        let expectation = XCTestExpectation(description: "Event handler should be called on success")
        
        // When
        viewModel.getWeatherDeatails(location: "Dallas")
        
        // Then
        DispatchQueue.main.async {
            XCTAssertNotNil(self.viewModel.weatherDetails)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }

    func testGetWeather_EventHandlerCalledOnFailure() {
        // Given
        mockNetworkManager.shouldReturnError = true
        let expectation = XCTestExpectation(description: "Event handler should be called on error")
        
        // When
        viewModel.getWeatherDeatails(location: "InvalidLocation")
        
        // Then
        DispatchQueue.main.async {
            XCTAssertNil(self.viewModel.weatherDetails)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }

    func testPerformanceExample() throws {
        self.measure {
            // Measure performance of a specific piece of code here if needed
        }
    }

}

//
//  WeatherModel.swift
//  WeatherAppTask
//
//  Created by Raghu on 03/10/24.
//

import Foundation

struct WeatherModel: Codable {
    let coord: Coord
    let weather: [Weather]
    let base: String
    let main: Main?
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let dt: Int
    let sys: Sys
    let timezone, id: Int
    let name: String
    let cod: Int
}

struct Clouds: Codable {
    let all: Int
}

struct Coord: Codable {
    let lon, lat: Double
}

struct Main: Codable {
    @CelciusScale var temp: Double
    @CelciusScale var feelsLike: Double
    let tempMin, tempMax: Double
    let pressure, humidity, seaLevel, grndLevel: Int
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
    }
}

struct Sys: Codable {
    let type: Int?
    let id: Int?
    let country: String
    let sunrise, sunset: Int
}

struct Weather: Codable {
    let id: Int
    let main, description, icon: String
}

struct Wind: Codable {
    let speed: Double
    let deg: Int
}

@propertyWrapper
struct CelciusScale: Codable {
    var wrappedValue: Double
    
    init(wrappedValue: Double) {
        self.wrappedValue = wrappedValue
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let kelvin = try container.decode(Double.self)
        wrappedValue = kelvin - 273.15
    }
    
    func encode(to encoder: Encoder) throws {
        let kelvin = wrappedValue + 273.15
        var container = encoder.singleValueContainer()
        try container.encode(kelvin)
    }
}


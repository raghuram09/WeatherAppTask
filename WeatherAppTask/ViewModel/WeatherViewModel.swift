//
//  WeatherViewModel.swift
//  WeatherAppTask
//
//  Created by Raghu on 03/10/24.
//

import Foundation

class WeatherViewModel: ObservableObject {
    var httpClient = HTTPClient()
    @Published var weatherDetails: WeatherModel?

    private let lastSearchedCityKey = "LastSearchedCity"

    init() {
        if let lastSearchedCity = UserDefaults.standard.string(forKey: lastSearchedCityKey) {
            getWeatherDeatails(location: lastSearchedCity)
        }
    }
    
    func getWeatherDeatails(location: String) {
        let params = ["q": "\(location)", "appid": GlobalConstants.apiKey]
        let weatherUrl = createGetURL(baseURL: GlobalConstants.baseUrl, params: params)
        httpClient.request(modelType: WeatherModel.self, url: weatherUrl, httpMethod: HttpMethodType.Get) { response in
            DispatchQueue.main.async {
                switch response {
                case .success(let weather):
                    self.weatherDetails = weather
                    UserDefaults.standard.set(location, forKey: self.lastSearchedCityKey)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func createGetURL(baseURL: String, params: [String: String]) -> URL? {
        var urlComponents = URLComponents(string: baseURL)
        urlComponents?.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
        if let url = urlComponents?.url {
            return url
        } else {
            return nil
        }
    }
}

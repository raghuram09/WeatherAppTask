//
//  SearchView.swift
//  WeatherAppTask
//
//  Created by Raghu on 03/10/24.
//

import SwiftUI

struct SearchBar: UIViewRepresentable {
    @Binding var text: String
    let placeHolder: String
    @ObservedObject var viewModel: WeatherViewModel
    
    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> some UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.placeholder = placeHolder
        searchBar.searchBarStyle = .minimal
        searchBar.tintColor = .white
        searchBar.searchTextField.textColor = .white
        searchBar.searchTextField.font = .boldSystemFont(ofSize: 15)
          let placeholderTextColor = UIColor.white
          searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
              string: placeHolder,
              attributes: [NSAttributedString.Key.foregroundColor: placeholderTextColor]
          )
        return searchBar
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        uiView.text = text
    }

    func makeCoordinator() -> SearchBarCoordinator {
        return SearchBarCoordinator(text: $text, viewModel: viewModel)
    }

    final class SearchBarCoordinator: NSObject, UISearchBarDelegate {
        @Binding var text: String
        var viewModel: WeatherViewModel
        
        init(text: Binding<String>, viewModel: WeatherViewModel) {
            self._text = text
            self.viewModel = viewModel
        }

        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            text = searchBar.text ?? ""
            searchBar.endEditing(true)
            viewModel.weatherDetails = nil
            viewModel.getWeatherDeatails(location: searchBar.text ?? "")
        }

        func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
            searchBar.setShowsCancelButton(true, animated: true)
            return true
        }

        func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
            searchBar.setShowsCancelButton(false, animated: true)
            return true
        }

        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchBar.endEditing(true)
            searchBar.text = ""
            text = ""
        }
      
    }
}

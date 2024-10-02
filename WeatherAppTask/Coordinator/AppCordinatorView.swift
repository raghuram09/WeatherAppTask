//
//  AppCordinatorView.swift
//  WeatherAppTask
//
//  Created by Raghu on 03/10/24.
//

import SwiftUI

struct AppCordinatorView: View {
    @StateObject var router = Router(root: Route.WeatherView)

    var body: some View {
        RouterView(router: router) { route in
            switch route{
            case .WeatherView:
                WeatherReportView()
            }
        }
    }
}

#Preview {
    AppCordinatorView()
}

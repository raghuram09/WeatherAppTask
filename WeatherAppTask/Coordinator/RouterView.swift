//
//  RouterView.swift
//  WeatherAppTask
//
//  Created by Raghu on 03/10/24.
//

import SwiftUI

public struct RouterView<T: Hashable, Content: View>: View {
    
    @ObservedObject var router: Router<T>
    
    @ViewBuilder var buildView: (T) -> Content
    
    public init(router: Router<T>, @ViewBuilder buildView: @escaping (T) -> Content) {
        self.router = router
        self.buildView = buildView
    }
    
    public var body: some View {
        NavigationStack(path: $router.paths) {
            buildView(router.root)
                .navigationDestination(for: T.self) { path in
                    buildView(path).navigationBarBackButtonHidden(true)
                }
        }
        .environmentObject(router)
    }
}

public class Router<T: Hashable>: ObservableObject {
    
    @Published var root: T
    @Published var paths: [T] = []
    
    public init(root: T) {
        self.root = root
    }
    
    public func push(_ path: T) {
        paths.append(path)
    }
    
    public func pop() {
        paths.removeLast()
    }
    
    public func updateRoot(root: T) {
        self.root = root
    }
    
    public func popToRoot() {
        paths = []
    }
    
    public func popTo(_ path: T, inclusive: Bool = false) {
        if let index = paths.lastIndex(of: path) {
            let endIndex = inclusive ? index + 1 : index
            paths.removeSubrange(endIndex..<paths.endIndex)
        } else {
            print("Router: path not found.")
        }
    }
}

enum Route:Hashable{
    case WeatherView
}

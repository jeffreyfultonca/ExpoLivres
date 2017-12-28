public protocol DependencyInjectable {
    associatedtype Dependencies
    func inject(dependencies: Dependencies)
}

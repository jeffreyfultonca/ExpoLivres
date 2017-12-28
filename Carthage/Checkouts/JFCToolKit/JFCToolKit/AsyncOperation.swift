import Foundation

/**
 Generic Concurrent NSOperation Subclass
 
 Overrides methods and properties required
 to prevent Operation from finishing when
 main() returns.
 
 Meant to be subclassed.
 
 - Important:
 Subclasses must call completeOperation()
 when finished working.
 */
open class AsyncOperation<T>: Operation {
    
    // MARK: - AsyncResult
    
    public typealias Result = AsyncResult<T>
    public var result: Result = .failure(AsyncOperationError.operationNotComplete)
    
    public func completeOperation(with result: Result) {
        self.result = result
        completeOperation()
    }
    
    open override func cancel() {
        result = .failure(AsyncOperationError.operationCancelled)
        super.cancel()
    }
    
    // MARK: - Overrides
    
    open override var isAsynchronous: Bool { return true }
    
    open override func start() {
        guard !isCancelled else {
            _finished = true
            return
        }
        
        _executing = true
        
        main()
    }
    
    // MARK: - State Management
    
    private var _executing: Bool = false {
        willSet { willChangeValue(forKey: "isExecuting") }
        didSet { didChangeValue(forKey: "isExecuting") }
    }
    open override var isExecuting: Bool { return _executing }
    
    private var _finished: Bool = false {
        willSet { willChangeValue(forKey: "isFinished") }
        didSet { didChangeValue(forKey: "isFinished") }
    }
    open override var isFinished: Bool { return _finished }
    
    // MARK: - Completion
    
    private func completeOperation() {
        _executing = false
        _finished = true
    }
}

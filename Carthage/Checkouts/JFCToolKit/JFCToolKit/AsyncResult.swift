public enum AsyncResult<T> {
    case failure(Error)
    case success(T)
}

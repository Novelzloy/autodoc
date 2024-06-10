protocol ILogger: AnyObject {
    func logError(_ error: Error)
    func logInfo(_ string: String)
}

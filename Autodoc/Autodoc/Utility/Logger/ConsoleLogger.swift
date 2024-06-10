final class ConsoleLogger: ILogger {
    func logError(_ error: Error) {
        print()
        printLineSeparator()
        print("⛔️ Error performed:", error.localizedDescription, separator: "\n")
        printLineSeparator()
        print()
    }

    func logInfo(_ string: String) {
        print()
        printLineSeparator()
        print("ℹ️ Information:", string, separator: "\n")
        printLineSeparator()
        print()
    }

    private func printLineSeparator() {
        print("============================================")
    }
}

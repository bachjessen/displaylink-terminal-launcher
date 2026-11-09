import AppKit
import Foundation

private let terminalURL = URL(fileURLWithPath: "/System/Applications/Utilities/Terminal.app", isDirectory: true)

func fail(_ message: String) -> Never {
    fputs("DisplayLink Starter: \(message)\n", stderr)
    exit(EXIT_FAILURE)
}

guard let resourcesURL = Bundle.main.resourceURL else {
    fail("could not locate application resources")
}

let launcherURL = resourcesURL.appendingPathComponent("displaylink.command")
guard FileManager.default.fileExists(atPath: launcherURL.path) else {
    fail("bundled DisplayLink launcher is missing")
}

let configuration = NSWorkspace.OpenConfiguration()
configuration.activates = false

let semaphore = DispatchSemaphore(value: 0)
var launchError: Error?
NSWorkspace.shared.open(
    [launcherURL],
    withApplicationAt: terminalURL,
    configuration: configuration
) { _, error in
    launchError = error
    semaphore.signal()
}
semaphore.wait()

if let launchError {
    fail("could not open DisplayLink launcher in Terminal: \(launchError.localizedDescription)")
}

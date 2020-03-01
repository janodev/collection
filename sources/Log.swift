import Logging

let log: Logger = {
    var logger = Logger(label: "collection")
    logger.logLevel = .trace
    return logger
}()

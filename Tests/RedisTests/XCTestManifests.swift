#if !canImport(ObjectiveC)
import XCTest

extension MultipleRedisTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__MultipleRedisTests = [
        ("testApplicationRedis", testApplicationRedis),
        ("testSetAndGet", testSetAndGet),
    ]
}

extension RedisTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__RedisTests = [
        ("testApplicationRedis", testApplicationRedis),
        ("testCodable", testCodable),
        ("testDeprecationAdapter", testDeprecationAdapter),
        ("testInitConfigurationURL", testInitConfigurationURL),
        ("testRouteHandlerRedis", testRouteHandlerRedis),
        ("testSessions", testSessions),
    ]
}

public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(MultipleRedisTests.__allTests__MultipleRedisTests),
        testCase(RedisTests.__allTests__RedisTests),
    ]
}
#endif
    import XCTest
    @testable import SniprSwarmCore
    import SotoCloudWatchLogs

    final class SniprSwarmCoreTests: XCTestCase {
        func testIdentityPersistance() throws {
            let i1 = Identity(email: "mail@example.com", password: "pass1234", street: "Street", number: 1, zip: 1234, city: "City", country: "Austria", creditCard: 111122223334444, validThruMonth: 01, validThruYear: 2000, securityCode: 123)
            let i2 = Identity(email: "test@example.com", password: "pass1234", street: "Street", number: 1, zip: 1234, city: "City", country: "Austria", creditCard: 111122223334444, validThruMonth: 01, validThruYear: 2000, securityCode: 123)

            [i1, i2].save()

            let loaded = [Identity].load()
            XCTAssertNotNil(loaded)
            XCTAssertEqual(loaded!.count, 2)
            XCTAssertEqual(loaded![0], i1)
            XCTAssertEqual(loaded![1], i2)
        }

        func testCronParsingAndCreation() throws {
            let cron = "cron(0 9 1 1 ? 2021)"
            let date = Date.from(cronDateExpression: cron)

            var comp = DateComponents()
            comp.minute = 0
            comp.hour = 9
            comp.day = 1
            comp.month = 1
            comp.year = 2021
            let targetDate = Calendar.current.date(from: comp)
            
            XCTAssertEqual(date, targetDate)

            let resultCron = date!.toCronExpression()

            XCTAssertEqual(cron, resultCron)
        }

        func testSniprService() throws {
            let s = SniprService()

            let resource = Snipr(
            name: "Test",
            desc: "This is a Test",
            assassination: Date(),
            baseOffetSeconds: 10,
            respectiveOffetSeconds: 5,
            link: "http://test",
            size: "EU45",
            sniprTactic: SniprTactic(
                name: "TestLambda",
                arn: "arn:aws:lambda:eu-central-1:238438322436:function:TestLambda"
            ),
            identities: [
                Identity(email: "mail@example.com", password: "pass1234", street: "Street", number: 1, zip: 1234, city: "City", country: "Austria", creditCard: 111122223334444, validThruMonth: 01, validThruYear: 2000, securityCode: 123),
                Identity(email: "test@example.com", password: "pass1234", street: "Street", number: 1, zip: 1234, city: "City", country: "Austria", creditCard: 111122223334444, validThruMonth: 01, validThruYear: 2000, securityCode: 123)
            ])

            //delete if existing
            try s.delete(resource: resource).recover { _ in }.wait()

            try s.add(resource: resource).wait()

            let rules = try s.list().wait()
            XCTAssert(rules.contains(where: { $0.name == resource.name }))

            try s.delete(resource: resource).wait()

            let emptyRules = try s.list().wait()
            XCTAssert(!emptyRules.contains(where: { $0.name == resource.name }))
        }

        func testTacticService() throws {
            let t = TacticService()

            let tactics = try t.list().wait()
            tactics.forEach { tactic in
                print(tactic.arn)
            }
            
        }

    }

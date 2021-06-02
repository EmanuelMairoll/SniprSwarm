//
//  Converter.swift
//  SniprSwarmData
//
//  Created by Emanuel Mairoll on 26.04.21.
//

import Foundation
import SotoEventBridge


public extension Snipr {

    init(rule: EB.Rule, targets: [EB.Target], tags: [EB.Tag]) {
        func stripPrefix(_ name: String) -> String{
            let start = name.index(after: name.firstIndex(of: "-")!)
            return String(name[start...])
        }

        self.init(
            name: stripPrefix(rule.name!),
            desc: rule.description!,
            assassination: Date.from(cronDateExpression: rule.scheduleExpression!)!,
            baseOffetSeconds: Int(tags.value(forKey: .baseOffetSeconds)!)!,
            respectiveOffetSeconds: Int(tags.value(forKey: .respectiveOffetSeconds)!)!,
            link: tags.value(forKey: .link)!,
            size: tags.value(forKey: .size)!,
            thumbnailUrl: tags.value(forKey: .thumbnailUrl)!,
            sniprTacticArn: tags.value(forKey: .sniprTacticARN)!,
            identities: targets.map { TargetInput.from(json: $0.input!)!.identity }
        )
    }

    func toAwsElements() -> (EB.Rule, [EB.Target], [EB.Tag]) {
        let rule = EB.Rule(description: desc, name: awsName, scheduleExpression: assassination.toCronExpression())

        var targets = [EB.Target]()
        var loopCount = 0

        for identity in identities {
            targets.append(
                EB.Target(
                    arn: sniprTacticArn,
                    id: "\(rule.name!)-\(loopCount + 1)",
                    input: TargetInput(
                        identity: identity,
                        offsetSeconds: baseOffetSeconds + (respectiveOffetSeconds * loopCount),
                        link: link,
                        size: size
                    ).toJson()
                )
            )

            loopCount += 1
        }

        let tags = [
            EB.Tag(key: RuleToSniprTags.baseOffetSeconds.rawValue, value: String(baseOffetSeconds)),
            EB.Tag(key: RuleToSniprTags.respectiveOffetSeconds.rawValue, value: String(respectiveOffetSeconds)),
            EB.Tag(key: RuleToSniprTags.link.rawValue, value: link),
            EB.Tag(key: RuleToSniprTags.size.rawValue, value: size),
            EB.Tag(key: RuleToSniprTags.thumbnailUrl.rawValue, value: thumbnailUrl),
            EB.Tag(key: RuleToSniprTags.sniprTacticARN.rawValue, value: sniprTacticArn),
        ]

        return (rule, targets, tags)
    }

    var awsName: String {
        get {
            return "SniprSwarm-\(name)"
        }
    }

}

public extension Array where Element == EB.Tag {
    func value(forKey key: RuleToSniprTags) -> String?{
        return self.first { $0.key == key.rawValue }?.value
    }
}

public extension TargetInput {
    static func from(json: String) -> TargetInput? {

        let jsonData = json.data(using: .utf8)!
        return try! JSONDecoder().decode(TargetInput.self, from: jsonData)
    }

    func toJson() -> String? {
        let jsonData = try! JSONEncoder().encode(self)
        return String(data: jsonData, encoding: .utf8)!
    }
}

public extension SniprTactic {

    init(function: LB.FunctionConfiguration, tags: [String: String]) {
        name = function.functionName!
        arn = function.functionArn!
        desc = function.description
        successSignal = tags[LambdaToTacticTags.successSignal.rawValue]!
        failureSignal = tags[LambdaToTacticTags.failureSignal.rawValue]!
    }

}

public extension Date {
    static func from(cronDateExpression cron: String) -> Date? {
        let start = cron.firstIndex(of: "(")!
        let end =  cron.lastIndex(of: ")")!
        let digits = String(cron[ start ..< end ]).split(separator: " ")

        var comp = DateComponents()
        comp.minute = Int(digits[0])
        comp.hour = Int(digits[1])
        comp.day = Int(digits[2])
        comp.month = Int(digits[3])
        comp.year = Int(digits[5])

        return Calendar.current.date(from: comp)
    }

    func toCronExpression() -> String  {
        let comps = Calendar.current.dateComponents([.minute, .hour, .day, .month, .year], from: self)
        return "cron(\(comps.minute!) \(comps.hour!) \(comps.day!) \(comps.month!) ? \(comps.year!))"
    }
}


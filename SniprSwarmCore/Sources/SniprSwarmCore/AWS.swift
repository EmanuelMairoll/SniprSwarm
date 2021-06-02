//
//  AWS.swift
//  SnkrSwrm
//
//  Created by Emanuel Mairoll on 24.04.21.
//

import Foundation
import SotoEventBridge
import SotoLambda
import NIO


let awsClient = AWSClient(
    credentialProvider: .static(accessKeyId: AWS_ACCESS_KEY_ID, secretAccessKey: AWS_SECRET_ACCESS_KEY),
    httpClientProvider: .createNew
)

public protocol AWSServiceRO {
    associatedtype ResourceType

    func list() -> Futr<[ResourceType]>
}

public protocol AWSService: AWSServiceRO {

    @discardableResult
    func add(resource: ResourceType) -> Futr<Void>

    @discardableResult
    func delete(resource: ResourceType) -> Futr<Void>
}


public class SniprService: AWSService {
    public init(){
    }

    let eb = EventBridge(client: awsClient, region: .eucentral1)
    
    public func list() -> Futr<[Snipr]> {
        return eb.listRules(EB.ListRulesRequest(namePrefix: "SniprSwarm-"))
            .flatMap { response -> Futr<[(EB.Rule, [EB.Target], [EB.Tag])]> in

                let rules = response.rules ?? []

                let allFutures = rules.map { rule -> Futr<(EB.Rule, [EB.Target], [EB.Tag])> in
                    let targetsFuture = self.eb.listTargetsByRule(EB.ListTargetsByRuleRequest(rule: rule.name!))
                    let tagsFuture = self.eb.listTagsForResource(EB.ListTagsForResourceRequest(resourceARN: rule.arn!))

                    return targetsFuture.and(tagsFuture).map { (targetsResponse, tagsResponse) in
                        return (rule, targetsResponse.targets ?? [], tagsResponse.tags ?? [])
                    }
                }

                return .reduce(into: [], allFutures, on: awsClient.eventLoopGroup.next()) { res, elem in res.append(elem)}
            }
            .map { rules -> [Snipr] in
                return rules.map { rule, targets, tags in Snipr(rule: rule , targets: targets, tags: tags) }
            }
    }

    @discardableResult
    public func add(resource: Snipr) -> Futr<Void> {
        let (rule, targets, tags) = resource.toAwsElements()

        return eb.putRule(EB.PutRuleRequest(description: rule.description, name: rule.name!, scheduleExpression: rule.scheduleExpression, tags: tags))
            .flatMap { _ in
                self.eb.putTargets(EB.PutTargetsRequest(rule: rule.name!, targets: targets))
            }
            .map { _ -> Void in
                return
            }
    }


    @discardableResult
    public func delete(resource: Snipr) -> Futr<Void>{
        let name = resource.awsName

        return eb.listTargetsByRule(EB.ListTargetsByRuleRequest(rule: name))
            .flatMap { response in
                self.eb.removeTargets(EB.RemoveTargetsRequest(ids: response.targets!.map { $0.id }, rule: name))
            }
            .flatMap { _ in
                self.eb.deleteRule(EventBridge.DeleteRuleRequest(name: name))
            }
            .map { _ -> Void in
                return
            }
    }
}

public class TacticService: AWSServiceRO /*RO probably todo?*/ {
    public init(){
    }

    let lb = Lambda(client: awsClient, region: .eucentral1)

    public func list() -> EventLoopFuture<[SniprTactic]> {
        //TODO at max 50 functions supported

        return lb.listFunctions(LB.ListFunctionsRequest())
            .flatMap { response -> Futr<[(LB.FunctionConfiguration, [String: String])]> in

                let functions = response.functions ?? []

                let allFutures = functions.map { function -> Futr<(LB.FunctionConfiguration, [String: String])> in
                    let getFunction = self.lb.getFunction(LB.GetFunctionRequest(functionName: function.functionName!))

                    return getFunction.map { response in
                        return (response.configuration!, response.tags ?? [:])
                    }
                }

                return .reduce(into: [], allFutures, on: awsClient.eventLoopGroup.next()) { res, elem in res.append(elem)}
            }
            .map { functions -> [SniprTactic] in
                return functions.map { function, tags in SniprTactic(function: function, tags: tags) }
            }
    }
}

/*
public class LogService {
    let cw = CloudWatch(client: awsClient, region: .eucentral1)
    let cwl = CloudWatchLogs(client: awsClient, region: .eucentral1)

    func test() {
        let t = try! cwl.describeLogStreams(CloudWatchLogs.DescribeLogStreamsRequest(logGroupName: "/aws/lambda/SniprSwarm")).wait()
        print(t.logStreams)
        let l = t.logStreams?[0]

        cwl.log

        cwl.descri

    }
}
 */

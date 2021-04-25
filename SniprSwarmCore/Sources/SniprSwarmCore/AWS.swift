//
//  AWS.swift
//  SnkrSwrm
//
//  Created by Emanuel Mairoll on 24.04.21.
//

import Foundation
import SotoCore
import SotoEventBridge
import NIO

public typealias Futr = EventLoopFuture

let ev = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)

let awsClient = AWSClient(
    credentialProvider: .static(accessKeyId: AWS_ACCESS_KEY_ID, secretAccessKey: AWS_SECRET_ACCESS_KEY),
    httpClientProvider: .createNew
)

public class SniprService {    
    typealias EB = EventBridge
    let eb = EventBridge(client: awsClient)
    
    public func list() -> Futr<[Snipr]> {
        let f1 = eb.listRules(EB.ListRulesRequest(), on: ev.next())
        
        let f2 = f1.flatMap { response -> Futr<[(EB.Rule, [EB.Target])]> in
            var targetFutures: [Futr<(EB.Rule, [EB.Target])>] = []
            var tagFutures: [Futr<(EB.Rule, [EB.Tag])>] = []

            for rule in response.rules! {
                let targetFutures = self.eb.listTargetsByRule(EB.ListTargetsByRuleRequest(rule: rule.name!), on: ev.next())
                    .map { response in
                        return (rule, response.targets!)
                    }
                targetFutures.append(targetFuture)
                
                let tagFuture = self.eb.listTargetsByRule(EB.ListTargetsByRuleRequest(rule: rule.name!), on: ev.next())
                    .map { response in
                        return (rule, response.targets!)
                    }
                targetFutures.append(targetFuture)
            }
            
            
            
            return EventLoopFuture.reduce(into: [(EB.Rule, [EB.Target])](), futures, on: ev.next()) { (array, newVal) in
                array.append(newVal)
            }
        }
        
        return f2.map { rules -> [Snipr] in
            return rules.map { rule, targets in Snipr(rule: rule , targets: targets) }
        }
    }
    
    func add(resource: Snipr) {
        return
    }
    
    func delete(resource: Snipr) {
        return
    }
}

/*
 
 //TODO: Tactic Service
 
 //TODO: Log Service
 
 */

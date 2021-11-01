//
//  Executor.swift
//  vk
//
//  Created by Дмитрий Никишов on 02.11.2021.
//

import Foundation

class Executor {
    private lazy var queue : OperationQueue = {
       return OperationQueue()
    }()
    
    public static let shared = Executor()
    
    public func enqueue(_ op : Operation) {
        queue.addOperation(op)
    }
    
    public func addOperations(_ ops : [Operation]) {
        queue.addOperations(ops, waitUntilFinished : true)
    }
}

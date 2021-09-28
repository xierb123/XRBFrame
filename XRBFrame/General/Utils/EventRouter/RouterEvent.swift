//
//  RouterEvent.swift
//  QingkMediaConvergence_Swift
//
//  Created by gaoyuan on 2019/8/15.
//  Copyright © 2019 Qingk. All rights reserved.
//

import Foundation
public enum CellEvent {
    case clicked(Any)
}

public class RouterEvent: NSObject {}

public class Comment: RouterEvent {
    
    public let event: CellEvent
    public let type : String
    
    public init(event: CellEvent,type:String) {
        self.event = event
        self.type = type
        super.init()
    }
}


public class Search: RouterEvent {
    
    public let keyword: String
    
    public init(keyword: String) {
        self.keyword = keyword
        super.init()
    }
    
}

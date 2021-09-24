//
//  TiercelManager.swift
//  HiconMultiScreen
//
//  Created by devchena on 2020/12/29.
//

import Foundation
import Tiercel

typealias TiercelDownloadTask = DownloadTask
typealias TiercelHandler = Handler

class TiercelManager {
    let identifier: String
    
    private(set) lazy var sessionManager: SessionManager = {
        let sessionManager = SessionManager(identifier, configuration: SessionConfiguration())
        sessionManager.configuration.maxConcurrentTasksLimit = maxConcurrentTasksLimit
        return sessionManager
    }()
    
    var tasks: [TiercelDownloadTask] {
        return sessionManager.tasks
    }
    
    var maxConcurrentTasksLimit: Int = Int.max {
        didSet {
            sessionManager.configuration.maxConcurrentTasksLimit = maxConcurrentTasksLimit
        }
    }
    
    init(identifier: String) {
        self.identifier = identifier
    }
    
    @discardableResult
    func download(_ url: URL,
                  fileName: String? = nil,
                  handler: TiercelHandler<TiercelDownloadTask>? = nil) -> TiercelDownloadTask? {
        return sessionManager.download(url, fileName: fileName, handler: handler)
    }
    
    func fetchTask(_ url: URL) -> TiercelDownloadTask? {
        return sessionManager.fetchTask(url)
    }
    
    func remove(_ task: TiercelDownloadTask) {
        sessionManager.remove(task)
    }
}

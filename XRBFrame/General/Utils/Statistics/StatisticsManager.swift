//
//  StatisticsManager.swift
//  HiconMultiScreen
//
//  Created by 谢汝滨 on 2021/1/7.
//

struct StatisticsManager {
    /// 统计页面浏览量
    static func visit(position: String? = nil, contentKey: String? = nil) {
        requestStatistics(type: "view", position: position, contentKey: contentKey)
    }
    
    /// 统计视频播放事件
    static func play(position: String?, contentKey: String?) {
        requestStatistics(type: "play", position: position, contentKey: contentKey)
    }
    
    private static func requestStatistics(type: String, position: String?, contentKey: String? ) {
        let target = StatisticsAPI.statistics(type: type, position: position, contentKey: contentKey)
        NetworkManager.request(target)
    }
}

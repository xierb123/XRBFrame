//
//  PullToRefreshExtensions.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import UIKit
import ESPullToRefresh

extension UIScrollView {
    /// Add the drop-down refresh operation.
    ///
    /// - Parameter offset: The offset of refresh icon.
    func addPullToRefresh(offset: CGFloat? = nil, handler: @escaping () -> Void) {
        let headerAnimator = RefreshHeaderAnimator()
        if let offset = offset {
            headerAnimator.offset = offset
        }
        DispatchQueue.main.async {
            self.es.addPullToRefresh(animator: headerAnimator) {
                handler()
            }
        }
    }

    /// Add the pull-up load operation.
    ///
    /// - Parameter animatorBackgroundColor: Background Color of RefreshFooterAnimator.
    func addInfiniteScrolling(animatorBackgroundColor: UIColor? = nil, handler: @escaping () -> Void) {
        let footerAnimator = RefreshFooterAnimator()
        footerAnimator.backgroundColor = animatorBackgroundColor
        DispatchQueue.main.async {
            self.es.addInfiniteScrolling(animator: footerAnimator) {
                handler()
            }
        }
    }

    /// Auto refresh if expired.
    func autoPullToRefresh() {
        es.autoPullToRefresh()
    }

    /// Manual refresh.
    func startPullToRefresh() {
        es.startPullToRefresh()
    }

    /// Stop pull to refresh.
    /// The recommendation is executed after 'reloadData' completes.
    func stopPullToRefresh() {
        es.stopPullToRefresh()
    }

    /// Stop loading more.
    /// The recommendation is executed after 'reloadData' completes.
    func stopLoadingMore() {
        es.stopLoadingMore()
    }
    
    /// The footer notice has no more data.
    func noticeNoMoreData(isShowNoMore: Bool = true) {
        guard let footer = es.base.footer else {
            return
        }
        
        if let footerAnimator = footer.animator as? RefreshFooterAnimator {
            if isShowNoMore {
                var isEmpty: Bool = false
                if let tableView = self as? UITableView {
                    isEmpty = tableView.visibleCells.isEmpty
                } else if let collectionView = self as? UICollectionView {
                    if collectionView.visibleCells.isEmpty {
                        // UICollectionView visibleCells returns 0 after reloadData.
                        // The issue is caused by reload has not been finished.
                        // https://stackoverflow.com/questions/26055626/uicollectionview-visiblecells-returns-0-before-scrolling
                        collectionView.layoutIfNeeded()
                        isEmpty = collectionView.visibleCells.isEmpty
                    }
                }

                footerAnimator.isShowNoMore = !isEmpty
            } else {
                footerAnimator.isShowNoMore = false
            }
        }
        
        es.noticeNoMoreData()
        
        if footer.alpha < 1.0 {
            footer.alpha = 1.0
        }
    }

    /// The Footer reset no more data.
    func resetNoMoreData() {
        es.resetNoMoreData()
    }
    
    /// Prompts failed to load.
    func noticeLoadFailed() {
        Toast.show(Message.loadFailed)
    }
    
    /// Prompts no network.
    func noticeNoNetwork() {
        Toast.show(Message.noNetwork)
    }

    /// Prompts whether more can be loaded.
    ///
    /// - Parameters:
    ///   - isNoMore: Is there no more.
    func fixLoadMore(_ isNoMore: Bool) {
        if isNoMore {
            //let isShow = contentSize.height > height
            noticeNoMoreData(isShowNoMore: true)
        } else {
            resetNoMoreData()
        }
    }
}

extension UIScrollView {
    /// Stop pull to refresh.
    /// The recommendation is executed after 'reloadData' completes.
    ///
    /// - Parameters:
    ///   - isNoMore: Is there no more.
    func stopPullToRefresh(after time: TimeInterval = 0.8, isNoMore: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + time) {
            self.stopPullToRefresh()
            self.fixLoadMore(isNoMore)
        }
    }

    /// Stop loading more.
    /// The recommendation is executed after 'reloadData' completes.
    ///
    /// - Parameters:
    ///   - isNoMore: Is there no more.
    func stopLoadingMore(isNoMore: Bool) {
        stopLoadingMore()
        fixLoadMore(isNoMore)
    }
    
    /// Prompts exception.
    func noticeException() {
        if NetworkReachabilityMonitor.isReachable {
            noticeLoadFailed()
        } else {
            noticeNoNetwork()
        }
    }
}

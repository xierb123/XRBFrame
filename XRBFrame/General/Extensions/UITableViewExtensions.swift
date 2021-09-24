//
//  UITableViewExtensions.swift
//  HiconMultiScreen
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 HICON. All rights reserved.
//

import Foundation

extension UITableView {
    func sizeHeaderToFit() {
        if let headerView = tableHeaderView {
            headerView.setNeedsLayout()
            headerView.layoutIfNeeded()

            let headerSize = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            let height = headerSize.height
            var frame = headerView.frame
            frame.size.height = height

            headerView.frame = frame
            tableHeaderView = headerView

            headerView.setNeedsLayout()
            headerView.layoutIfNeeded()
        }
    }

    func sizeFooterToFit() {
        if let footerView = tableFooterView {
            footerView.setNeedsLayout()
            footerView.layoutIfNeeded()

            let footerSize = footerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            let height = footerSize.height
            var frame = footerView.frame
            frame.size.height = height

            footerView.frame = frame
            tableFooterView = footerView

            footerView.setNeedsLayout()
            footerView.layoutIfNeeded()
        }
    }

    func layoutTableHeaderView() {
        guard let headerView = tableHeaderView else {
            return
        }
        headerView.translatesAutoresizingMaskIntoConstraints = false

        let headerWidth = headerView.bounds.size.width
        let temporaryWidthConstraints = NSLayoutConstraint.constraints(withVisualFormat: "[headerView(width)]",
                                                                       options: NSLayoutConstraint.FormatOptions(rawValue: UInt(0)),
                                                                       metrics: ["width": headerWidth],
                                                                       views: ["headerView": headerView])

        headerView.addConstraints(temporaryWidthConstraints)

        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()

        let headerSize = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        let height = headerSize.height
        var frame = headerView.frame
        frame.size.height = height

        headerView.frame = frame
        tableHeaderView = headerView

        headerView.removeConstraints(temporaryWidthConstraints)
        headerView.translatesAutoresizingMaskIntoConstraints = true
    }

    func layoutTableFooterView() {
        guard let footerView = tableFooterView else {
            return
        }
        footerView.translatesAutoresizingMaskIntoConstraints = false

        let footerWidth = footerView.bounds.size.width
        let temporaryWidthConstraints = NSLayoutConstraint.constraints(withVisualFormat: "[footerView(width)]",
                                                                       options: NSLayoutConstraint.FormatOptions(rawValue: UInt(0)),
                                                                       metrics: ["width": footerWidth],
                                                                       views: ["footerView": footerView])

        footerView.addConstraints(temporaryWidthConstraints)

        footerView.setNeedsLayout()
        footerView.layoutIfNeeded()

        let footerSize = footerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        let height = footerSize.height
        var frame = footerView.frame
        frame.size.height = height

        footerView.frame = frame
        tableFooterView = footerView

        footerView.removeConstraints(temporaryWidthConstraints)
        footerView.translatesAutoresizingMaskIntoConstraints = true
    }
}

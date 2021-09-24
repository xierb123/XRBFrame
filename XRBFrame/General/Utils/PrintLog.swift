//
//  PrintLog.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/8/25.
//
//  自定义日志打印方法

import Foundation

func printLog<T>(_ message: T, file: String = #file, method: String = #function, line: Int = #line) {
    #if DEBUG
        print("\((file as NSString).lastPathComponent)[\(line)] - \(method): \(message)")
    #endif
}



//
//  CodeProtocolViewController.swift
//  XRBFrame
//
//  Created by 谢汝滨 on 2021/8/27.
//
//  协议

import UIKit

class CodeProtocolViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        var table = Department(tableName: "TableOfPerson")
        table.add(person: Person(name: "Swith", job: "doctor", age: 34))
        table.add(person: Person(name: "Joe", job: "waitter", age: 22))
        table.add(person: Person(name: "Harry Potter", job: "wizard", age: 13))
        
        printTable(with: table)
        
    }
    
    /// 协议组合,函数传参,必须同时符合TabularDataSource 和 CustomStringConvertible两种协议
    func printTableView<T: TabularDataSource & CustomStringConvertible>(with table: T){}
    
    func printTable<T: TabularDataSource>(with table: T){
        // 打印表格名称
        var maxWidth = 0
        for item in 0..<table.numberOfColumns{
            maxWidth += table.widthForColumn(column: item)
        }
        maxWidth += 14
        let space = repeatElement(" ", count: (maxWidth - table.name.count)/2).joined(separator: "")
        print(space+table.name)
        // 打印表头
        for item in 0..<table.numberOfColumns{
            let space = repeatElement(" ", count: max(0, table.widthForColumn(column: item) - table.label(forColumn: item).count)).joined(separator: "")
            print("| \(space)\(table.label(forColumn: item)) ", terminator: "")
        }
        print("|")
        // 打印表格数据
        for i in 0..<table.numberOfRows{
            for j in 0..<table.numberOfColumns {
                let space = repeatElement(" ", count: max(0, table.widthForColumn(column: j) - table.itemFor(row: i, column: j).count)).joined(separator: "")
                print("| \(space)\(table.itemFor(row: i, column: j)) ", terminator: "")
            }
            print("|")
        }
    }
}

/// 协议
protocol TabularDataSource {
    /// 属性
    
    /// 表格名称
    var name: String { set get } // 读写属性: {get set}
    /// 行
    var numberOfRows: Int { get } // 只读属性: { get }
    /// 列
    var numberOfColumns: Int { get }
    
    /// 方法
    
    /// 每一列返回的数据
    func label(forColumn column: Int) -> String
    /// 单行每一列返回的数据
    func itemFor(row: Int, column: Int) -> String
    /// 获取每一列的最大宽度
    func widthForColumn(column: Int) -> Int
}


/// 声明一个结构体,实现自身的属性和方法
struct Department {
    var tableName: String
    var people = [Person]()
    
    mutating func add(person: Person) {
        self.people.append(person)
    }
}

/// 声明结构体符合协议
/// 符合协议的结构体必须实现协议约定的方法和属性
extension Department: TabularDataSource {
    var name: String {
        get {
            return tableName
        }
        set {
            tableName = newValue
        }
    }
    
    var numberOfRows: Int {
        return people.count
    }
    
    var numberOfColumns: Int {
        return 3
    }
    
    func label(forColumn column: Int) -> String {
        switch column {
        case 0:
            return "name"
        case 1:
            return "job"
        case 2:
            return "age"
        default:
            return  "error"
        }
    }
    
    func itemFor(row: Int, column: Int) -> String {
        let person = people[row]
        switch column {
        case 0:
            return person.name
        case 1:
            return person.job
        case 2:
            return String(person.age)
        default:
            return "error"
        }
    }
    
    func widthForColumn(column: Int) -> Int {
        var widths = [4, 3, 3]
        for item in people {
            widths[0] = max(widths[0], item.name.count)
            widths[1] = max(widths[1], item.job.count)
            widths[2] = max(widths[2], String(item.age).count)
        }
        return widths[column]
    }
}

struct Person{
    var name: String
    var job: String
    var age: Int
}

/// 协议继承 - 符合DabularDataSource的类型,也必须实现CustomStringConvertible指定的方法
protocol DabularDataSource: CustomStringConvertible{
    
}

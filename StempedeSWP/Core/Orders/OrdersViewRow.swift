//
//  OrdersViewRow.swift
//  StempedeSWP
//
//  Created by Huynh Nguyen Tuan Duy on 7/12/24.
//

import SwiftUI

struct OrdersViewRow: View {
    let order: Orders
    var body: some View {
        VStack(alignment: .leading){
            Text("Giao dịch số: \(order.OrderID)")
                .font(.title.bold())
            Text("Ngày đặt: \(order.OrderDate.iso8601ToNormalDateTime() ?? "")")
                .foregroundStyle(.gray)
                .font(.caption)
            Text(Decimal(order.TotalAmount), format: .currency(code: "VND"))
                .foregroundStyle(.red)
                .font(.callout.bold())
            HStack(spacing: 2){
                Text("Chi tiết")
                    .font(.subheadline.bold())
                    .foregroundStyle(.purple)
                Image(systemName: "arrow.right.circle")
                    .font(.subheadline.bold())
                    .foregroundStyle(.purple)
            }
            Divider()
        }
    }
}



//#Preview {
//    OrdersViewRow()
//}
import Foundation

extension DateFormatter {
    static let yyyyMMdd: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    static let yyyyMMddHHmmss: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    static let iso8601Formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return formatter
    }()
    static let iso8601WithFractionalSecondsFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSS"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
extension String {

    func iso8601ToNormalDate() -> String? {
        if let date = DateFormatter.iso8601WithFractionalSecondsFormatter.date(from: self) {
            return DateFormatter.yyyyMMdd.string(from: date)
        }
        return nil
    }
}
extension DateFormatter {
    static let iso8601WithMillisecondsFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter
    }()
}

extension String {
    // Parse ISO8601 date string and return a formatted normal date
    func iso8601ToNormalDateTime() -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        if let date = formatter.date(from: self) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "yyyy-MM-dd"
            return outputFormatter.string(from: date)
        }
        return nil
    }
}

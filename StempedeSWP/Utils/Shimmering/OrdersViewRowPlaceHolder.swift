//
//  OrdersViewRowPlaceHolder.swift
//  StempedeSWP
//
//  Created by Huynh Nguyen Tuan Duy on 7/12/24.
//

import SwiftUI

struct OrdersViewRowPlaceHolder: View {
    var body: some View {
        ForEach(0..<5){ _ in
            OrdersViewRow(order: Orders(OrderID: 1, UserID: 1, OrderDate: "2839 2j9892ie ", TotalAmount: 20000000))
                .redacted(reason: .placeholder)
                .shimmering()
        }
    }
}

#Preview {
    OrdersViewRowPlaceHolder()
}

//
//  FeedRowPlaceHolder.swift
//  StempedeSWP
//
//  Created by Huynh Nguyen Tuan Duy on 5/12/24.
//

import SwiftUI

struct FeedRowPlaceHolder: View {
    var body: some View {
        ForEach(0..<5){ _ in
            FeedRowView(subCategory: "gaf", product: Products.sample)
                .redacted(reason: .placeholder)
                .shimmering()
        }
    }
}

#Preview {
    FeedRowPlaceHolder()
}

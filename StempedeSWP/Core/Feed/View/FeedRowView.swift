//
//  FeedRowView.swift
//  StempedeSWP
//
//  Created by Huynh Nguyen Tuan Duy on 5/12/24.
//

import SwiftUI

struct FeedRowView: View {
    let subCategory: String
    let product: Products
    var body: some View {
        VStack(alignment: .center){
        VStack(alignment: .leading){
            ZStack(alignment: .bottomTrailing){
                AsyncImage(url: URL(string: product.ImagePath)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.width * 0.95, height: UIScreen.main.bounds.width / 1.75)
                        .cornerRadius(15)
                } placeholder: {
                    Color(.secondarySystemBackground)
                        .frame(width: UIScreen.main.bounds.width * 0.95, height: UIScreen.main.bounds.width / 1.75)
                        .cornerRadius(15)
                }
                Text(product.status)
                    .font(.callout)
                    .bold()
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(product.statusColor
                        .mask(Capsule()))
                    .foregroundColor(.white)
                    .cornerRadius(5)
                    .padding([.trailing, .bottom], 10)
            }
            VStack(alignment: .leading, spacing: 10){
                HStack{
                    HStack(spacing: 10) {
                        Image(systemName: "birthday.cake")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 30)
                        VStack(alignment: .leading) {
                            Text(product.Ages)
                                .font(.caption)
                                .bold()
                            Text("Tuổi")
                                .font(.caption2)
                        }
                        .frame(height: 20)
                    }
                    Divider()
                        .frame(height: 30)
                        .padding(.trailing)
                    HStack(spacing: 10) {
                        Image(systemName: "archivebox")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 30)
                        VStack(alignment: .leading) {
                            Text("\(product.StockQuantity)")
                                .font(.caption)
                                .bold()
                            Text("Trong kho")
                                .font(.caption2)
                        }
                        .frame(height: 20)
                    }
                }
                .padding(.top, 5)
                ///titles
                Text(product.ProductName)
                    .font(.title)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.leading)
                HStack{
                    Text(product.Price, format: .currency(code: "VND"))
                        .font(.title2.bold())
                        .foregroundStyle(.red)
                        .fontWeight(.semibold)
                    Spacer()
                    Text(subCategory)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.horizontal)
    }
    }
}

#Preview {
    FeedRowView(subCategory: "Science", product: Products.sample)
}

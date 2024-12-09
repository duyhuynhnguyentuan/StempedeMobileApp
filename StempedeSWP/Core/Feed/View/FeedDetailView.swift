//
//  FeedDetailView.swift
//  StempedeSWP
//
//  Created by Huynh Nguyen Tuan Duy on 5/12/24.
//

import SwiftUI

struct FeedDetailView: View {
    @StateObject var viewModel: FeedDetailViewModel
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var routerManager : NavigationRouter
    @EnvironmentObject private var cartManager: ShoppingCartManager
    let ProductID: String
    init(ProductID: String) {
        self.ProductID = ProductID
        _viewModel = StateObject(wrappedValue: FeedDetailViewModel(productID: ProductID, productService: ProductsService(httpClient: HTTPClient()), labsService: LabsService(httpClient: HTTPClient())))
    }
    var body: some View {
        switch viewModel.loadingState {
        case .loading:
            ProgressView()
        case .finished:
            VStack(alignment: .center){
                VStack(alignment: .leading){
                    ZStack(alignment: .bottomTrailing){
                        AsyncImage(url: URL(string: viewModel.product?.ImagePath ?? "N/A")) { image in
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
                        Text(viewModel.product?.status ?? "N/A")
                            .font(.callout)
                            .bold()
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(viewModel.product?.statusColor
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
                                    Text(viewModel.product?.Ages ?? "N/A")
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
                                    Text("\(viewModel.product?.StockQuantity ?? 0)")
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
                        Text(viewModel.product?.ProductName ?? "N/A")
                            .font(.title)
                            .fontWeight(.regular)
                            .multilineTextAlignment(.leading)
                        HStack{
                            Text(viewModel.product?.Price ?? 0, format: .currency(code: "VND"))
                                .font(.title2.bold())
                                .foregroundStyle(.red)
                                .fontWeight(.semibold)
                            Spacer()
                        }
                        Divider()
                        Text("Bài Lab đi kèm")
                            .font(.title2.bold())
                            .padding(.top)
                    }
                }
                VStack(alignment: .leading){
                    VStack(alignment:.leading){
                        Text(viewModel.labs?.LabName ?? "N/A")
                            .font(.title3)
                            .fontWeight(.semibold)
                        Text("Mô tả: \(viewModel.labs?.Description ?? "N/A")")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.purple ,lineWidth: 2)
                    )
                    Text("*Hãy thanh toán để xem nội dung bài lab")
                        .font(.caption)
                        .foregroundStyle(.red)
                }
                Spacer()
                Button{
                    cartManager.add(product: viewModel.product!)
                    dismiss()
                }label: {
                    viewModel.isOutOfStock ? Text("Đã hết hàng")
                        .modifier(ButtonModifier(backgroundColor: .red)):
                    Text("Thêm vào giỏ")
                        .modifier(ButtonModifier())
                }
                .disabled(viewModel.isOutOfStock)
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    FeedDetailView(ProductID: "1")
}

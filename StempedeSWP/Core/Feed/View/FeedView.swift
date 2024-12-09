//
//  FeedView.swift
//  StempedeSWP
//
//  Created by Huynh Nguyen Tuan Duy on 3/12/24.
//

import SwiftUI

struct FeedView: View {
    @StateObject var viewModel: FeedViewModel
    @EnvironmentObject private var routerManager : NavigationRouter
    @State private var showingFilterSheet = false
    @EnvironmentObject private var cartManager: ShoppingCartManager
    init() {
        _viewModel = StateObject(wrappedValue: FeedViewModel(productsService: ProductsService(httpClient: HTTPClient()), subcategoriesService: SubcategoriesService(httpClient: HTTPClient())))
    }
    var body: some View {
        NavigationStack(path: $routerManager.routes){
            ZStack{
                switch viewModel.loadingState {
                case .loading:
                    List{
                        FeedRowPlaceHolder()
                    }
                    .listStyle(.plain)
                    .navigationTitle("Đã thêm gần đây")
                case .finished:
                    List{
                        ForEach(viewModel.filteredProducts) { product in
                                FeedRowView(subCategory: getSubcategoryName(for: product), product: product)
                                .onTapGesture(perform: {
                                    routerManager.push(to: .products(ProductID: String(product.ProductID)))
                                })
                            .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                if let link = Route.buildDeepLink(from: .products(ProductID: String(product.ProductID))){
                                    ShareLink(item: link) {
                                        Image(systemName: "square.and.arrow.up")
                                            .foregroundStyle(.purple)
                                    }
                                }
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button{
                                    cartManager.add(product: product)
                                }label: {
                                    Image(systemName: "cart.badge.plus")
                                }.tint(.pink)
                            }
                        }
                    }
                    .toolbar {
                        Button(action: {
                            showingFilterSheet.toggle()
                        }) {
                            Image(systemName: "rectangle.and.text.magnifyingglass")
                        }
                        CartButton(count: cartManager.items.count) {
                            routerManager.push(to: .cart)
                        }
                    }
                    .sheet(isPresented: $showingFilterSheet) {
                        FilterSheetView(viewModel: viewModel)
                    }

                    .listStyle(.plain)
                    .alert(item: $viewModel.error) { error in
                        // Handle alert cases
                        switch error {
                        case .badRequest:
                            return Alert(
                                title: Text("Bad Request"),
                                message: Text("Unable to perform the request."),
                                dismissButton: .default(Text("OK"))
                            )
                        case .decodingError(let decodingError):
                            return Alert(
                                title: Text("Decoding Error"),
                                message: Text(decodingError.localizedDescription),
                                dismissButton: .default(Text("OK"))
                            )
                        case .invalidResponse:
                            return Alert(
                                title: Text("Invalid Response"),
                                message: Text("The server response was invalid."),
                                dismissButton: .default(Text("OK"))
                            )
                        case .errorResponse(let errorResponse):
                            return Alert(
                                title: Text("Lỗi"),
                                message: Text(errorResponse.message ?? "An unknown error occurred."),
                                dismissButton: .default(Text("OK"))
                            )
                        }
                    }
                    .refreshable {
                        viewModel.handleRefresh()
                    }
                    .searchable(text: $viewModel.searchText, placement: .automatic, prompt: "Tìm kiếm sản phẩm...")
                    .navigationTitle("Đã thêm gần đây")
                    .navigationDestination(for: Route.self) { $0 }
                }
            }
        }
    }
    private func getSubcategoryName(for product: Products) -> String {
        guard let subcategory = viewModel.subcategories.first(where: { $0.SubcategoryID == product.SubcategoryID }) else {
            return "Unknown"
        }
        return subcategory.SubcategoryName
    }
}

#Preview {
    FeedView()
}

struct FilterSheetView: View {
    @ObservedObject var viewModel: FeedViewModel
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack {
            List(viewModel.subcategories) { subcategory in
                MultipleSelectionRow(subcategory: subcategory, isSelected: viewModel.selectedSubcategories.contains(subcategory.SubcategoryID)) {
                    if viewModel.selectedSubcategories.contains(subcategory.SubcategoryID) {
                        viewModel.selectedSubcategories.remove(subcategory.SubcategoryID)
                    } else {
                        viewModel.selectedSubcategories.insert(subcategory.SubcategoryID)
                    }
                }
            }
            .navigationTitle("Lọc")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct MultipleSelectionRow: View {
    var subcategory: Subcategories
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        HStack {
            Text(subcategory.SubcategoryName)
            Spacer()
            if isSelected {
                Image(systemName: "checkmark")
                    .foregroundColor(.blue)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            action()
        }
    }
}

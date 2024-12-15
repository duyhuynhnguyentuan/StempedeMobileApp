//
//  OrdersDetailView.swift
//  StempedeSWP
//
//  Created by Huynh Nguyen Tuan Duy on 7/12/24.
//

import SwiftUI

struct OrdersDetailView: View {
    @StateObject var viewModel: OrdersDetailViewModel
    let OrderID: String
    
    init(OrderID: String) {
        self.OrderID = OrderID
        _viewModel = StateObject(wrappedValue: OrdersDetailViewModel(ordersDetailService: OrderDetailsService(httpClient: HTTPClient()), OrderID: OrderID))
    }
    
    var body: some View {
        switch viewModel.loadingState {
        case .loading:
            ProgressView()
        case .finished:
            VStack {
                Text("Chi tiết giao dịch")
                    .font(.title)
                if viewModel.ordersDetailResponse.isEmpty {
                    Text("No details available.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                } else {
                    // Using a regular ForEach as the data is not in a binding
                    List{
                        ForEach(viewModel.ordersDetailResponse) { detail in
                            VStack(alignment: .leading) {
//                                LabeledContent {
//                                    HStack {
//                                        Text(detail.OrderPrice, format: .currency(code: Locale.current.currency?.identifier ?? ""))
//                                        Spacer()
//                                        Text("x\(detail.Quantity)").font(.callout).bold()
//                                    }
//                                } label: {
                                    AsyncImage(url: URL(string: detail.ImagePath)) { image in
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .cornerRadius(15)
                                    } placeholder: {
                                        Color(.secondarySystemBackground)
                                            .cornerRadius(15)
                                    }
                                HStack {
                                    Text(detail.OrderPrice, format: .currency(code: Locale.current.currency?.identifier ?? ""))
                                        .foregroundStyle(.red)
                                    Spacer()
                                    Text("x\(detail.Quantity)").font(.callout).bold()
                                }
                                    Text("\(detail.ProductName)")
                                    Text("Mô tả: \(detail.ProductDescription)")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
//                                }
                                VStack(alignment: .leading){
                                    Text("Bài lab đính kèm")
                                        .font(.title.bold())
                                    NavigationLink{
                                        PDFView(pdfURL: detail.LabFileURL)
                                            .navigationBarBackButtonHidden()
                                            .toolbarVisibility(.hidden, for: .tabBar)
                                    }label: {
                                        HStack(alignment: .top){
                                            Image(.pdfIcon)
                                            VStack(alignment: .leading){
                                                Text("\(detail.LabName).pdf")
                                                    .font(.title3.bold())
                                                Text("Nhấn vào để xem chi tiết")
                                                    .font(.callout)
                                                    .foregroundStyle(.gray)
                                            }
                                            Spacer()
                                        }
                                        .padding()
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.purple ,lineWidth: 2)
                                        )
                                    }
                                }
                                .padding(.top)
                                VStack(alignment: .leading){
                                    Text("Video đính kèm")
                                        .font(.title.bold())
                                    if detail.VideoURL != nil{
                                        YouTubePlayerView(url: URL(string: detail.VideoURL!)!)
                                    }else{
                                        Text("Không có video")
                                    }
                                }
//                                Divider()
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                    .padding(.horizontal)
                }
            }
        }
    }
}
///PDFView
import WebKit
struct PDFView: View {
    let pdfURL: String
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        VStack{
            HStack{
                ShareLink(item: pdfURL){
                    Label("Chia sẻ file PDF", systemImage: "square.and.arrow.up")
                }.bold()
                Spacer()
                Button{
                    dismiss()
                }label: {
                    Image(systemName: "xmark")
                        .font(.caption2)
                        .foregroundStyle(.white)
                        .padding()
                        .background(Color.black.opacity(0.35))
                        .clipShape(Circle())
                }
            }.padding()
        //MARK: - PDF View
            PDFViewRepresentable(url: URL(string: pdfURL)!)
                .edgesIgnoringSafeArea(.all)
        }
    }
}

struct PDFViewRepresentable: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        
        // Create WKWebView and configure it
        let webView = WKWebView(frame: .zero)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Load the PDF URL
        let request = URLRequest(url: url)
        webView.load(request)
        
        // Add the WKWebView to the view controller's view
        viewController.view.addSubview(webView)
        
        // Set up Auto Layout constraints
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: viewController.view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor)
        ])
        
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Optional: Handle updates to the view, if needed
    }
}

import SwiftUI
import WebKit
struct YouTubePlayerView: UIViewRepresentable {
    
    private let url: URL
    
    init?(videoID: String) {
        guard let url = URL(string: "https://www.youtube.com/embed/\(videoID)") else { return nil }
        self.init(url: url)
    }
    
    init(url: URL) {
        self.url = url
    }
    
    // MARK: Functions

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: YouTubePlayerView

        init(_ parent: YouTubePlayerView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        }
    }
}
//#Preview {
//    OrdersDetailView()
//}

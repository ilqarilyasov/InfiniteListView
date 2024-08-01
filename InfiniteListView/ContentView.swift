//
//  ContentView.swift
//  InfiniteListView
//
//  Created by Ilqar Ilyasov on 8/1/24.
//

import SwiftUI
import WebKit

struct ContentView: View {
    @StateObject private var viewModel = ListViewModel()

    var body: some View {
        NavigationView {
            List {
                OutlineGroup(viewModel.items, children: \.children) { item in
                    if let url = item.url {
                        NavigationLink(destination: WebView(url: url)) {
                            Text(item.title)
                                .padding(.vertical, 5)
                                .onAppear {
                                    if viewModel.items.last == item {
                                        viewModel.loadMoreData()
                                    }
                                }
                        }
                    } else {
                        Text(item.title)
                            .padding(.vertical, 5)
                            .onAppear {
                                if viewModel.items.last == item {
                                    viewModel.loadMoreData()
                                }
                            }
                    }
                }

                if viewModel.isLoading {
                    ProgressView("Loading...")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .navigationTitle("Infinite List")
        }
    }
}

struct WebView: UIViewRepresentable {
    let url: URL

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
        var parent: WebView
        var errorView: UILabel?

        init(_ parent: WebView) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            displayError(webView, error: error)
        }

        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            displayError(webView, error: error)
        }

        private func displayError(_ webView: WKWebView, error: Error) {
            let errorLabel = UILabel()
            errorLabel.text = error.localizedDescription
            errorLabel.textAlignment = .center
            errorLabel.numberOfLines = 0
            errorLabel.backgroundColor = .white
            errorLabel.frame = webView.bounds
            errorLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]

            webView.addSubview(errorLabel)
            self.errorView = errorLabel
        }
    }
}

#Preview {
    ContentView()
}

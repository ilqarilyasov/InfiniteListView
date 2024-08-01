//
//  InfiniteListViewModel.swift
//  InfiniteListView
//
//  Created by Ilqar Ilyasov on 8/1/24.
//

import SwiftUI
import WebKit

struct ListItem: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let url: URL?
    var children: [ListItem]?
}

class ListViewModel: ObservableObject {
    @Published var items: [ListItem] = []
    @Published var isLoading = false

    init() {
        loadMockData()
    }

    func loadMockData() {
        items = [
            ListItem(title: "Apple", url: URL(string: "https://www.apple.com"), children: nil),
            ListItem(title: "Google", url: URL(string: "https://www.google.com"), children: nil),
            ListItem(title: "More", url: nil, children: [
                ListItem(title: "Microsoft", url: URL(string: "https://www.microsoft.com"), children: nil),
                ListItem(title: "Amazon", url: URL(string: "https://www.amazon.com"), children: [
                    ListItem(title: "Amazon Web Services", url: URL(string: "https://aws.amazon.com"), children: nil),
                    ListItem(title: "Amazon Prime", url: URL(string: "https://www.primevideo.com"), children: [
                        ListItem(title: "Amazon Originals", url: URL(string: "https://www.primevideo.com/storefront/home/ref=atv_nb_sf_hm"), children: nil)
                    ])
                ])
            ]),
            ListItem(title: "Twitter", url: URL(string: "https://www.twitter.com"), children: nil),
            ListItem(title: "LinkedIn", url: URL(string: "https://www.linkedin.com"), children: nil),
            ListItem(title: "Invalid URL", url: URL(string: "https://www.nonexistentdomain1234.com"), children: nil)
        ]
    }

    func loadMoreData() {
        guard !isLoading else { return }
        isLoading = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            let newItems = [
                ListItem(title: "YouTube", url: URL(string: "https://www.youtube.com"), children: nil),
                ListItem(title: "Facebook", url: URL(string: "https://www.facebook.com"), children: nil),
                ListItem(title: "More", url: nil, children: [
                    ListItem(title: "Instagram", url: URL(string: "https://www.instagram.com"), children: nil),
                    ListItem(title: "Reddit", url: URL(string: "https://www.reddit.com"), children: [
                        ListItem(title: "Subreddit 1", url: URL(string: "https://www.reddit.com/r/subreddit1"), children: nil),
                        ListItem(title: "Subreddit 2", url: URL(string: "https://www.reddit.com/r/subreddit2"), children: [
                            ListItem(title: "Post 1", url: URL(string: "https://www.reddit.com/r/subreddit2/post1"), children: nil)
                        ])
                    ])
                ])
            ]
            self.items.append(contentsOf: newItems)
            self.isLoading = false
        }
    }
}

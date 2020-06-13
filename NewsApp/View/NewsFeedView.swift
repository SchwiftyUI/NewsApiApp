//
//  NewsFeedView.swift
//  NewsApp
//
//  Created by SchwiftyUI on 12/11/19.
//  Copyright © 2019 SchwiftyUI. All rights reserved.
//

import SwiftUI

struct NewsFeedView: View {
    @ObservedObject var newsFeed = NewsFeed()
    
    var body: some View {
        NavigationView {
            List(newsFeed) { (article: NewsListItem) in
                NavigationLink(destination: NewsListItemView(article: article)) {
                    NewsListItemListView(article: article)
                        .onAppear {
                            self.newsFeed.loadMoreArticles(currentItem: article)
                    }
                }
            }
        .navigationBarTitle("Apple News")
        }
    }
}

struct NewsListItemView: View {
    var article: NewsListItem
    
    var body: some View {
        UrlWebView(urlToDisplay: URL(string: article.url)!)
            .edgesIgnoringSafeArea(.all)
            .navigationBarTitle(article.title)
    }
}

struct NewsListItemListView: View {
    var article: NewsListItem
    
    var body: some View {
        HStack {
            UrlImageView(urlString: article.urlToImage)
            VStack(alignment: .leading) {
                Text("\(article.title)")
                    .font(.headline)
                Text("\(article.author ?? "No Author")")
                    .font(.subheadline)
            }
        }
    }
}

struct NewsFeedView_Previews: PreviewProvider {
    static var previews: some View {
        NewsFeedView()
    }
}

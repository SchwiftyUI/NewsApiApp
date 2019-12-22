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
        List(newsFeed) { (article: NewsListItem) in
            NewsListItemView(article: article)
                .onAppear {
                    self.newsFeed.loadMoreArticles(currentItem: article)
            }
        }
    }
}

struct NewsListItemView: View {
    var article: NewsListItem
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(article.title)")
                .font(.headline)
            Text("\(article.author ?? "No Author")")
                .font(.subheadline)
        }
        .padding()
    }
}

struct NewsFeedView_Previews: PreviewProvider {
    static var previews: some View {
        NewsFeedView()
    }
}

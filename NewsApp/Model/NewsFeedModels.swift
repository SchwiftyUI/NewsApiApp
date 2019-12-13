//
//  NewsFeedModels.swift
//  NewsApp
//
//  Created by SchwiftyUI on 12/11/19.
//  Copyright © 2019 SchwiftyUI. All rights reserved.
//

import Foundation

class NewsFeed: ObservableObject, RandomAccessCollection {
    typealias Element = NewsListItem
    
    @Published var newsListItems = [NewsListItem]()
    
    var startIndex: Int { newsListItems.startIndex }
    var endIndex: Int { newsListItems.endIndex }
    var nextPageToLoad = 1
    var currentlyLoading = false
    var doneLoading = false
    
    var urlBase = "https://newsapi.org/v2/everything?q=apple&apiKey=6ffeaceffa7949b68bf9d68b9f06fd33&language=en&page="
    
    init() {
        loadMoreArticles()
    }
    
    subscript(position: Int) -> NewsListItem {
        return newsListItems[position]
    }
    
    func loadMoreArticles(currentItem: NewsListItem? = nil) {
        
        if !shouldLoadMoreData(currentItem: currentItem) {
            return
        }
        currentlyLoading = true
        
        let urlString = "\(urlBase)\(nextPageToLoad)"
        let url = URL(string: urlString)!
        let task = URLSession.shared.dataTask(with: url, completionHandler: parseArticlesFromResponse(data:response:error:))
        task.resume()
    }
    
    func shouldLoadMoreData(currentItem: NewsListItem? = nil) -> Bool {
        if currentlyLoading || doneLoading {
            return false
        }
        
        guard let currentItem = currentItem else {
            return true
        }
        
        for n in (newsListItems.count - 4)...(newsListItems.count-1) {
            if n >= 0 && currentItem.uuid == newsListItems[n].uuid {
                return true
            }
        }
        return false
    }
    
    func parseArticlesFromResponse(data: Data?, response: URLResponse?, error: Error?) {
        guard error == nil else {
            print("Error: \(error!)")
            currentlyLoading = false
            return
        }
        guard let data = data else {
            print("No data found")
            currentlyLoading = false
            return
        }
        
        let newArticles = parseArticlesFromData(data: data)
        DispatchQueue.main.async {
            self.newsListItems.append(contentsOf: newArticles)
            self.nextPageToLoad += 1
            self.currentlyLoading = false
            self.doneLoading = (newArticles.count == 0)
        }
    }
    
    func parseArticlesFromData(data: Data) -> [NewsListItem] {
        let jsonObject = try! JSONSerialization.jsonObject(with: data)
        let topLevelMap = jsonObject as! [String: Any]
        guard topLevelMap["status"] as? String == "ok" else {
            print("Status returned was not OK")
            return []
        }
        guard let jsonArticles = topLevelMap["articles"] as? [[String: Any]] else {
            print("No articles found")
            return []
        }
        
        var newArticles = [NewsListItem]()
        for jsonArticle in jsonArticles {
            guard let title = jsonArticle["title"] as? String else {
                continue
            }
            guard let author = jsonArticle["author"] as? String else {
                continue
            }
            newArticles.append(NewsListItem(title: title, author: author))
        }
        return newArticles
    }
}

class NewsListItem: Identifiable {
    var uuid = UUID()
    
    var author: String
    var title: String
    
    init(title: String, author: String) {
        self.title = title
        self.author = author
    }
}

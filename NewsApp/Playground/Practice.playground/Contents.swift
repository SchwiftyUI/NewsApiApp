import UIKit

var greeting = "Hello, playground"

// https://reactnative.dev/movies.json

func fetch() {
    
    guard let url = URL(string: "https://reactnative.dev/movies.json") else { return }
    
    let dataTask = URLSession.shared.dataTask(with: url) { data, _, error in
        
        if let error = error { print("Error fetching data: \(error.localizedDescription)"); return }
        
        guard let data = data else { return }
        
        print(data)
        
    }
    
    dataTask.resume()
}

fetch()

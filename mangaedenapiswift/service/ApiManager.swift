	//
//  ApiManager.swift
//  mangaedenapiswift
//
//  Created by Jeremy on 18/05/2018.
//  Copyright © 2018 Jeremy. All rights reserved.
//

import Foundation

class ApiManager {
    let baseApiUrl: URL! = URL(string: "https://www.mangaeden.com/api/")
    let baseCdnUrl: URL! = URL(string: "https://cdn.mangaeden.com/mangasimg/")
    let mangaListPath: String = "list/0"
    let mangaDetailPath: String = "manga/"
    let chapterDetailPath: String = "chapter/"
    let decoder = JSONDecoder()
    
    static let instance = ApiManager()
    
    func getMangaListUrl() -> URL {
        let mangaListUrl = baseApiUrl.appendingPathComponent(mangaListPath)
        
        return mangaListUrl
    }
    
    func getMangaDetailUrl() -> URL {
        let mangaDetailUrl = baseApiUrl.appendingPathComponent(mangaDetailPath)
        
        return mangaDetailUrl
    }
    
    func getMangaListData(completion: @escaping ([String: Any]?, Error?) -> ()) {
        let mangaDetailUrl = getMangaListUrl()
    
        let urlRequest = URLRequest(url: mangaDetailUrl)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            if(error != nil) {
                completion(nil, error)
            } else {
                if data != nil {
                    do {
                        let jsonData = try JSONSerialization.jsonObject(with: data!, options: [])
                        
                        if let mangaData = jsonData as? [String: Any] {
                            completion(mangaData, nil)
                        }
                    } catch let error as NSError {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
    
    func getImageUrl(imagePath: String) -> URL {
        let imageUrl = baseCdnUrl.appendingPathComponent(imagePath)
        return imageUrl
    }
}

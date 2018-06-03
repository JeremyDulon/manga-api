//
//  MangaSearchController.swift
//  mangaedenapiswift
//
//  Created by Jeremy on 27/04/2018.
//  Copyright © 2018 Jeremy. All rights reserved.
//

import UIKit
import os.log

class SearchMangaController: UICollectionViewController {
    
    var mangaCollection: [MangaModel] = [MangaModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ApiManager.instance.getMangaListData() { (mangaData, error) in
            for manga in mangaData?["manga"] as! [[String: Any]] {
                let mangaParsed = MangaModel(jsonData: manga)
                self.mangaCollection.append(mangaParsed)
                break
            }
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }
    }
    
}

extension SearchMangaController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mangaCollection.count
    }
    
    override func collectionView (_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mangaCell", for: indexPath) as! MangaCollectionViewCell
        
        print(cell)
        let manga = mangaCollection[indexPath.row]
//        let imageUrlPath = manga.image
//        let imageUrl = ApiManager.instance.getImageUrl(imagePath: imageUrlPath!)
//        let label = manga.title
//        cell.displayContent(imageUrl: imageUrl, label: label!)
        cell.mangaLabel.text = manga.title
        
        return cell
    }
}

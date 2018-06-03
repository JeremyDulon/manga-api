//
//  MangaSearchController.swift
//  mangaedenapiswift
//
//  Created by Jeremy on 27/04/2018.
//  Copyright © 2018 Jeremy. All rights reserved.
//

import UIKit
import SDWebImage
import os.log

class SearchMangaController: UICollectionViewController {
    
    var mangaCollection: [MangaModel] = [MangaModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        ApiManager.instance.getMangaListData() { (mangaData, error) in
            for manga in mangaData?["manga"] as! [[String: Any]] {
                let mangaParsed = MangaModel(jsonData: manga)
                self.mangaCollection.append(mangaParsed)
            }
            self.mangaCollection.sort(by: {$0.hits as! Int64 > $1.hits as! Int64})
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
        let nibName = UINib(nibName: "MangaCollectionViewCell", bundle: nil)
        collectionView.register(nibName, forCellWithReuseIdentifier: "mangaCell")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mangaCell", for: indexPath) as! MangaCollectionViewCell
        let manga = mangaCollection[indexPath.row]
        let imageUrlPath = manga.image
        if(imageUrlPath != nil) {
            let imageUrl = ApiManager.instance.getImageUrl(imagePath: imageUrlPath!)
            cell.mangaImage.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "placeholder"), options: SDWebImageOptions.retryFailed, completed: nil)
        } else {
            cell.mangaImage.image = UIImage(named: "placeholder")
        }
        cell.mangaImage.contentMode = .scaleToFill
        cell.mangaLabel.text = manga.title
        
        return cell
    }
}

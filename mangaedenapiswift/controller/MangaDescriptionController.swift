//
//  MangaDescriptionController.swift
//  mangaedenapiswift
//
//  Created by Jeremy on 04/06/2018.
//  Copyright © 2018 Jeremy. All rights reserved.
//
import UIKit
import SDWebImage
import os.log

class ChapterModel {
    var number: Int64?
    var releaseDate: Float64?
    var title: String?
    var id: String?
    
    init(jsonData: [Any]) {
        self.number = jsonData[0] as? Int64
        self.releaseDate = jsonData[1] as? Float64
        self.title = jsonData[2] as? String
        self.id = jsonData[3] as? String
        
        if(self.title == nil) {
            self.title = "Chapter " + self.number!.description
        }
    }
}

class MangaDescriptionController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var mangaTitleLabel: UILabel!
    @IBOutlet weak var mangaAuthorLabel: UILabel!
    @IBOutlet weak var mangaDescriptionLabel: UILabel!
    @IBOutlet weak var mangaPicker: UIPickerView!
    @IBOutlet weak var mangaImage: UIImageView!
    @IBOutlet weak var readChapter: UIButton!
    
    var mangaId: String = String()
    var mangaData: [String: Any] = [String: Any]()
    var chapters: [[String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mangaPicker.dataSource = self
        mangaPicker.delegate = self
    
        ApiManager.instance.getMangaDetailData(mangaId: self.mangaId) { (mangaData, error) in
            self.mangaData = mangaData!
            
            for chapter in mangaData?["chapters"] as! [[Any]] {
                let chapterParsed = ChapterModel(jsonData: chapter)
                if (chapterParsed.number != nil) {
                    let chapterArray = [chapterParsed.id!, chapterParsed.title!]
                    self.chapters.append(chapterArray)
                }
            }

            DispatchQueue.main.async {
                self.mangaTitleLabel.text = mangaData?["title"] as? String
                self.mangaAuthorLabel.text = mangaData?["author"] as? String
                self.mangaDescriptionLabel.text = mangaData?["description"] as? String
                let imageUrlPath = mangaData?["image"] as? String
                if(imageUrlPath != nil) {
                    let imageUrl = ApiManager.instance.getImageUrl(imagePath: imageUrlPath!)
                    self.mangaImage.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "placeholder"), options: SDWebImageOptions.retryFailed, completed: nil)
                } else {
                    self.mangaImage.image = UIImage(named: "placeholder")
                }
                self.mangaImage.contentMode = .scaleAspectFill
                self.mangaPicker.reloadAllComponents()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "readChapterSegue" {
            if let destinationViewController = segue.destination as? ReadChapterController {
                let selectedRow = self.mangaPicker.selectedRow(inComponent: 0)
                print(selectedRow)
                destinationViewController.chapterId = self.chapters[selectedRow][0]
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return chapters.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return chapters[row][1]
    }
}

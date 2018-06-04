//
//  ReadChapterController.swift
//  mangaedenapiswift
//
//  Created by Jeremy on 04/06/2018.
//  Copyright © 2018 Jeremy. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

// TODO: Export in file
class ChapterImageModel {
    var pageId: Int64?
    var imagePath: String?
    var pageHeight: Int64?
    var pageWidth: Int64?
    
    init(jsonData: [Any]) {
        self.pageId = jsonData[0] as? Int64
        self.imagePath = jsonData[1] as? String
        self.pageHeight = jsonData[2] as? Int64
        self.pageWidth = jsonData[3] as? Int64
    }
}

class ReadChapterController: UIPageViewController {
    @IBOutlet weak var imageScrollView: UIScrollView!
    
    var chapterId: String = String()
    var imagesData: [Any] = [Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.createImageSlides()
    }
    
    func createImageSlides(){
        var slides: [Slide] = []
        var images: [URL] = []
        
        ApiManager.instance.getChapterImagesData(chapterId: self.chapterId) { (imagesData, error) in
            
            for image in imagesData!["images"] as! [[Any]] {
                let imageParsed = ChapterImageModel(jsonData: image)
                let imageUrl = ApiManager.instance.getImageUrl(imagePath: imageParsed.imagePath!)
                images.append(imageUrl)
            }
            
            DispatchQueue.main.async {
                for imageUrl in images {
                    let slide: Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
                    slide.image.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "placeholder"), options: SDWebImageOptions.retryFailed, completed: nil)
                    
                    slides.append(slide)
                }
                self.setupSlideScrollView(slides: slides)
            }
        }
    }
    
    func setupSlideScrollView(slides: [Slide]) {
        self.imageScrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        self.imageScrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: view.frame.height)
        
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            self.imageScrollView!.addSubview(slides[i])
        }
    }
}

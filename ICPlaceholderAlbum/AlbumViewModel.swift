//
//  AlbumViewModel.swift
//  ICPlaceholderAlbum
//
//  Created by 胡仁恩 on 2019/9/23.
//  Copyright © 2019 alexHu. All rights reserved.
//

import Foundation

protocol AlbumViewModelDelegate {
    
    func viewModel(_ viewModel: AlbumViewModel, didUpdateAlbumPageData data: [PhotoContent])
    
}

class AlbumViewModel {
    
    var delegate: AlbumViewModelDelegate?
    
    private(set) var photoContents = [PhotoContent]() {
        didSet {
            delegate?.viewModel(self, didUpdateAlbumPageData: photoContents)
        }
    }
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(processingDataToArray(_:)), name: NSNotification.Name(rawValue: "GetJSON"), object: nil)
    }
    
    @objc
    func processingDataToArray(_ notification: Notification) {
        print("selector")
        if let userInfo = notification.userInfo {
            if let contents = userInfo["PhotoContents"] as? [PhotoContent] {
                
                self.photoContents = contents
                var temps = [PhotoContent]()
                for v in contents {
                    temps.append(v)
                }
                
                self.photoContents = temps
            }
        }
    }
    
    func getData() {
        DataManager.shared.getAlbumJSON { (contents) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GetJSON"), object: self, userInfo: ["PhotoContents": contents])
        }
    }

}

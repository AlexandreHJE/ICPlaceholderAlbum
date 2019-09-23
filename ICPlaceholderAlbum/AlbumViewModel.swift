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
    
    func viewModel(_ viewModel: AlbumViewModel, didReceiveError error: Error)
    
}

class AlbumViewModel {
    
    var delegate: AlbumViewModelDelegate?
    
    private(set) var photoContents = [PhotoContent]() {
        didSet {
            delegate?.viewModel(self, didUpdateAlbumPageData: photoContents)
        }
    }
    
    private(set) var connectionError = Error.self {
        didSet {
            delegate?.viewModel(self, didReceiveError: connectionError as! Error)
        }
    }
    
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(processingDataToArray(_:)), name: NSNotification.Name(rawValue: "GetJSON"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(processingDataToArray(_:)), name: NSNotification.Name(rawValue: "GetJSONError"), object: nil)
    }
    
    @objc
    func processingDataToArray(_ notification: Notification) {
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
    
    @objc
    func failedToGetJSON(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            if let error = userInfo["ConnectionError"] as? Error {
                self.connectionError = error as! Error.Protocol
            }
        }
    }
    
    func getData() {
        DataManager.shared.getAlbumJSON { (contents, error) in
            if let contents: [PhotoContent] = contents {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GetJSON"), object: self, userInfo: ["PhotoContents": contents])
            } else {
                if let error: Error = error {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GetJSONError"), object: self, userInfo: ["ConnectionError": error])
                }
            }
        }
    }

}

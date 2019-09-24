//
//  AlbumViewModel.swift
//  ICPlaceholderAlbum
//
//  Created by 胡仁恩 on 2019/9/23.
//  Copyright © 2019 alexHu. All rights reserved.
//

import Foundation

protocol AlbumViewModelDelegate: class {
    
    func viewModel(_ viewModel: AlbumViewModel, didUpdateAlbumPageData data: [PhotoContent])
    
    func viewModel(_ viewModel: AlbumViewModel, didReceiveError error: Error)
    
}

class AlbumViewModel {
    
    weak var delegate: AlbumViewModelDelegate?
    
    private(set) var photoContents = [PhotoContent]() {
        didSet {
            delegate?.viewModel(self, didUpdateAlbumPageData: photoContents)
        }
    }
    
    private(set) var connectionError: Error? {
        didSet {
            if let error = connectionError {
                delegate?.viewModel(self, didReceiveError: error)
            }
        }
    }
    
    
    func getData(_ completion: ((Result<[PhotoContent], Error>) -> Void)?) {
        DataManager.shared.getAlbumJSON { [weak self] (result) in
            switch result {
            case .failure(let error):
                self?.connectionError = error
                
                
            case .success(let photoContents):
                self?.photoContents = photoContents
                
            }
        }
    }

}

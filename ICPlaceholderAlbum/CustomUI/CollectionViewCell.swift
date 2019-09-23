//
//  CollectionViewCell.swift
//  InterviewTask
//
//  Created by 胡仁恩 on 2019/9/20.
//  Copyright © 2019 alexHu. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    var task: URLSessionTask?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

        image.contentMode = .scaleToFill
        image.clipsToBounds = true
    }
    
    
    
    func loadImage(with url: URL) {
        image.image = nil
        if let task: URLSessionTask = task {
            task.cancel()
        }
        task = nil
        task = DataManager.shared.fetchImage(with: url) { [weak self] (data, response, error) in
            guard let `self` = self, let data: Data = data else {
                return
            }
            let image: UIImage? = UIImage(data: data)
            DispatchQueue.main.async {
                self.image.image = image
            }
        }
        task?.resume()
    }
    
}

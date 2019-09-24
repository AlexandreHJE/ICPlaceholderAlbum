//
//  HomePageViewController.swift
//  ICPlaceholderAlbum
//
//  Created by 胡仁恩 on 2019/9/23.
//  Copyright © 2019 alexHu. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController {

    let requestApiButton: UIButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setRequestApiButton()
    }
    
    func setRequestApiButton() {
        requestApiButton.setTitle("Request Photo Api", for: .normal)
        requestApiButton.addTarget(self, action: #selector(pushAlbumView(_:)), for: .touchUpInside)
        
        requestApiButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(requestApiButton)
        requestApiButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        requestApiButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        requestApiButton.sizeToFit()
    }
    
    
    @objc
    func pushAlbumView(_ button: UIButton) {
        
        let albumViewController = AlbumViewController()
        
        navigationController?.pushViewController(albumViewController, animated: true)
    }
}

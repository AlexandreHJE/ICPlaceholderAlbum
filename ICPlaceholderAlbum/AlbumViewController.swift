//
//  ViewController.swift
//  ICPlaceholderAlbum
//
//  Created by 胡仁恩 on 2019/9/23.
//  Copyright © 2019 alexHu. All rights reserved.
//

import UIKit

class AlbumViewController: UIViewController {

    private let viewModel = AlbumViewModel()
    
    let slice = (UIScreen.main.bounds.width / CGFloat(4.0))
    let collectionViewCellID = "CollectionViewCell"
    
    lazy var loadingView: UIActivityIndicatorView = {
        let loadingView = UIActivityIndicatorView()
        return loadingView
    }()
    
    lazy var flowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: slice, height: slice)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        flowLayout.scrollDirection = .vertical
        return flowLayout
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: collectionViewCellID, bundle: nil), forCellWithReuseIdentifier: collectionViewCellID)
        collectionView.backgroundColor = .white
        
        return collectionView
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        setCollectionView()
        setLoadingView()
        triggerToFetchData()
        
    }

    func setCollectionView() {
        self.view.addSubview(self.collectionView)
        self.collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        self.collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        self.collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
    
    func setLoadingView() {
        self.view.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        self.loadingView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.loadingView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        self.loadingView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        self.loadingView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        loadingView.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        loadingView.style = .whiteLarge
        loadingView.hidesWhenStopped = true
    }
    
    func triggerToFetchData() {
        loadingView.startAnimating()
        defer {
            DispatchQueue.main.async {
                self.loadingView.stopAnimating()
            }
        }
        self.viewModel.getData { [weak self] (result) in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlertMessage(with: error.localizedDescription)
                }
            case .success( _):
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            }
        }
//        self.viewModel.delegate = self
    }
    
}

extension AlbumViewController: AlbumViewModelDelegate {
    func viewModel(_ viewModel: AlbumViewModel, didReceiveError error: Error) {
        DispatchQueue.main.async {
            self.loadingView.stopAnimating()
            self.showAlertMessage(with: "Failed To Fetch JSON Data. \nPlease check your internet connection.")
        }
    }
    
    func viewModel(_ viewModel: AlbumViewModel, didUpdateAlbumPageData data: [PhotoContent]) {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.loadingView.stopAnimating()
        }
    }
    
    func showAlertMessage(with message: String) {
        
        let alert: UIAlertController = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        let retry: UIAlertAction = UIAlertAction(title: "Retry", style: .default) { [weak self] (_) in
            self?.triggerToFetchData()
            self?.dismiss(animated: true, completion: nil)
        }
        let cancel: UIAlertAction = UIAlertAction(title: "cancel", style: .default) { [weak self] (_) in
            self?.dismiss(animated: true, completion: nil)
        }
        alert.addAction(retry)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
   }
}

extension AlbumViewController: UICollectionViewDelegate {
    
}

extension AlbumViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.photoContents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellInfo = viewModel.photoContents[indexPath.item]
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellID, for: indexPath) as? CollectionViewCell else {
            
            return collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellID, for: indexPath)
        }
        
        cell.idLabel.text = String(cellInfo.id)
        cell.titleLabel.text = cellInfo.title
        if let thumbnailUrl: URL = URL(string: cellInfo.thumbnailUrl) {
            cell.loadImage(with: thumbnailUrl)
        }
        
        return cell
    }
    
    
}

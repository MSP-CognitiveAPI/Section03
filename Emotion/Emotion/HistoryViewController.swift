//
//  HistoryViewController.swift
//  Emotion
//
//  Created by BumMo Koo on 2016. 11. 12..
//  Copyright © 2016년 BumMo Koo. All rights reserved.
//

import UIKit
import RealmSwift

class HistoryViewController: UIViewController {
    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    fileprivate var photos: Results<Photo>?
    fileprivate var faces: Results<Face>?
    fileprivate var token: NotificationToken?
    
    fileprivate var showPhotos = true
    
    // MARK: View
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        do {
            let realm = try Realm()
            photos = realm.objects(Photo.self)
            faces = realm.objects(Face.self)
            
            token = realm.addNotificationBlock({ [weak self] (notification, _) in
                self?.collectionView.reloadData()
            })
        } catch {
            
        }
    }
    
    deinit {
        token?.stop()
    }
    
    // MARK: Action
    @IBAction private func tappedMode(sender: UIButton) {
        showPhotos = !showPhotos
        collectionView.reloadData()
    }
}

extension HistoryViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    // MARK: Data source
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if showPhotos == true {
            return photos?.count ?? 0
        } else {
            return faces?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PhotoCell
        if showPhotos == true {
            if let photo = photos?[indexPath.row] {
                cell.imageView.image = photo.image
            }
        } else {
            if let face = faces?[indexPath.row] {
                var image = face.photos.first?.image
                if let rect = face.faceRect?.cgRect {
                    image = image?.crop(rect: rect)
                }
                cell.imageView.image = image
            }
        }
        return cell
    }
    
    // MARK: Delegate flow layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let side = (collectionView.bounds.width - 2) / 3
        return CGSize(width: side, height: side)
    }
}

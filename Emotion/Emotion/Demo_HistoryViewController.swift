//
//  Demo_HistoryViewController.swift
//  Emotion
//
//  Created by BumMo Koo on 2016. 11. 16..
//  Copyright © 2016년 BumMo Koo. All rights reserved.
//

import UIKit
import RealmSwift

extension HistoryViewController {
    func handleGroupFaces() {
        guard let photos = self.photos else { return }
        var completeCount = 0
        for photo in photos {
            API.detectFaces(photo: photo, handler: { [weak self] (faces) in
                completeCount += 1
                if completeCount == photos.count {
                    guard let results = self?.realm?.objects(IdentifiableFace.self) else { return }
                    var faces = [IdentifiableFace]()
                    for result in results {
                        faces.append(result)
                    }
                    API.groupFaces(faces: faces, handler: { [weak self] (groups, messyGroup) in
                        self?.groups = groups
                        self?.messyGroup = messyGroup
                        self?.facesGrouped = true
                        DispatchQueue.main.async {
                            self?.collectionView.reloadData()
                        }
                    })
                }
            })
        }
    }
}

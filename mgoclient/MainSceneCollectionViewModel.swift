//
//  MainSceneCollectionViewModel.swift
//  mgoclient
//
//  Created by Gustavo Halperin on 9/25/14.
//  Copyright (c) 2014 mgo. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit


class MainSceneCollectionViewModel: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    var _numberOfCells:Int!
    var _completion : ((NSDictionary) -> Void)!
    
    override init() {
        _numberOfCells = 0
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _numberOfCells
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var mainSceneCollectionViewCell:MainSceneCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(
            "MainSceneCollectionViewCellId",
            forIndexPath: indexPath) as MainSceneCollectionViewCell
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        var videoProperties:NSArray = appDelegate._videoProperties
        var dictionary:NSDictionary = videoProperties[indexPath.row] as NSDictionary
        mainSceneCollectionViewCell._properties = dictionary
        
        if (   mainSceneCollectionViewCell.gestureRecognizers == nil
            || mainSceneCollectionViewCell.gestureRecognizers?.count == 0 ){
                var tapOnImageViewGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action:"tapOnImageViewAction:" )
                mainSceneCollectionViewCell.addGestureRecognizer(tapOnImageViewGestureRecognizer)
        }
        
        mainSceneCollectionViewCell.backgroundColor = SKColor.clearColor()

        
        return mainSceneCollectionViewCell
    }
    
    
    @IBAction func tapOnImageViewAction(sender: UITapGestureRecognizer) {
        var mainSceneCollectionViewCell:MainSceneCollectionViewCell = sender.view as MainSceneCollectionViewCell
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            mainSceneCollectionViewCell._imageView.transform = CGAffineTransformMakeScale(0.8, 0.8)
            }) { (ended Bool) -> Void in
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    mainSceneCollectionViewCell._imageView.transform = CGAffineTransformMakeScale(1.2, 1.2)
                    }, completion: { (ended Bool) -> Void in
                        UIView.animateWithDuration(0.3, animations: { () -> Void in
                            mainSceneCollectionViewCell._imageView.transform = CGAffineTransformMakeScale(1, 1)
                            self._completion(mainSceneCollectionViewCell._properties)
                        })
                })
        }
    }
}
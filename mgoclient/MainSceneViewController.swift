//
//  MainSceneViewController.swift
//  mgoclient
//
//  Created by Gustavo Halperin on 9/25/14.
//  Copyright (c) 2014 mgo. All rights reserved.
//

import Foundation
import UIKit


class MainSceneViewController: UIViewController {

    @IBOutlet private var _mainSceneCollectionViewModel: MainSceneCollectionViewModel!
    
    @IBOutlet private weak var _collectionView: UICollectionView!
    @IBOutlet private weak var _collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _mainSceneCollectionViewModel._numberOfCells = 6
        _mainSceneCollectionViewModel._completion = self.performSegueWithIconId
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "orientationChanged:", name:UIDeviceOrientationDidChangeNotification , object: nil)
        
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    
    override func viewDidLayoutSubviews() {
        var collectionViewFrame:CGRect = _collectionView.frame
        var minSize:CGFloat = min(collectionViewFrame.size.width, collectionViewFrame.size.height) / 2.0
        var maxSize:CGFloat = max(collectionViewFrame.size.width, collectionViewFrame.size.height) / 3.0
        var cellSideSize:CGFloat = min(minSize, maxSize) * 0.9
        if ( collectionViewFrame.size.width > collectionViewFrame.size.height) {
            _collectionViewFlowLayout.minimumInteritemSpacing = (collectionViewFrame.size.width - cellSideSize * 3.0 ) / 2.0
            _collectionViewFlowLayout.minimumLineSpacing = collectionViewFrame.size.height - cellSideSize * 2.0
        }
        else {
            _collectionViewFlowLayout.minimumInteritemSpacing = collectionViewFrame.size.width - cellSideSize * 2.0
            _collectionViewFlowLayout.minimumLineSpacing = (collectionViewFrame.size.height - cellSideSize * 3.0 ) / 2.0
        }
        
        _collectionViewFlowLayout.itemSize = CGSizeMake(cellSideSize, cellSideSize)
        
        _collectionView.reloadData()
    }
    
    func orientationChanged(notification:NSNotification) {
        
        var collectionViewFrame:CGRect = _collectionView.frame
        var minSize:CGFloat = min(collectionViewFrame.size.width, collectionViewFrame.size.height) / 2.0
        var maxSize:CGFloat = max(collectionViewFrame.size.width, collectionViewFrame.size.height) / 3.0
        var cellSideSize:CGFloat = min(minSize, maxSize) * 0.9
        if ( collectionViewFrame.size.width > collectionViewFrame.size.height) {
            _collectionViewFlowLayout.minimumInteritemSpacing = (collectionViewFrame.size.width - cellSideSize * 3.0 ) / 2.0
            _collectionViewFlowLayout.minimumLineSpacing = collectionViewFrame.size.height - cellSideSize * 2.0
        }
        else {
            _collectionViewFlowLayout.minimumInteritemSpacing = collectionViewFrame.size.width - cellSideSize * 2.0
            _collectionViewFlowLayout.minimumLineSpacing = (collectionViewFrame.size.height - cellSideSize * 3.0 ) / 2.0
        }
        _collectionViewFlowLayout.minimumInteritemSpacing *= 0.95
        _collectionViewFlowLayout.minimumLineSpacing *= 0.95
        
        _collectionViewFlowLayout.itemSize = CGSizeMake(cellSideSize, cellSideSize)
        
        _collectionView.reloadData()
    }
    
    
    @IBAction func logOutAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion:nil)
    }
    
    func performSegueWithIconId(properties:NSDictionary) {
        self.performSegueWithIdentifier("VideoInfoSegueId", sender: properties)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "VideoInfoSegueId" {
            let infoViewController:InfoViewController = segue.destinationViewController as InfoViewController
            infoViewController._properties = sender as NSDictionary
        }
    }
    
}

//
//  InfoViewController.swift
//  mgoclient
//
//  Created by Gustavo Halperin on 9/26/14.
//  Copyright (c) 2014 mgo. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import AVFoundation

class InfoViewController: UIViewController {
    var _properties:NSDictionary = NSDictionary() {
        didSet {
            if self.isViewLoaded() {
                _titleLabel.text = _properties.objectForKey("title") as? String
            }
        }
    }
    
    @IBOutlet weak var _titleLabel: UILabel!
    @IBOutlet weak var _descriptionTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        if( _titleLabel.text?.lengthOfBytesUsingEncoding(NSASCIIStringEncoding) <= 0 && _properties.allKeys.count > 0 ){
            _titleLabel.text = _properties.objectForKey("title") as? String
        }
    }
    
    @IBAction func backButtonAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func logOutAction(sender: AnyObject) {
        self.view.window?.rootViewController?.dismissViewControllerAnimated(
            true,
            completion: { () -> Void in
        })
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PlayVideoSegueId" {
            var playerViewController:AVPlayerViewController = segue.destinationViewController as AVPlayerViewController
            var video:String = _properties.objectForKey("video") as String
            var videoType:String = _properties.objectForKey("videoType") as String
            var string:String = NSBundle.mainBundle().pathForResource(video, ofType: videoType)!
            var url:NSURL = NSURL(fileURLWithPath: string)
            playerViewController.player = AVPlayer(URL: url)
        }
        if segue.identifier == "LiveStreamSegueId" {
            var playerViewController:AVPlayerViewController = segue.destinationViewController as AVPlayerViewController
            var string:String = _properties.objectForKey("hls") as String
            var url:NSURL = NSURL(string: string)
            playerViewController.player = AVPlayer(URL: url)
        }
    }
    
    @IBAction func swipeRightAction(sender: AnyObject) {
        self.backButtonAction(sender)
    }
    
}

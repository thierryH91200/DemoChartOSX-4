//
//  AlbumArtViewController.swift
//  minimalTunes
//
//  Created by John Moody on 12/1/16.
//  Copyright © 2016 John Moody. All rights reserved.
//

import AppKit

class AlbumArtViewController: NSViewController {
    
    @IBOutlet weak var collectionButton: NSButton!
    @IBOutlet weak var outlineButton: NSButton!
    @IBOutlet weak var imageView: NSImageView!
    
    var mainWindowController: MainWindowController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        outlineButton.state = .on
        //loadAlbumArtWindow()
    }
    
    func loadAlbumArtWindow() {
        print("loading album art window")
        let image = mainWindowController?.radarChartViewController.view.image()
        imageView.image = image
    }
    
    @IBAction func radioButtonChanged(_ sender: Any) {
        mainWindowController?.collection = collectionButton.state
        mainWindowController?.setUpSourceList()
    }
}

extension NSView {
    
    /// Get `NSImage` representation of the view.
    ///
    /// - Returns: `NSImage` of view
    func image() -> NSImage {
        let imageRepresentation = bitmapImageRepForCachingDisplay(in: bounds)!
        cacheDisplay(in: bounds, to: imageRepresentation)
        return NSImage(cgImage: imageRepresentation.cgImage!, size: bounds.size)
    }
}

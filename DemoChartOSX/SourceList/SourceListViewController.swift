//
//  TrackQueueViewController.swift
//  minimalTunes
//
//  Created by John Moody on 12/1/16.
//  Copyright © 2016 John Moody. All rights reserved.
//

import AppKit

class SourceListViewController: NSViewController {
        

    @IBOutlet weak var outlineView: NSOutlineView!
    
    var feeds = [Feed]()
    var mainWindowController: MainWindowController?


    override func viewDidLoad() {
        super.viewDidLoad()
        
        feedList("Feeds")
    }
    
    override open func viewDidAppear()
    {
        super.viewDidAppear()
        
        outlineView.reloadData()
        
        outlineView.expandItem(nil, expandChildren: true)
        outlineView.selectionHighlightStyle = .sourceList
        outlineView.scrollRowToVisible(0)
        
        let array = [1]
        outlineView.selectRowIndexes(IndexSet(array), byExtendingSelection: false)
    }
    
    func toggleHidden(_ state: Int) {
        switch state {
        case 1:
            outlineView?.isHidden = false
        default:
            outlineView?.isHidden = true
        }
    }
    
    func feedList(_ fileName: String) {
        
        let url2      = Bundle.main.url (forResource: fileName, withExtension: "plist")!

        let data = try! Data(contentsOf: url2)
        feeds = try! data.decoded()
        feeds = feeds.sorted{ $0.name < $1.name}
        
        // or
        // datas = try! data.decoded() as [Donnees]

        // or
        // let plistDecoder = PropertyListDecoder()
        // datas = try! plistDecoder.decode([Donnees].self, from: data)
    }

}

extension SourceListViewController: NSOutlineViewDataSource
{
    //ok-------
    public func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int
    {
        if let feed = item as? Feed {
            return feed.children.count
        }
        //2
        return feeds.count
    }
    
    //ok--------------
    public func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any
    {
        if let feed = item as? Feed
        {
            return feed.children[index]
        }
        return feeds[index]
    }
    
    //ok---------------
    public func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool
    {
        if let feed = item as? Feed
        {
            return feed.children.count > 0
        }
        return false
    }
    
    
    //    Don't show the expander triangle for group items..
    // ok
    public func outlineView(_ outlineView: NSOutlineView, shouldShowOutlineCellForItem item: Any) -> Bool
    {
        return isSourceGroupItem(item)
    }
    
    // ok
    public func outlineView(_ outlineView: NSOutlineView, shouldSelectItem item: Any) -> Bool
    {
        return !self.isSourceGroupItem(item)
    }
    
    // ok
    public func outlineView(_ outlineView: NSOutlineView, isGroupItem item: Any) -> Bool
    {
        return isSourceGroupItem(item)
    }
    
    // ok
    public func outlineView(_ outlineView: NSOutlineView, heightOfRowByItem item: Any) -> CGFloat {
        //    Make the height of Source Group items a little higher
        if self.isSourceGroupItem(item) {
            return outlineView.rowHeight + 5.0
        }
        return outlineView.rowHeight
    }
    
    //    Method to determine if an outline item is a source group
    // ok
    func isSourceGroupItem(_ item: Any) -> Bool
    {
        if let feed = item as? Feed
        {
            return feed.isSourceGroup
        }
        return false
    }
}

extension SourceListViewController: NSOutlineViewDelegate
{
    public func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView?
    {
        var view: NSTableCellView?
        
        if let feed = item as? Feed
        {
            view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "FeedCell"), owner: self) as? NSTableCellView
            if let textField = view?.textField
            {
                textField.stringValue = feed.name.uppercased()
                //                textField.font = NSFont.boldSystemFont(ofSize: 14.0)
                
            }
        }
        else
        {
            if let feedItem = item as? Children
            {
                view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "FeedItemCell"), owner: self) as? NSTableCellView
                if let textField = view?.textField
                {
                    textField.stringValue = feedItem.type
                    textField.textColor = NSColor.black
                }
            }
        }
        return view
    }
    
    //NSOutlineViewDelegate
    public func outlineViewSelectionDidChange(_ notification: Notification)
    {
        guard let outlineView = notification.object as? NSOutlineView else { return }
        
        let selectedIndex = outlineView.selectedRow
        if let feedItem = outlineView.item(atRow: selectedIndex) as? Children
        {
            let name =  feedItem.name
            mainWindowController?.changeView(name: name)
        }
    }
}



//
//  FeedItem.swift
//  ChartsDemo-OSX
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  Copyright © 2017 thierry Hentic.
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/ios-charts

import Foundation
import Charts

open class YMarkerView: BalloonMarker
{
    open var yAxisValueFormatter: AxisValueFormatter?
    fileprivate var yFormatter = NumberFormatter()
    
    public init(color: NSUIColor, font: NSUIFont, textColor: NSUIColor, insets: NSEdgeInsets, yAxisValueFormatter : AxisValueFormatter)
    {
        super.init(color: color, font: font, textColor: textColor, insets: insets)
        
        self.yAxisValueFormatter = yAxisValueFormatter
        yFormatter.minimumFractionDigits = 1
        yFormatter.maximumFractionDigits = 1
    }
    
    open override func refreshContent(entry: ChartDataEntry, highlight: Highlight)
    {
        setLabel("y: " + yAxisValueFormatter!.stringForValue(entry.y, axis: nil))
    }
}




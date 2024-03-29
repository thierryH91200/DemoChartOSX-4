//
//  XYMarkerView.swift
//  ChartsDemo-OSX
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/ios-charts

import Foundation
import Charts

open class XYMarkerView: BalloonMarker
{
    open var xAxisValueFormatter: AxisValueFormatter?
    open var yAxisValueFormatter: AxisValueFormatter?
    fileprivate var yFormatter = NumberFormatter()
    
    public init(color: NSUIColor, font: NSUIFont, textColor: NSUIColor, insets: NSEdgeInsets, xAxisValueFormatter: AxisValueFormatter, yAxisValueFormatter :  AxisValueFormatter)
    {
        super.init(color: color, font: font, textColor: textColor, insets: insets)
        self.xAxisValueFormatter = xAxisValueFormatter
        self.yAxisValueFormatter = yAxisValueFormatter
        yFormatter.minimumFractionDigits = 1
        yFormatter.maximumFractionDigits = 1
    }
    
    open override func refreshContent(entry: ChartDataEntry, highlight: Highlight)
    {
        let x = entry.x
        let y = entry.y
        setLabel("x: " + xAxisValueFormatter!.stringForValue(x, axis: nil) + "\ny: " + yAxisValueFormatter!.stringForValue(y, axis: nil))
    }
}


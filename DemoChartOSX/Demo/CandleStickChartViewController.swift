//
//  CandleStickChartViewController.swift
//  ChartsDemo-OSX
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  Copyright © 2017 thierry Hentic.
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/ios-charts

import Foundation
import Cocoa
import Charts

open class CandleStickChartViewController: NSViewController
{
    @IBOutlet var chartView: CandleStickChartView!
    
    override open func viewDidAppear()
    {
        super.viewDidAppear()
        view.window!.title = "Candle Stick Chart"
    }
    
    override open func viewWillAppear()
    {
        chartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
    }

    override open func viewDidLoad()
    {
        super.viewDidLoad()
        
        // MARK: General
        chartView.delegate = self
        chartView.maxVisibleCount = 60;
        chartView.drawGridBackgroundEnabled = false
        chartView.drawBordersEnabled = true
        
        // MARK: xAxis
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.drawGridLinesEnabled = true
        
//        xAxis.nameAxis = "Name xAxis"
//        xAxis.nameAxisEnabled = true
        
        // MARK: leftAxis
        let leftAxis = chartView.leftAxis
        leftAxis.labelCount = 7
        leftAxis.drawGridLinesEnabled = true
        leftAxis.drawAxisLineEnabled = false
        
//        leftAxis.nameAxis = "Name xAxis"
//        leftAxis.nameAxisEnabled = true
        
        // MARK: rightAxis
        let rightAxis = chartView.rightAxis
        rightAxis.enabled = false
        
        // MARK: legend
        chartView.legend.enabled = true
        
        setDataCount(40, range: 2.0)
    }
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - count: <#count description#>
    ///   - range: <#range description#>
    func setDataCount(_ count: Int, range: Double)
    {
        // MARK: CandleChartDataEntry
        var yVals1 = [CandleChartDataEntry]()
        for i in 0..<count
        {
            let mult: Double = (range + 1)
            let val = Double(arc4random_uniform(40)) + mult
            let high = Double(arc4random_uniform(9)) + 8.0
            let low = Double(arc4random_uniform(9)) + 8.0
            let open = Double(arc4random_uniform(6)) + 1.0
            let close = Double(arc4random_uniform(6)) + 1.0
            let even = i % 2 == 0
            
            yVals1.append(CandleChartDataEntry(x: Double(i), shadowH: val + high, shadowL: val - low, open: even ? val + open : val - open, close: even ? val - close : val + close))
        }
        
        // MARK: CandleChartDataSet
        let set1 = CandleChartDataSet(entries: yVals1 , label: "Data Set")
        set1.axisDependency = .left
        set1.setColor(NSColor(white: CGFloat(80 / 255.0), alpha: 1.0))
        set1.shadowColor = NSColor.darkGray
        set1.shadowWidth = 0.7
        set1.decreasingColor = NSColor.red
        set1.decreasingFilled = true
        set1.increasingColor = NSColor(red: CGFloat(122 / 255.0), green: CGFloat(242 / 255.0), blue: CGFloat(84 / 255.0), alpha: 1.0)
        set1.increasingFilled = false
        set1.neutralColor = NSColor.blue
        
        // MARK: CandleChartData
        let data = CandleChartData(dataSet: set1)
        chartView.data = data
    }
    
}

// MARK: - ChartViewDelegate
extension CandleStickChartViewController: ChartViewDelegate
{
    public func chartScaled(_ chartView: ChartViewBase, scaleX: CGFloat, scaleY: CGFloat) {
        
    }
    
    public func chartTranslated(_ chartView: ChartViewBase, dX: CGFloat, dY: CGFloat) {
        
    }
    
    public func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight)
    {
        print("chartValueSelected : x = \(highlight.x)")
    }
    
    public func chartValueNothingSelected(_ chartView: ChartViewBase)
    {
        print("chartValueNothingSelected")
    }
}


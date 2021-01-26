//
//  BarChartViewController.swift
//  ChartsDemo-OSX
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  Copyright © 2017 thierry Hentic.
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/ios-charts

import AppKit
import Charts

open class BubbleChartViewController: NSViewController, ChartViewDelegate
{
    
    @IBOutlet var chartView: BubbleChartView!
    
    var mytitle = "Bubble Chart"
    
    override open func viewDidAppear()
    {
        super.viewDidAppear()
        view.window!.title = "Bubble Chart"
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        // MARK: General
        chartView.delegate                  = self
        chartView.pinchZoomEnabled          = false
        
        chartView.doubleTapToZoomEnabled    = false
        chartView.drawGridBackgroundEnabled = true
        chartView.drawBordersEnabled = true
        
        // MARK: xAxis
        let xAxis                  = chartView.xAxis
        xAxis.labelPosition        = .bottom
        xAxis.drawGridLinesEnabled = true
        xAxis.granularity          = 1
//        xAxis.axisMaximum          = 120.0
        xAxis.axisMinimum          = 0.0
        
//        xAxis.nameAxis = "Impact"
//        xAxis.nameAxisEnabled = true
        
        // MARK: leftAxis
        let leftAxis                  = chartView.leftAxis
        leftAxis.drawGridLinesEnabled = true
        leftAxis.drawZeroLineEnabled  = true
//        leftAxis.axisMaximum          = 10.0
        
//        leftAxis.nameAxis = "Probability"
//        leftAxis.nameAxisEnabled = true
        
        // MARK: rightAxis
        let rightAxis                  = chartView.rightAxis
        rightAxis.enabled = false
        
//        chartView.leftAxis1.isEnabled = false
//        chartView.rightAxis1.isEnabled = false
        
        // MARK: legend
        let legend = chartView.legend
        legend.enabled = true
        legend.verticalAlignment = .center
        legend.horizontalAlignment = .right
        legend.orientation = .vertical
        legend.form = .line
        
        // MARK: description
        chartView.chartDescription.enabled = false
        
        self.updateChartData()
    }
    
    func updateChartData()
    {
        setDataCount(10, range: 50)
    }
    
    func setDataCount(_ count: Int, range: UInt32)
    {
        let yVals1 = (0..<count).map { (i) -> BubbleChartDataEntry in
            let val = Double(arc4random_uniform(range))
            let size = CGFloat(arc4random_uniform(range))
            return BubbleChartDataEntry(x: Double(i), y: val, size: size, icon: NSImage(named: "icon"))
        }
        let yVals2 = (0..<count).map { (i) -> BubbleChartDataEntry in
            let val = Double(arc4random_uniform(range))
            let size = CGFloat(arc4random_uniform(range))
            return BubbleChartDataEntry(x: Double(i), y: val, size: size, icon: NSImage(named: "icon"))
        }
        let yVals3 = (0..<count).map { (i) -> BubbleChartDataEntry in
            let val = Double(arc4random_uniform(range))
            let size = CGFloat(arc4random_uniform(range))
            return BubbleChartDataEntry(x: Double(i), y: val, size: size)
        }
        
        let set1 = BubbleChartDataSet(entries: yVals1, label: "DS 1")
        set1.drawIconsEnabled = false
        set1.setColor(ChartColorTemplates.colorful()[0], alpha: 0.5)
        set1.drawValuesEnabled = true
        
        let set2 = BubbleChartDataSet(entries: yVals2, label: "DS 2")
        set2.drawIconsEnabled = false
        set2.iconsOffset = CGPoint(x: 0, y: 15)
        set2.setColor(ChartColorTemplates.colorful()[1], alpha: 0.5)
        set2.drawValuesEnabled = true
        
        let set3 = BubbleChartDataSet(entries: yVals3, label: "DS 3")
        set3.setColor(ChartColorTemplates.colorful()[2], alpha: 0.5)
        set3.drawValuesEnabled = true
        
        let data = BubbleChartData(dataSets: [set1, set2, set3])
        data.setDrawValues(false)
        data.setValueFont(NSFont(name: "HelveticaNeue-Light", size: 7)!)
        data.setHighlightCircleWidth(1.5)
        data.setValueTextColor(.white)
        
        chartView.data = data
    }
    
    
    public func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print("Bubble selected : x = ", entry.x)
    }
    
    public func chartValueNothingSelected(_ chartView: ChartViewBase) {
        
    }
    
    public func chartScaled(_ chartView: ChartViewBase, scaleX: CGFloat, scaleY: CGFloat) {
        
    }
    
    public func chartTranslated(_ chartView: ChartViewBase, dX: CGFloat, dY: CGFloat) {
        
    }

}

//// MARK: - ChartViewDelegate
//extension BarChartViewController: ChartViewDelegate
//{
//    public func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight)
//    {
//        print("chartValueSelected : x = \(highlight.x)")
//    }
//
//    public func chartValueNothingSelected(_ chartView: ChartViewBase)
//    {
//        print("chartValueNothingSelected")
//    }
//}


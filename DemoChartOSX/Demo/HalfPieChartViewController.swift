//
//  HalfPieChartViewController.swift
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

open class HalfPieChartViewController: DemoBaseViewController
{
    @IBOutlet var chartView: PieChartView!
        
    override open func viewDidAppear()
    {
        super.viewDidAppear()
        view.window!.title = "Half Pie Chart"
    }
    
    override open func viewWillAppear()
    {
        chartView.animate(xAxisDuration: 1.4, easingOption: .easeInOutBack)
    }
    
    override open func viewDidLoad()
    {
        super.viewDidLoad()
        
        super.setupPieChartView(chartView)
        
        // MARK: General
        chartView.delegate = self
        chartView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        chartView.holeColor              =  #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        chartView.transparentCircleColor = Color.white.withAlphaComponent(0.43)
        chartView.holeRadiusPercent      = 0.58
        chartView.isRotationEnabled        = false
        chartView.isHighlightPerTapEnabled = true
        chartView.maxAngle               = 180.0
        
        // entry label styling
        chartView.entryLabelColor =  #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        chartView.entryLabelFont = Font(name: "HelveticaNeue-Light", size: CGFloat(12.0))
        
        // Half chart
        chartView.rotationAngle = 180.0
        // Rotate to make the half on the upper side
        chartView.centerTextOffset = CGPoint(x: CGFloat(0.0), y: CGFloat(-20.0))
        
        // MARK: legend
        var legend = chartView.legend
        legend.horizontalAlignment = .center
        legend.verticalAlignment = .top
        legend.orientation = .horizontal
        legend.drawInside = false
        legend.xEntrySpace = 7.0
        legend.yEntrySpace = 0.0
        legend.yOffset = 0.0
        
        updateChartData()
    }
    
    override func updateChartData() {
        setDataCount(4, range: 100)
    }
    
    func setDataCount(_ count: Int, range: Double)
    {
        // MARK: PieChartDataEntry
        let mult = range
        var values = [PieChartDataEntry]()
        
        // IMPORTANT: In a PieChart, no values (Entry) should have the same xIndex (even if from different DataSets), since no values can be drawn above each other.
        
        for i in 0..<count
        {
            values.append(PieChartDataEntry(value: (Double(arc4random_uniform(UInt32(mult))) + mult / 5), label: parties[i % parties.count]))
        }
        
        // MARK: PieChartDataSet
        let dataSet = PieChartDataSet(values: values, label: "Election Results")
        dataSet.sliceSpace = 3.0
        dataSet.selectionShift = 5.0
        dataSet.colors = ChartColorTemplates.material
        
        // MARK: PieChartData
        let data = PieChartData()
        data.addDataSet(dataSet)
        
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1.0
        pFormatter.percentSymbol = " %"
        data.setValueFormatter(DefaultValueFormatter(formatter : pFormatter  ))
        
        data.setValueFont( Font(name: "HelveticaNeue-Light", size: CGFloat(11.0))!)
        data.setValueTextColor( Color.white)
        chartView.data = data
        chartView.needsDisplay = true
    }
}

// MARK: - ChartViewDelegate
extension HalfPieChartViewController: ChartViewDelegate
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






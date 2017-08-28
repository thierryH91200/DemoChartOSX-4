//
//  SinusBarChartViewController .swift
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



open class SinusBarChartViewController: DemoBaseViewController
{
    @IBOutlet var chartView: BarChartView!
    
    @IBOutlet weak var sliderX: NSSlider!
    @IBOutlet weak var sliderTextX: NSTextField!
    
    override open func viewDidAppear()
    {
        super.viewDidAppear()
        view.window!.title = "Sinus Bar Chart"
    }

    override open func viewWillAppear()
    {
        chartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
    }

    override open func viewDidLoad()
    {
        super.viewDidLoad()
        
        // MARK: General
        chartView.isDrawBarShadowEnabled = false
        chartView.isDrawValueAboveBarEnabled = true
        chartView.maxVisibleCount = 60
        chartView.isPinchZoomEnabled = false
        chartView.isDrawGridBackgroundEnabled = false
        chartView.isDrawBordersEnabled = true
        
        // MARK: xAxis
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = Font(name: "HelveticaNeue-Light", size: CGFloat(10.0))!
        xAxis.isDrawGridLinesEnabled = false
        xAxis.isEnabled = true
        
//        xAxis.nameAxis = "Date"
//        xAxis.nameAxisEnabled = true

         // MARK: leftAxis
        let leftAxis = chartView.leftAxis
        leftAxis.labelFont = Font(name: "HelveticaNeue-Light", size: CGFloat(10.0))!
        leftAxis.labelCount = 6
        leftAxis.axisMinimum = -2.5
        leftAxis.axisMaximum = 2.5
        leftAxis.isGranularityEnabled = true
        leftAxis.granularity = 0.1
        
//        leftAxis.nameAxis = "Amplitude"
//        leftAxis.nameAxisEnabled = true

        // MARK: rightAxis
        let rightAxis = chartView.rightAxis
        rightAxis.isEnabled = false
//        rightAxis.nameAxisEnabled = false
        
        // MARK: legend
        var legend = chartView.legend
        legend.horizontalAlignment = .left
        legend.verticalAlignment = .bottom
        legend.orientation = .horizontal
        legend.drawInside = false
        legend.form = .square
        legend.formSize = 9.0
        legend.font = Font.systemFont(ofSize: CGFloat(11.0))
        legend.xEntrySpace = 4.0
        
        // MARK: description
        chartView.chartDescription?.isEnabled = false
        
        sliderX.doubleValue  = 150.0
        slidersValueChanged(sliderX)
        
        setDataCount(150)
    }
    
    override func updateChartData()
    {
        setDataCount  (Int(sliderX.intValue))
    }
    
    func setDataCount(_ count: Int) {
        
        // MARK: BarChartDataEntry
        let entries = (0..<count).map {
            BarChartDataEntry(x: Double($0), y: sin(.pi * Double($0%128) / 64))
        }
        
        // MARK: BarChartDataSet
       var set = BarChartDataSet()
        if chartView.data != nil
        {
            set = (chartView.data?.dataSets[0] as? BarChartDataSet)!
            set.values = entries
            
            chartView.data?.notifyDataChanged()
            chartView.notifyDataSetChanged()
        }
        else
        {
            set = BarChartDataSet(values: entries, label: "Sinus Function")
            set.colors = [Color(red: CGFloat(240 / 255.0), green: CGFloat(120 / 255.0), blue: CGFloat(124 / 255.0), alpha: 1.0)]
        }
        set.valueFont = Font(name: "HelveticaNeue-Light", size: CGFloat(10.0))!
        set.isDrawValuesEnabled = false
        set.barBorderWidth = 0.1
        
        // MARK: BarChartData
        let data = BarChartData(dataSet: set)
        chartView.data = data
    }
    
    @IBAction func slidersValueChanged(_ sender: AnyObject)
    {
        sliderTextX.stringValue =  String(Int( sliderX.intValue))
        updateChartData()
    }
}



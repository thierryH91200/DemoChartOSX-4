//
//  PositiveNegativeBarChartViewController .swift
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

open class PositiveNegativeBarChartViewController: DemoBaseViewController
{
    @IBOutlet var chartView: BarChartView!
        
    override open func viewDidAppear()
    {
        super.viewDidAppear()
        view.window!.title = "Positive Negative Bar Chart"
    }
    
    override open func viewDidLoad()
    {
        super.viewDidLoad()
        
        // MARK: General
        chartView.extraTopOffset = -30.0
        chartView.extraBottomOffset = 10.0
        chartView.extraLeftOffset = 70.0
        chartView.extraRightOffset = 70.0
        chartView.isDrawBarShadowEnabled = false
        chartView.isDrawValueAboveBarEnabled = true
        chartView.isDrawBordersEnabled = true
        
        // scaling can now only be done on x- and y-axis separately
        chartView.isPinchZoomEnabled = false
        chartView.isDrawGridBackgroundEnabled = true
        
        // MARK: xAxis
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = Font.systemFont(ofSize: CGFloat(13.0))
        xAxis.isDrawGridLinesEnabled = true
        xAxis.isDrawAxisLineEnabled = true
        xAxis.labelTextColor = Color.lightGray
        xAxis.labelCount = 5
        xAxis.isCenterAxisLabelsEnabled = true
        xAxis.granularity = 1.0
        
        // MARK: leftAxis
        let leftAxis = chartView.leftAxis
        leftAxis.isEnabled = true
        leftAxis.isDrawLabelsEnabled = true
        leftAxis.spaceTop = 0.25
        leftAxis.spaceBottom = 0.25
        leftAxis.isDrawAxisLineEnabled = true
        leftAxis.isDrawGridLinesEnabled = true
        leftAxis.isDrawZeroLineEnabled = true
        leftAxis.zeroLineColor = Color.gray
        leftAxis.zeroLineWidth = 0.7
        
        // MARK: rightAxis
        chartView.rightAxis.isEnabled = false
        
        // MARK: legend
        chartView.legend.isEnabled = false
        
        // MARK: description
        chartView.chartDescription?.isEnabled = false
        
        updateChartData()
    }
    
    override func updateChartData()
    {
        setChartData()
    }
    
    func setChartData()
    {
        // THIS IS THE ORIGINAL DATA YOU WANT TO PLOT
        var dataList  = [DataList]()
        dataList.append(DataList(xValue: 0, yValue : -224.1, xLabel  : "12-19"))
        dataList.append(DataList(xValue: 1, yValue : 238.5, xLabel : "12-30"))
        dataList.append(DataList(xValue: 2, yValue : 1280.1, xLabel : "12-31"))
        dataList.append(DataList(xValue: 3, yValue : -442.3, xLabel : "01-01"))
        dataList.append(DataList(xValue: 4, yValue : -2280.1,xLabel : "01-02"))
        
        // MARK: BarChartDataEntry
        var values = [BarChartDataEntry]()
        var colors = [Color]()
        let green = Color.green
        let red = Color.red
        
        for data in dataList
        {
            let entry = BarChartDataEntry(x: data.xValue, y: data.yValue)
            values.append(entry)
            
            // specific colors
            if data.yValue >= 0.0 {
                colors.append(red)
            }
            else {
                colors.append(green)
            }
        }
        
        // MARK: BarChartDataSet
        let set = BarChartDataSet(values: values, label: "Values")
        set.colors = colors
        set.valueColors = colors
        set.axisDependency = .left
        
        // MARK: BarChartData
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        
        let data = BarChartData(dataSet: set)
        data.setValueFont(Font.systemFont(ofSize: CGFloat(13.0)))
        data.setValueFormatter( DefaultValueFormatter(formatter: formatter ))
        data.barWidth = 0.8
        chartView.data = data
    }
}

class DataList{
    var xValue : Double
    var yValue : Double
    var xLabel : String
    init(xValue:Double,yValue:Double,xLabel:String){
        self.xValue = xValue
        self.yValue = yValue
        self.xLabel = xLabel
    }
}


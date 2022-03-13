//
//  LineChartTimeViewController .swift
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

open class LineChartTimeViewController: DemoBaseViewController
{
    @IBOutlet var chartView: LineChartView!

    @IBOutlet weak var sliderX: NSSlider!
    @IBOutlet weak var sliderTextX: NSTextField!
    
    override open func viewDidAppear()
    {
        super.viewDidAppear()
        view.window!.title = "Time Line Chart"
    }
    
    override open func viewWillAppear()
    {
        chartView.animate(xAxisDuration: 0.75, yAxisDuration: 0.75)
    }
    
    override open func viewDidLoad()
    {
        super.viewDidLoad()
        
        // MARK: General
        chartView.dragEnabled = true
        chartView.setScaleEnabled(true)
        chartView.pinchZoomEnabled = false
        chartView.drawGridBackgroundEnabled = false
        chartView.highlightPerDragEnabled = true
        chartView.backgroundColor = .white
        
        chartView.scaleYEnabled = false
        chartView.scaleXEnabled = true
//        chartView.dragYEnabled = false
//        chartView.dragXEnabled = true
        
        // MARK: xAxis
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = NSFont(name: "HelveticaNeue-Light", size: CGFloat(10.0))!
        xAxis.labelTextColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        xAxis.drawAxisLineEnabled = true
        xAxis.drawGridLinesEnabled = true
        xAxis.drawLimitLinesBehindDataEnabled = true
        xAxis.avoidFirstLastClippingEnabled = false
        xAxis.granularity = 1.0
        xAxis.spaceMin = xAxis.granularity / 5
        xAxis.spaceMax = xAxis.granularity / 5
        xAxis.labelRotationAngle = -90.0
        
//        xAxis.nameAxis = "Date (s)"
//        xAxis.nameAxisEnabled = true
        
        // MARK: leftAxis
        let leftAxis = chartView.leftAxis
        leftAxis.labelPosition = .outsideChart
        leftAxis.labelFont = NSFont(name: "HelveticaNeue-Light", size: CGFloat(12.0))!
        leftAxis.labelTextColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        leftAxis.drawGridLinesEnabled = true
        leftAxis.granularityEnabled = true
        leftAxis.yOffset = -9.0
        leftAxis.drawLimitLinesBehindDataEnabled = false

        
//        leftAxis.nameAxis = "Event"
//        leftAxis.nameAxisEnabled = true
        
        // MARK: rightAxis
        chartView.rightAxis.enabled = false
        
        // MARK: legend
        let legend = chartView.legend
        legend.enabled = true
        legend.form = .square
        legend.drawInside = false
        legend.orientation = .horizontal
        legend.verticalAlignment = .bottom
        legend.horizontalAlignment = .left
        
        // MARK: description
        chartView.chartDescription?.enabled = false
        chartView.chartDescription?.text = "Time Line Chart"
        
        sliderX.doubleValue = 300.0
        slidersValueChanged(sliderX)
    }
    
    override func updateChartData()
    {
        setDataCount(Int(sliderX.intValue) , range: 30.0)
    }
    
    func setDataCount(_ count: Int, range: Double)
    {
        // MARK: ChartDataEntry
        
        let hourSeconds = 3600.0 * 24.0
        var values1 = [ChartDataEntry]()
        var values2 = [ChartDataEntry]()
        
        let now = Date().timeIntervalSince1970
        let from: TimeInterval = now - (Double(count) / 2.0) * hourSeconds
        let to: TimeInterval = now + (Double(count) / 2.0) * hourSeconds
        

        var x = from
        var y1 = 0.0
        
        while x <= now {

            let x1 = (x - from) / hourSeconds
            y1 = Double(arc4random_uniform(UInt32(range)) + 50)
            values1.append(ChartDataEntry(x: x1 , y: y1))
            
            addLimit(index: x1, x : x)

            x += hourSeconds
        }
        
        x -= hourSeconds
        while x < to {
            let x1 = (x - from) / hourSeconds
            values2.append(ChartDataEntry(x: x1 , y: y1))
            y1 = Double(arc4random_uniform(UInt32(range)) + 50)

            addLimit(index: x1, x : x)

            x += hourSeconds
        }
        
        chartView.xAxis.labelCount = 300
        chartView.xAxis.valueFormatter = DateValueFormatter(miniTime : from, interval: hourSeconds)
        
        let  marker = RectMarker( color: #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1),
                                  font: NSFont.systemFont(ofSize: 12.0),
                                  insets: NSEdgeInsetsMake(8.0, 8.0, 20.0, 8.0))

        marker.minimumSize = CGSize( width: 80.0, height :40.0)
        marker.chartView = chartView
        chartView.marker = marker
        marker.miniTime = from
        marker.interval = hourSeconds

        // MARK: LineChartDataSet
        var set1 =  LineChartDataSet()
        var set2 =  LineChartDataSet()
        if chartView.data != nil
        {
            set1 = (chartView.data?.dataSets[0] as? LineChartDataSet)!
            set2 = (chartView.data?.dataSets[1] as? LineChartDataSet)!
            set1.replaceEntries(values1)
            set2.replaceEntries(values2)

            chartView.xAxis.resetCustomAxisMax()
            chartView.leftAxis.resetCustomAxisMax()

            chartView.data?.notifyDataChanged()
            chartView.notifyDataSetChanged()
        }
        else
        {
            set1 = LineChartDataSet(entries: values1, label: "Actual")
            set1.axisDependency = .left
            set1.mode = .cubicBezier
            set1.valueTextColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
            set1.lineWidth = 1.5
            
            set1.drawCirclesEnabled = false
            set1.drawValuesEnabled = true
            
            set1.drawFilledEnabled = true
            set1.fillAlpha = 0.26
            set1.fillColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
            set1.highlightColor = #colorLiteral(red: 0.4513868093, green: 0.9930960536, blue: 1, alpha: 1)
            set1.highlightLineWidth = 5.0
            set1.drawHorizontalHighlightIndicatorEnabled = false
            set1.formSize = 15.0
            set1.colors = [#colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)]
            
            set2 = LineChartDataSet(entries: values2, label: "Future")
            set2.axisDependency = .left
            set2.mode = .cubicBezier
            set2.valueTextColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            set2.lineWidth = 1.5
            
            set2.drawCirclesEnabled = false
            set2.drawValuesEnabled = true
            set2.drawFilledEnabled = true
            
            set2.highlightColor = #colorLiteral(red: 0.4513868093, green: 0.9930960536, blue: 1, alpha: 1)
            set2.highlightLineWidth = 5.0
            set2.drawHorizontalHighlightIndicatorEnabled = false
            
            set2.formLineDashLengths = [5.0, 2.5]
            set2.formLineWidth = 1.0
            set2.formSize = 15.0
            set2.colors = [#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)]
            
            var dataSets = [LineChartDataSet]()
            dataSets.append(set1)
            dataSets.append(set2)
            
            // MARK: LineChartData
            let data = LineChartData(dataSets: dataSets)
            data.setValueTextColor ( #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
            data.setValueFont ( NSFont(name: "HelveticaNeue-Light", size: CGFloat(9.0))!)
            
            chartView.xAxis.resetCustomAxisMax()
            chartView.leftAxis.resetCustomAxisMax()

            
            chartView.data = data
            chartView.xAxis.axisMaximum += 1
        }
    }

    func addLimit( index: Double, x : Double) {
        
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yy"

        let date2 = Date(timeIntervalSince1970 : x )
        if calendar.day(date2) == 1 {
            let dateStr = dateFormatter.string(from: date2)
            let llXAxis = ChartLimitLine(limit: index , label: dateStr)
            llXAxis.lineColor = #colorLiteral(red: 0.08062536269, green: 0.2148533463, blue: 1, alpha: 1)
            llXAxis.valueTextColor = NSColor.blue
            llXAxis.valueFont = NSFont.systemFont(ofSize: CGFloat(12.0))
            llXAxis.labelPosition = .bottomRight
            
            let xAxis = chartView.xAxis
            xAxis.addLimitLine(llXAxis)
        }

    }
        
    @IBAction func slidersValueChanged(_ sender: AnyObject)
    {
        sliderTextX.stringValue =  String(Int( sliderX.intValue))
        updateChartData()
    }
    
    @IBAction func toggleDrag(_ sender: Any)
    {
        chartView.dragEnabled = !chartView.isDragEnabled
        if chartView.isDragEnabled == true
        {
            (sender as! NSButton).title = "Drag On"
        }
        else
        {
            (sender as! NSButton).title = "Drag Off"
        }
    }
    
}


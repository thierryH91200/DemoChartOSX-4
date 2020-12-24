//
//  LineChart1ViewController .swift
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

private var defaultsContext = 0

open class LineChart1ViewController: DemoBaseViewController
{
    @IBOutlet var chartView: LineChartView!
        
    @IBOutlet weak var sliderX: NSSlider!
    @IBOutlet weak var sliderY: NSSlider!
    
    @IBOutlet weak var sliderTextX: NSTextField!
    @IBOutlet weak var sliderTextY: NSTextField!
    
    override open func viewDidAppear()
    {
        super.viewDidAppear()
        view.window?.title = "Line Chart"
    }
    
    override open func viewWillAppear()
    {
        chartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
    }
    
    override open func viewDidLoad()
    {
        super.viewDidLoad()
        
        // MARK: General
        let background = CAGradientLayer().turquoiseColor
        background().frame = view.bounds
        view.wantsLayer = true
        view.layer?.addSublayer(background())
        chartView.backgroundColor = #colorLiteral(red: 0.6980392157, green: 0.8431372549, blue: 1, alpha: 1)
        
        chartView.dragEnabled = true
        chartView.setScaleEnabled( true)
        chartView.pinchZoomEnabled = true
        chartView.drawGridBackgroundEnabled = false
        chartView.drawBordersEnabled = true
        
        // MARK: xAxis
        // x-axis limit line
        let llXAxis = ChartLimitLine(limit: 10.0, label: "Index 10")
        llXAxis.lineWidth = 4.0
        llXAxis.lineColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
        llXAxis.lineDashLengths = [10.0, 10.0, 0.0]
        llXAxis.valueTextColor = NSColor.black
        llXAxis.valueFont = NSFont.systemFont(ofSize: CGFloat(10.0))
        llXAxis.labelPosition = .rightBottom
        
        let llXAxis2 = ChartLimitLine(limit: 30.0, label: "Index 30")
        llXAxis2.lineWidth = 4.0
        llXAxis2.lineDashLengths = [10.0, 10.0, 0.0]
        llXAxis2.labelPosition = .rightBottom
        llXAxis2.valueFont = NSFont.systemFont(ofSize: CGFloat(10.0))
        llXAxis2.lineColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
        
        let xAxis = chartView.xAxis
        xAxis.addLimitLine(llXAxis)
        xAxis.addLimitLine(llXAxis2)
        xAxis.gridLineDashLengths = [10.0, 10.0]
        xAxis.gridLineDashPhase = 0.0
        xAxis.labelPosition = .bottom
        
//        xAxis.nameAxis = "Date (s)"
//        xAxis.nameAxisEnabled = true
        
        // MARK: leftAxis
        // leftAxis limit line
        let ll1 = ChartLimitLine(limit: 150.0, label: "Upper Limit")
        ll1.lineWidth = 4.0
        ll1.lineDashLengths = [5.0, 5.0]
        ll1.labelPosition = .leftTop
        ll1.valueFont = NSFont.systemFont(ofSize: CGFloat(10.0))
        
        let ll2 = ChartLimitLine(limit: -30.0, label: "Lower Limit")
        ll2.lineWidth = 4.0
        ll2.lineDashLengths = [5.0, 5.0]
        ll2.labelPosition = .rightBottom
        ll2.valueFont = NSFont.systemFont(ofSize: CGFloat(10.0))
        
        let leftAxis = chartView.leftAxis
        leftAxis.removeAllLimitLines()
        leftAxis.addLimitLine(ll1)
        leftAxis.addLimitLine(ll2)
        
        leftAxis.axisMinimum = -40.0
        leftAxis.axisMaximum = 200.0
        leftAxis.granularity = 120
        leftAxis.labelCount = 3
        leftAxis.forceLabelsEnabled = true
        
        leftAxis.gridLineDashLengths = [5.0, 5.0]
        leftAxis.drawZeroLineEnabled = false
        leftAxis.drawLimitLinesBehindDataEnabled = true
        
//        leftAxis.nameAxis = "Temperature (°C)"
//        leftAxis.nameAxisEnabled = true
        
        // MARK: rightAxis
        chartView.rightAxis.enabled = false
        
        // MARK: legend
        chartView.legend.form = .line
        
        // MARK: description
        chartView.chartDescription.enabled = false
        
        let marker = BalloonMarker(color: #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1), font: NSFont.systemFont(ofSize: CGFloat(12.0)), textColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), insets: NSEdgeInsets(top: 8.0, left: 8.0, bottom: 20.0, right: 8.0))
        marker.chartView = chartView
        marker.minimumSize = CGSize(width: CGFloat(80.0), height: CGFloat(40.0))
        chartView.marker = marker
        
        sliderX.doubleValue = 45.0
        sliderY.doubleValue = 100.0
        slidersValueChanged(sliderX)
    }
    
    override func updateChartData()
    {
        if self.shouldHideData {
            chartView.data = nil
            return
        }
        self.setDataCount(Int(sliderX.intValue), range: UInt32(sliderY.doubleValue))
    }
    
    func setDataCount(_ count: Int, range: UInt32)
    {
        // MARK: ChartDataEntry
        let values = (0..<count).map { (i) -> ChartDataEntry in
            let val = Double(arc4random_uniform(range) + 3)
            return ChartDataEntry(x: Double(i), y: val, icon: #imageLiteral(resourceName: "Queue"))
        }

        // MARK: LineChartDataSet
        var set1 = LineChartDataSet()
        if chartView.data != nil
        {
            set1 = (chartView.data?.dataSets[0] as? LineChartDataSet)!
            set1.replaceEntries(values)

            chartView.data?.notifyDataChanged()
            chartView.notifyDataSetChanged()
            
            chartView.zoom( scaleX: 4, scaleY: 2.0, xValue: 30, yValue: 60.0, axis: YAxis.AxisDependency.left)
        }
        else
        {
            set1 = LineChartDataSet(entries: values, label: "DataSet 1")
            set1.lineDashLengths = [5.0, 2.5]
            set1.highlightLineDashLengths = [5.0, 2.5]
            set1.colors = [#colorLiteral(red: 0.476841867, green: 0.5048075914, blue: 1, alpha: 1)]
            set1.circleColors = [.black]
            set1.lineWidth = 1.0
            set1.circleRadius = 3.0
            set1.drawCircleHoleEnabled = false
            set1.valueFont = NSFont.systemFont(ofSize: CGFloat(9.0))
            set1.formLineDashLengths = [5.0, 2.5]
            set1.formLineWidth = 1.0
            set1.formSize = 15.0
            set1.axisDependency = .left
            
            let beginColor = ChartColorTemplates.colorFromString(  "#00ff0000").cgColor
            let endColor = ChartColorTemplates.colorFromString( "#ffff0000").cgColor
            let gradientColors = [(beginColor ), (endColor )] as CFArray
            
//            let gradient = CGGradient(colorsSpace: nil, colors: gradientColors, locations: nil)!
            
            set1.fillAlpha = 1.0
//            set1.fill = .linearGradient(gradient, angle: 90)
//            set1.fill = Fill(linearGradient: gradient, angle: 90.0)
            
            var dataSets = [LineChartDataSet]()
            dataSets.append(set1)
            
            // MARK: LineChartData
            let data = LineChartData(dataSets: dataSets)
            chartView.data = data
            chartView.zoom( scaleX: 4, scaleY: 2.0, xValue: 30, yValue: 60.0, axis: YAxis.AxisDependency.left)
        }
    }
        
    @IBAction func slidersValueChanged(_ sender: AnyObject) {
        sliderTextX.stringValue =  String(Int( sliderX.intValue))
        sliderTextY.stringValue =  String(Int( sliderY.intValue))
        updateChartData()
    }
}

extension CAGradientLayer {

    func turquoiseColor() -> CAGradientLayer {
        let topColor = NSColor(red: (15/255.0), green: (118/255.0), blue: (128/255.0), alpha: 1)
        let bottomColor = NSColor(red: (84/255.0), green: (187/255.0), blue: (187/255.0), alpha: 1)

        let gradientColors: Array <AnyObject> = [topColor.cgColor, bottomColor.cgColor]
        let gradientLocations: Array <NSNumber> = [0.0 , 1.0 ]

        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations

        return gradientLayer
    }
}


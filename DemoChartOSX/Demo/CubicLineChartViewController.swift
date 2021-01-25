//
//  CubicLineChartViewController
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

open class CubicLineChartViewController: DemoBaseViewController
{
    @IBOutlet var chartView: LineChartView!
        
    @IBOutlet weak var sliderX: NSSlider!
    @IBOutlet weak var sliderY: NSSlider!
    
    @IBOutlet weak var sliderTextX: NSTextField!
    @IBOutlet weak var sliderTextY: NSTextField!
    
    override open func viewDidAppear()
    {
        super.viewDidAppear()
        view.window!.title = "Cubic Line Chart"
    }
    
    override open func viewWillAppear()
    {
        chartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
    }
    
    override open func viewDidLoad()
    {
        super.viewDidLoad()
        
        // MARK: General
        //chartView.setViewPortOffsets(left: 0.0, top: 20.0, right: 0.0, bottom: 0.0)
        chartView.backgroundColor = #colorLiteral(red: 0.1215522066, green: 0.1215801612, blue: 0.1215485409, alpha: 1)
        
        chartView.gridBackgroundColor =  #colorLiteral(red: 0.1215522066, green: 0.1215801612, blue: 0.1215485409, alpha: 1)
        chartView.dragEnabled               = true
        chartView.setScaleEnabled(true)
        chartView.drawGridBackgroundEnabled = true
//        chartView.maxHighlightDistance      = 300.0
        chartView.drawBordersEnabled = true
        chartView.borderColor = .white

        
        // MARK: xAxis
        let xAxis    = chartView.xAxis
        xAxis.enabled    = true
        xAxis.labelPosition = .bottom
        xAxis.labelTextColor       = NSColor.white.withAlphaComponent(0.2)
        xAxis.axisLineColor        = .white
        xAxis.axisLineWidth = 2.0
        xAxis.drawGridLinesEnabled = true
        xAxis.gridColor = .white
        xAxis.labelFont            = NSFont.boldSystemFont(ofSize: 24.0)
        
        // MARK: leftAxis
        let leftAxis                  = chartView.leftAxis
        leftAxis.labelFont            = NSFont(name: "HelveticaNeue-Light", size: CGFloat(20.0))!
        leftAxis.setLabelCount(6, force: false)
        leftAxis.labelTextColor       = .white
        leftAxis.labelPosition        = .outsideChart
        leftAxis.drawGridLinesEnabled = true
        leftAxis.axisLineColor        = .white
        leftAxis.axisMaximum = 100.0
        
        // MARK: rightAxis
        chartView.rightAxis.enabled = false
        
        // MARK: legend
        chartView.legend.enabled = false
        
        // MARK: description
        chartView.chartDescription.enabled = false
        
        sliderX.doubleValue = 132.0
        sliderY.doubleValue = 42.0
        slidersValueChanged(sliderX)
    }
    
    override func updateChartData()
    {
        setDataCount(Int(sliderX.intValue) + 1, range: sliderY.doubleValue)
    }
    
    func setDataCount(_ count: Int, range: Double)
    {
        // MARK: ChartDataEntry
        var yVals1 = [ChartDataEntry]()
        for i in 0..<count
        {
            let mult: Double = (range + 1)
            let val = Double(arc4random_uniform(UInt32(mult))) + 20
            yVals1.append(ChartDataEntry(x: Double(i), y: val))
        }
        
        // MARK: LineChartDataSet
        var set1 = LineChartDataSet()
        if chartView.data != nil
        {
            set1 = chartView.data!.dataSets[0] as! LineChartDataSet
            set1.replaceEntries(yVals1)

            chartView.fitScreen()
            chartView.data?.notifyDataChanged()
            chartView.notifyDataSetChanged()


//            barLineChartViewBase?.data?.notifyDataChanged()
//            barLineChartViewBase?.notifyDataSetChanged()

        }
        else
        {
            set1 = LineChartDataSet(entries: yVals1, label: "DataSet 1")
            set1.valueFont = NSFont(name: "HelveticaNeue-Light", size: CGFloat(9.0))!
            set1.drawValuesEnabled = false
            
            set1.mode                                    = .cubicBezier
            set1.cubicIntensity                          = 0.05
            set1.drawCirclesEnabled                      = false
            set1.lineWidth                               = 1.0
            set1.circleRadius                            = 4.0
            set1.highlightColor                          = .white
            set1.colors                                  = [NSColor.white]
//            set1.fillColor                               = NSColor.white
            set1.fillAlpha                               = 1.0
            set1.drawHorizontalHighlightIndicatorEnabled = false
            set1.drawFilledEnabled = true
            set1.fillColor = .darkGray
            
////            let beginColor =  #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1).cgColor
////            let endColor =  #colorLiteral(red: 0.152921766, green: 0.1529546976, blue: 0.1529174447, alpha: 1).cgColor
////            let gradientColors = [ beginColor , (endColor )] as CFArray
////
////            let gradient = CGGradient(colorsSpace: nil, colors: gradientColors, locations: nil)!
//
//            set1.fillAlpha = 0.50
////            set1.fill = Fill(linearGradient: gradient, angle: -90.0)


            set1.fillFormatter = CubicLineSampleFillFormatter()
            
            
             // MARK: LineChartData
            let data = LineChartData(dataSet: set1)
            data.setValueFont(NSFont(name: "HelveticaNeue-Light", size: CGFloat(9.0))!)
            data.setDrawValues(false)
            chartView.data = data
        }
    }
    
    @IBAction func slidersValueChanged(_ sender: AnyObject)
    {
        sliderTextX.stringValue =  String(Int( sliderX.intValue))
        sliderTextY.stringValue =  String(Int( sliderY.intValue))
        updateChartData()
    }
}

private class CubicLineSampleFillFormatter: FillFormatter {
    func getFillLinePosition(dataSet: LineChartDataSetProtocol, dataProvider: LineChartDataProvider) -> CGFloat {
        return -10
    }
}


// MARK: - ChartViewDelegate
extension CubicLineChartViewController: ChartViewDelegate
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








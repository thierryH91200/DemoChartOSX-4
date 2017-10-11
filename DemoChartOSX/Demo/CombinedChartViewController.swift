//
//  CombinedChartViewController
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

open class CombinedChartViewController: NSViewController
{
    @IBOutlet var chartView: CombinedChartView!
    
    let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    let ITEM_COUNT  = 12
    
    override open func viewDidAppear()
    {
        super.viewDidAppear()
        view.window!.title = "Combined Chart"
    }
    
    override open func viewWillAppear()
    {
       chartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
    }

    override open func viewDidLoad()
    {
        super.viewDidLoad()
        
        // MARK: General
        chartView.delegate                  = self
        chartView.drawGridBackgroundEnabled = false
        chartView.drawBarShadowEnabled      = false
        chartView.highlightFullBarEnabled   = false
        chartView.drawOrder                 = [  DrawOrder.bar.rawValue, DrawOrder.bubble.rawValue, DrawOrder.candle.rawValue, DrawOrder.line.rawValue, DrawOrder.scatter.rawValue]
        
        // MARK: xAxis
        let xAxis                           = chartView.xAxis
        xAxis.labelPosition                 = .bothSided
        xAxis.axisMinimum                   = 0.0
        xAxis.granularity                   = 1.0
        xAxis.valueFormatter                = BarChartFormatter()
        xAxis.centerAxisLabelsEnabled = true
        xAxis.setLabelCount( 12, force: true)
        
        // MARK: leftAxis
        let leftAxis                        = chartView.leftAxis
        leftAxis.drawGridLinesEnabled       = false
        leftAxis.axisMinimum                = 0.0
        
//        leftAxis.nameAxis = "left Axis"
//        leftAxis.nameAxisEnabled = true

        // MARK: rightAxis
        let rightAxis                       = chartView.rightAxis
        rightAxis.drawGridLinesEnabled      = false
        rightAxis.axisMinimum               = 0.0
        
//        rightAxis.nameAxis = "right Axis"
//        rightAxis.nameAxisEnabled = true
    
        // MARK: legend
        let legend                          = chartView.legend
        legend.wordWrapEnabled              = true
        legend.horizontalAlignment          = .center
        legend.verticalAlignment            = .bottom
        legend.orientation                  = .vertical
        legend.drawInside                   = false
        
        // MARK: description
        chartView.chartDescription?.enabled = false
        
        let marker = RectMarker(color: #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1), font: .systemFont(ofSize: CGFloat(12.0)), insets: NSEdgeInsets(top: 8.0, left: 8.0, bottom: 4.0, right: 4.0))
        marker.chartView = chartView
        marker.minimumSize = CGSize(width: CGFloat(60.0), height: CGFloat(30.0))
        chartView.marker = marker
        
        setChartData()
    }
    
    func setChartData()
    {
        let data = CombinedChartData()
        data.lineData = generateLineData()
        data.barData = generateBarData()
        data.bubbleData = generateBubbleData()
        data.scatterData = generateScatterData()
        data.candleData = generateCandleData()
        chartView.xAxis.axisMaximum = data.xMax + 0.25
        chartView.data = data
    }
    
    func generateLineData() -> LineChartData
    {
        // MARK: ChartDataEntry
        var entries = [ChartDataEntry]()
        for index in 0..<ITEM_COUNT
        {
            entries.append(ChartDataEntry(x: Double(index) + 0.5, y: (Double(arc4random_uniform(15) + 5))))
        }
        
        // MARK: LineChartDataSet
        let set = LineChartDataSet(values: entries, label: "Line DataSet")
        set.colors = [#colorLiteral(red: 0.941176470588235, green: 0.933333333333333, blue: 0.274509803921569, alpha: 1.0)]
        set.lineWidth = 2.5
        set.circleColors = [#colorLiteral(red: 0.941176470588235, green: 0.933333333333333, blue: 0.274509803921569, alpha: 1.0)]
        set.circleHoleRadius = 2.5
        set.fillColor = #colorLiteral(red: 0.941176470588235, green: 0.933333333333333, blue: 0.274509803921569, alpha: 1.0)
        set.mode = .cubicBezier
        set.drawValuesEnabled = true
        set.valueFont = .systemFont(ofSize: CGFloat(10.0))
        set.valueTextColor = #colorLiteral(red: 0.941176470588235, green: 0.933333333333333, blue: 0.274509803921569, alpha: 1.0)
        set.axisDependency = .left
        
        // MARK: LineChartData
        let data = LineChartData(dataSet: set)
        return data
    }
    
    func generateBarData() -> BarChartData
    {
        // MARK: BarChartDataEntry
        var entries1 = [BarChartDataEntry]()
        var entries2 = [BarChartDataEntry]()
        
        for _ in 0..<ITEM_COUNT
        {
            entries1.append(BarChartDataEntry(x: 0.0, y: (Double(arc4random_uniform(25) + 25))))
            // stacked
            entries2.append(BarChartDataEntry(x: 0.0, yValues: [Double(arc4random_uniform(13) + 12), Double(arc4random_uniform(13) + 12)]))
        }
        
        // MARK: BarChartDataSet
        let set1            = BarChartDataSet(values: entries1, label: "Bar 1")
        set1.colors         = [#colorLiteral(red: 0.235294117647059, green: 0.862745098039216, blue: 0.305882352941176, alpha: 1.0)]
        set1.valueTextColor = #colorLiteral(red: 0.235294117647059, green: 0.862745098039216, blue: 0.305882352941176, alpha: 1.0)
        set1.valueFont      = .systemFont(ofSize: CGFloat(10.0))
        set1.axisDependency = .left
        
        let set2            = BarChartDataSet(values: entries2, label: "Bar 2")
        set2.stackLabels    = ["Stack 1", "Stack 2"]
        set2.colors         = [#colorLiteral(red: 0.23921568627451, green: 0.647058823529412, blue: 1.0, alpha: 1.0),  #colorLiteral(red: 0.090196078431373, green: 0.772549019607843, blue: 1.0, alpha: 1.0)]
        set2.valueTextColor = #colorLiteral(red: 0.23921568627451, green: 0.647058823529412, blue: 1.0, alpha: 1.0)
        set2.valueFont      = .systemFont(ofSize: CGFloat(10.0))
        set2.axisDependency = .left
        
        // MARK: BarChartData
        let groupSpace = 0.06
        let barSpace = 0.01
        let barWidth = 0.46
        
        // x2 dataset
        // (0.45 + 0.02) * 2 + 0.06 = 1.00 -> interval per "group"
        let data = BarChartData(dataSets: [set1, set2])
        data.barWidth = barWidth
        // make this BarData object grouped
        data.groupBars(fromX: 0.0, groupSpace: groupSpace, barSpace: barSpace)     // start at x = 0
        return data
    }
    
    func generateScatterData() -> ScatterChartData
    {
        // MARK: ChartDataEntry
        var entries = [ChartDataEntry]()
        var index = 0.0
        while index < Double(ITEM_COUNT)
        {
            entries.append(ChartDataEntry(x: index + 0.25, y: (Double(arc4random_uniform(10) + 55))))
            index += 0.5
        }
        
        // MARK: ScatterChartDataSet
        let set = ScatterChartDataSet(values: entries, label: "Scatter DataSet")
        set.colors = ChartColorTemplates.material()
        set.scatterShapeSize = 4.5
        set.drawValuesEnabled = false
        set.valueFont = .systemFont(ofSize: CGFloat(10.0))
        
        // MARK: ScatterChartData
        let data = ScatterChartData()
        data.addDataSet(set)
        return data
    }
    
    func generateCandleData() -> CandleChartData
    {
        // MARK: CandleChartDataEntry
        var entries = [CandleChartDataEntry]()
        var index = 0
        while index < ITEM_COUNT {
            entries.append(CandleChartDataEntry(x: Double(index + 1), shadowH: 90.0, shadowL: 70.0, open: 85.0, close: 75.0))
            index += 2
        }
        
        // MARK: CandleChartDataSet
        let set = CandleChartDataSet(values: entries, label: "Candle DataSet")
        set.colors = [#colorLiteral(red: 0.313725490196078, green: 0.313725490196078, blue: 0.313725490196078, alpha: 1.0)]
        
        set.decreasingColor = #colorLiteral(red: 0.556862745098039, green: 0.588235294117647, blue: 0.686274509803922, alpha: 1.0)
        set.shadowColor = NSColor.darkGray
        set.valueFont = .systemFont(ofSize: CGFloat(10.0))
        set.drawValuesEnabled = false
        
        // MARK: CandleChartData
        let data = CandleChartData()
        data.addDataSet(set)
        return data
    }
    
    func generateBubbleData() -> BubbleChartData
    {
        // MARK: BubbleChartDataEntry
        var entries = [BubbleChartDataEntry]()
        for index in 0..<ITEM_COUNT
        {
            let y = Double(arc4random_uniform(10)) + 105.0
            let size = Double(arc4random_uniform(50)) + 105.0
            entries.append(BubbleChartDataEntry(x: Double(index) + 0.5, y: y, size: CGFloat(size)))
        }
        
        // MARK: BubbleChartDataSet
        let set = BubbleChartDataSet(values: entries, label: "Bubble DataSet")
        set.colors = ChartColorTemplates.vordiplom()
        set.valueTextColor = .white
        set.valueFont = NSFont.systemFont(ofSize: CGFloat(10.0))
        set.drawValuesEnabled = true
        set.normalizeSizeEnabled  = true
        
        // MARK: BubbleChartData
        let data = BubbleChartData()
        data.addDataSet(set)
        return data
    }
}

// MARK: - ChartViewDelegate
extension CombinedChartViewController: ChartViewDelegate
{
    public func chartScaled(_ chartView: ChartViewBase, scaleX: CGFloat, scaleY: CGFloat) {
        
    }
    
    public func chartTranslated(_ chartView: ChartViewBase, dX: CGFloat, dY: CGFloat) {
        
    }
    
    public func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight)
    {
       chartView.highlightValue(x: 0, dataSetIndex: 1)
        print("chartValueSelected : x = \(highlight.x)")
    }
    
    public func chartValueNothingSelected(_ chartView: ChartViewBase)
    {
        print("chartValueNothingSelected")
    }
    
    public class BarChartFormatter: NSObject, IAxisValueFormatter
    {
        var months: [String]! = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        
        public func stringForValue(_ value: Double, axis: AxisBase?) -> String
        {
            let modu =  Double(value).truncatingRemainder(dividingBy: Double(months.count))
            return months[ Int(modu) ]
        }
    }
}









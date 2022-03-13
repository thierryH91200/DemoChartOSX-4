//
//  LineChartRealTimeViewController.swift
//  DemoChartOSX
//
//  Created by thierryH24100 on 25/08/2017.
//  Copyright © 2017 thierryH24100. All rights reserved.
//

import AppKit
import Charts


class LineChartRealTimeViewController: NSViewController {
    
    @IBOutlet var chartView : LineChartView!
    
    @IBOutlet weak var time: NSTextField!
    
    var yEntries = [ChartDataEntry]()
    var currentCount = 0.0
    
    let deltaMaximum = 20.0
    
    var timer  : Timer?
    var step = 0.0
    
    override func viewWillDisappear()
    {
        super.viewWillDisappear()
        if timer != nil {
            timer!.invalidate()
            timer = nil
        }
    }
    
    override public func viewDidAppear() {
        super.viewDidAppear()
        view.window!.title = "Real Time Line"
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        chartView.drawBordersEnabled = true
        chartView.drawGridBackgroundEnabled = true
        chartView.gridBackgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        chartView.chartDescription?.enabled = false
        
        step = 0.2
        
        let leftAxis = chartView.leftAxis
        leftAxis.axisMaximum = 8
        leftAxis.axisMinimum = -8
//        leftAxis.nameAxisFont = NSUIFont.boldSystemFont(ofSize: 16.0)
//        leftAxis.nameAxis = "Amount"
//        leftAxis.nameAxisEnabled = true
        leftAxis.drawLimitLinesBehindDataEnabled = false
        
//        let xAxis = chartView.xAxis
//        xAxis.nameAxisFont = NSUIFont.boldSystemFont(ofSize: 16.0)
//        xAxis.nameAxis = "Time"
//        xAxis.nameAxisEnabled = true

        let rightAxis = chartView.rightAxis
        rightAxis.enabled = false

        let marker = RectMarker(color: .yellow, font: NSFont.systemFont(ofSize: CGFloat(12.0)), insets: NSEdgeInsets(top: 8.0, left: 8.0, bottom: 4.0, right: 4.0))
        marker.chartView = chartView
        marker.minimumSize = CGSize(width: CGFloat(60.0), height: CGFloat(30.0))
        chartView.marker = marker
        
        initData()
    }
    
    func initData()
    {
        addLimit(index: 6.0, label: "Severe", color: .red)
        addLimit(index: 4.0, label: "Moderate", color: .orange)
        addLimit(index: 2.0, label: "Light", color: .green)
        
        addLimit(index: -2.0, label: "Light", color: .green)
        addLimit(index: -4.0, label: "Moderate", color: .orange)
        addLimit(index: -6.0, label: "Severe", color: .red)
        
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.axisMinimum = 0.0
        xAxis.axisMaximum = deltaMaximum
        
        currentCount = 10
        time.intValue = Int32(currentCount)
        
        yEntries.removeAll()
        
        for i in stride(from: 0, to: 10, by: step) {
            let val = Double(arc4random_uniform(UInt32(10))) - 5
            yEntries.append(ChartDataEntry(x: i, y: val))
        }
        
        var set1 = LineChartDataSet()
        set1 = LineChartDataSet(entries: yEntries, label: "DataSet 1")
        set1.axisDependency = .left
        set1.setColor(NSColor.black)
        set1.highlightColor = .black
        set1.highlightLineDashPhase = 1.0
        set1.fillColor = .black
        set1.mode = .cubicBezier
        
        set1.drawCirclesEnabled = false
        set1.drawFilledEnabled = false
        set1.drawValuesEnabled = false

        var dataSets = [LineChartDataSet]()
        dataSets.append(set1)
        
        let data = LineChartData(dataSets: dataSets)
        data.setValueTextColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        data.setValueFont(NSFont(name: "HelveticaNeue-Light", size: CGFloat(9.0))!)
        chartView.data = data
    }
    
    @objc func addValuesToChart()
    {
        let yValue = Double(arc4random_uniform(UInt32(10))) - 5
        let chartEntry = ChartDataEntry(x: currentCount, y: yValue)
        yEntries.append(chartEntry)
        
        if yEntries.count == Int(deltaMaximum / step)
        {
            chartView.xAxis.resetCustomAxisMax()
            chartView.xAxis.resetCustomAxisMin()
        }
        
        if yEntries.count >= Int(deltaMaximum / step)
        {
            yEntries.removeFirst()
        }
        
        chartView.moveViewToX(Double(currentCount))
        time.intValue = Int32(currentCount)
        currentCount = currentCount + step
        
        var set1 = LineChartDataSet()
        set1 = (chartView.data?.dataSets[0] as? LineChartDataSet)!
        
        set1.replaceEntries(yEntries)
        chartView.data?.notifyDataChanged()
        chartView.notifyDataSetChanged()
    }
    
    func addLimit( index: Double, label : String, color: NSUIColor) {
        
        let llYAxis = ChartLimitLine(limit: index , label: label)
        llYAxis.lineColor = color
        llYAxis.valueTextColor = color
        llYAxis.valueFont = NSUIFont.boldSystemFont(ofSize: 16.0)
        llYAxis.labelPosition = ChartLimitLine.LabelPosition.bottomRight
        llYAxis.lineWidth = 5.0
        
        let leftAxis = chartView.leftAxis
        leftAxis.addLimitLine(llYAxis)
    }

    @IBAction func pauseButton(_ sender: Any) {
        
        if timer != nil {
            timer!.invalidate()
            timer = nil
        }
    }
    
    @IBAction func playButton(_ sender: Any) {
        if timer != nil {
            timer!.invalidate()
            timer = nil
        }
        timer = Timer.scheduledTimer(timeInterval: step, target: self, selector: #selector(self.addValuesToChart), userInfo: nil, repeats: true)
    }
    
    
    @IBAction func resetData(_ sender: Any) {
        initData()
    }
}

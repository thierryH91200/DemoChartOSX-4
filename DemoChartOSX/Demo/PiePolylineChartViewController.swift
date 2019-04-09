//
//  PiePolylineChartViewController .swift
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

open class PiePolylineChartViewController: DemoBaseViewController
{
    @IBOutlet var chartView: PieChartView!
        
    @IBOutlet weak var sliderX: NSSlider!
    @IBOutlet weak var sliderY: NSSlider!
    
    @IBOutlet weak var sliderTextX: NSTextField!
    @IBOutlet weak var sliderTextY: NSTextField!
    
    override open func viewDidAppear()
    {
        super.viewDidAppear()
        view.window!.title = "Pie Chart with Polyline"
    }
    
    override open func viewWillAppear()
    {
        chartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
    }
    
    override open func viewDidLoad()
    {
        super.viewDidLoad()
        
        setupPieChartView( chartView)
        
        let paragraphStyle: NSMutableParagraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.alignment = .center
        
        let centerText: NSMutableAttributedString = NSMutableAttributedString(string: "Charts\nby Daniel Cohen Gindi")
        centerText.setAttributes([.font: NSFont(name: "HelveticaNeue-Light", size: 15.0)!,
                                  .paragraphStyle: paragraphStyle], range: NSMakeRange(0, centerText.length))
        centerText.addAttributes([ .font: NSFont(name: "HelveticaNeue-Light", size: 13.0)!,
                                  .foregroundColor: NSColor.gray], range: NSMakeRange(10, centerText.length - 10))
        
        centerText.addAttributes([.font: NSFont(name: "HelveticaNeue-LightItalic", size: 13.0)!,
                                  .foregroundColor: NSColor(red: 51 / 255.0, green: 181 / 255.0, blue: 229 / 255.0, alpha: 1.0)], range: NSMakeRange(centerText.length - 19, 19))
        chartView.centerAttributedText = centerText

        chartView.legend.enabled = false
        
        sliderX.doubleValue = 4.0
        sliderY.doubleValue = 100.0
        slidersValueChanged(sliderX)
    }
    
    override func updateChartData()
    {
        setDataCount(Int(sliderX.intValue) + 1, range: sliderY.doubleValue)
    }
    
    func setDataCount(_ count: Int, range: Double)
    {
        // MARK: PieChartDataEntry
        let mult: Double = range
        var entries = [PieChartDataEntry]()
        for i in 0..<count {
            entries.append(PieChartDataEntry(value: (Double(arc4random_uniform(UInt32(mult))) + mult / 5), label: parties[i % parties.count]))
        }
        
        // MARK: PieChartDataSet
        let dataSet = PieChartDataSet(values: entries, label: "Election Results")
        dataSet.sliceSpace = 2.0
        
        // add a lot of colors
        var colors = [NSColor]()
        colors.append( ChartColorTemplates.vordiplom()[0] )
        colors.append( ChartColorTemplates.joyful()[0] )
        colors.append( ChartColorTemplates.colorful()[0] )
        colors.append( ChartColorTemplates.liberty()[0])
        colors.append( ChartColorTemplates.pastel()[0] )
        colors.append(#colorLiteral(red: 0.215686274509804, green: 0.709803921568627, blue: 0.898039215686275, alpha: 1.0))
        
        dataSet.colors = colors
        dataSet.valueLinePart1OffsetPercentage = 0.8
        dataSet.valueLinePart1Length = 0.2
        dataSet.valueLinePart2Length = 0.4
        dataSet.xValuePosition = .outsideSlice
        dataSet.yValuePosition = .outsideSlice
        
        // MARK: PieChartData
        let data = PieChartData(dataSet: dataSet)
        
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1.0
        pFormatter.percentSymbol = " %"
 
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        data.setValueFont(NSFont(name: "HelveticaNeue-Light", size: CGFloat(11.0))!)
        data.setValueTextColor(NSColor.black)
        chartView.data = data
        chartView.highlightValues(nil)
    }
        
    @IBAction func slidersValueChanged(_ sender: AnyObject)
    {
        sliderTextX.stringValue = String(Int( sliderX.intValue))
        sliderTextY.stringValue = String(Int( sliderY.intValue))
        updateChartData()
    }
    
}



//
//  TogglePieViewController
//  minimalTunes
//
//  Created by John Moody on 12/1/16.
//  Copyright © 2016 John Moody. All rights reserved.
//

import Cocoa
import Charts

class ToggleRadarViewController: DemoBaseViewController
{
    var chartView : RadarChartView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func toggleButton(_ sender: NSButton) {
        let option = sender.title
        
        switch option {
        case "X-Labels":
            chartView?.xAxis.isDrawLabelsEnabled = !(chartView?.xAxis.isDrawLabelsEnabled)!
            chartView?.data?.notifyDataChanged()
            chartView?.notifyDataSetChanged()
            chartView?.needsDisplay = true
            
        case "Y-Labels":
            chartView?.yAxis.isDrawLabelsEnabled = !(chartView?.yAxis.isDrawLabelsEnabled)!
            chartView?.needsDisplay = true
            
        case "Rotate":
            chartView?.isRotationEnabled = !(chartView?.isRotationEnabled)!
            chartView?.needsDisplay = true
            
        case "highlight circle":
            for set in chartView?.data!.dataSets as! [RadarChartDataSet] {
                set.isDrawHighlightCircleEnabled = !set.isDrawHighlightCircleEnabled
            }
            chartView?.needsDisplay = true
            
        default:
            super.handleOption(option, forChartView: chartView!)
        }
    }
}

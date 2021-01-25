//
//  TogglePieViewController
//  minimalTunes
//
//  Created by John Moody on 12/1/16.
//  Copyright © 2016 John Moody. All rights reserved.
//

import AppKit
import Charts

class ToggleCombinedViewController: DemoBaseViewController
{
    var chartView : CombinedChartView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func toggleButton(_ sender: NSButton) {
        let option = sender.title
        
        switch option {
        case "Line Values":
            for set in (chartView?.data!.dataSets)! {
                if let set = set as? LineChartDataSet {
                    set.drawValuesEnabled = !set.isDrawValuesEnabled
                    
                }
            }
            chartView?.needsDisplay = true
            
        case "Bar Values":
            for set in (chartView?.data!.dataSets)! {
                if let set = set as? BarChartDataSet {
                    set.drawValuesEnabled = !set.isDrawValuesEnabled
                }
            }
            chartView?.needsDisplay = true
            
        default:
            super.handleOption(option, forChartView: chartView!)
        }
    }
}

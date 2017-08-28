//
//  TogglePieViewController
//  minimalTunes
//
//  Created by John Moody on 12/1/16.
//  Copyright © 2016 John Moody. All rights reserved.
//

import Cocoa
import Charts

class TogglePieViewController: DemoBaseViewController
{
    var chartView : PieChartView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func toggleButton(_ sender: NSButton) {
        let option = sender.title
        
        switch option {
        case "X-Values":
            chartView?.isDrawEntryLabelsEnabled = !(chartView?.isDrawEntryLabelsEnabled)!
            chartView?.needsDisplay = true
            
        case "Percent":
            chartView?.usePercentValues = !(chartView?.usePercentValues)!
            chartView?.needsDisplay = true
            
        case "Hole":
            chartView?.isDrawHoleEnabled = !(chartView?.isDrawHoleEnabled)!
            chartView?.needsDisplay = true
            
        case "Draw CenterText":
            chartView?.isDrawCenterTextEnabled = !(chartView?.isDrawCenterTextEnabled)!
            chartView?.needsDisplay = true
            
        case "Spin":
            chartView?.spin(duration: 2,
                            fromAngle: (chartView?.rotationAngle)!,
                            toAngle: (chartView?.rotationAngle)! + 360,
                           easingOption: .easeInCubic)
            chartView?.needsDisplay = true
            
        default:
            super.handleOption(option, forChartView: chartView!)
        }
    }
}

//
//  ChartsViewController.swift
//  HackSC Project
//
//  Created by Adithya Nair on 2/1/20.
//  Copyright © 2020 Adithya Nair. All rights reserved.
//

import UIKit
import Charts

class ChartsViewController: UIViewController {
    
    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var mainLabel: UILabel!
    
    
    var sentimentIndexArray: [Double] = []
    var sentimentIndexValue: Double = 0
    var account: Account?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print(postsOutputSentiment)
        if account?.getType() == "Therapist" {
            mainLabel.text = "Their daily sentiments"
        }
        
        for array in postsOutputSentiment {
            sentimentIndexValue = 0
            for sentiment in array {
                switch sentiment {
                case "Pos":
                    sentimentIndexValue += 1
                case "Neg":
                    sentimentIndexValue -= 1
                default:
                    ()
                }
            }
            sentimentIndexArray.append(sentimentIndexValue)
        }
        
        var xLabels = [String]()
        
        if sentimentIndexArray.count == 0 {
            barChartView.noDataText = "You need to provide data for the chart."
        } else {
            for count in 1...sentimentIndexArray.count {
                xLabels.append("Post \(String(count))")
            }
            
            setChart(dataPoints: xLabels, values: sentimentIndexArray)
        }
        
        barChartView.xAxis.labelTextColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        barChartView.xAxis.labelFont = UIFont(name: "HelveticaNeue", size: 10)!
        barChartView.leftAxis.labelTextColor = #colorLiteral(red: 0, green: 0.6829840541, blue: 0.9992756248, alpha: 1)
        barChartView.rightAxis.labelTextColor = #colorLiteral(red: 0, green: 0.6829840541, blue: 0.9992756248, alpha: 1)
        barChartView.legend.textColor = #colorLiteral(red: 0, green: 0.6829840541, blue: 0.9992756248, alpha: 1)
        barChartView.barData?.setValueFont(UIFont(name: "HelveticaNeue", size: 8)!)
        barChartView.barData?.setValueTextColor(#colorLiteral(red: 0, green: 0.6829840541, blue: 0.9992756248, alpha: 1))
        
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        
        var dataEntries: [BarChartDataEntry] = []
                
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
                
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Sentiment Index")
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.data = chartData
        barChartView.animate(xAxisDuration: 0.7, yAxisDuration: 0.7)
            
    }
    
}

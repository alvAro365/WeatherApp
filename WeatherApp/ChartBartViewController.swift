//
//  ChartBartViewController.swift
//  WeatherApp
//
//  Created by Alvar Aronija on 19/03/2018.
//  Copyright © 2018 Alvar Aronija. All rights reserved.
//

import UIKit
import Charts

class ChartBartViewController: UIViewController {

    @IBOutlet weak var barChart: BarChartView!
    var citiesToCompare: [City] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        createCharts(cities: citiesToCompare)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func createCharts(cities: [City]) {
        var dataSets: [BarChartDataSet] = []
        let colors = ChartColorTemplates.joyful()
        var i = 1.0
        var y = 0
        for city in cities {
            let dataEntry = BarChartDataEntry(x: i, y: Double(city.temperature))
            let dataSet = BarChartDataSet(values: [dataEntry], label: city.name)
            dataSet.colors = [colors[y]]
            dataSets.append(dataSet)
            i += 1.0
            y += 1
        }
        
        let data = BarChartData(dataSets: dataSets)
        barChart.data = data
        customizeBarChart()
        barChart.notifyDataSetChanged()
    }
    
    func customizeBarChart() {
        //legend customization
        let legend = barChart.legend
        legend.horizontalAlignment = .center
        legend.verticalAlignment = .bottom
        legend.drawInside = true
        legend.orientation = .horizontal
        legend.textColor = UIColor.white

        // barChart customization
        barChart.xAxis.drawGridLinesEnabled = false
        barChart.rightAxis.enabled = false
        barChart.xAxis.enabled = false
        barChart.scaleYEnabled = false
        barChart.scaleXEnabled = false
        barChart.highlighter = nil
        barChart.leftAxis.labelTextColor = UIColor.white
        barChart.xAxis.labelPosition = .bottom
        barChart.xAxis.drawLabelsEnabled = false
        barChart.chartDescription?.text = ""

        // BarChart animation
        barChart.animate(yAxisDuration: 1.5, easingOption: .easeInOutQuart)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}


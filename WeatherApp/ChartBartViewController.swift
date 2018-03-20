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

    @IBOutlet weak var number1: UISlider!
    @IBOutlet weak var barChart: BarChartView!
    @IBAction func renderCharts() {
        barChartUpdate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        barChartUpdate()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Private methods
    func barChartUpdate() {
        let entry = BarChartDataEntry(x: 1.0, y: Double(number1.value))
        let entry2 = BarChartDataEntry(x: 2.0, y: 25.0)
        let entry3 = BarChartDataEntry(x: 3.0, y: 50.0)
        let dataSet = BarChartDataSet(values: [entry], label: "Tallinn")
        let dataSet1 = BarChartDataSet(values: [entry2], label: "Oslo")
        let dataSet2 = BarChartDataSet(values: [entry3], label: "Gothenburg")
        let colors = ChartColorTemplates.joyful()
        dataSet.colors = [colors[0]]
        dataSet1.colors = [colors[1]]
        dataSet2.colors = [colors[2]]
        let data = BarChartData(dataSets: [dataSet, dataSet1, dataSet2])
        
        
        //legend customization
        let legend = barChart.legend
        legend.horizontalAlignment = .center
        legend.verticalAlignment = .top
        legend.drawInside = true
//        legend.orientation = .vertical
//        legend.yOffset = 10.0;
//        legend.xOffset = 10.0;
        legend.yEntrySpace = 0.0
        
        // barChart customization
        barChart.xAxis.drawGridLinesEnabled = false
        barChart.rightAxis.enabled = false
        barChart.scaleYEnabled = false
        barChart.scaleXEnabled = false
        barChart.highlighter = nil
        barChart.xAxis.labelPosition = .bottom
        barChart.xAxis.drawLabelsEnabled = false
        barChart.chartDescription?.text = "Temperature"
        barChart.chartDescription?.position = CGPoint(x: 50.0, y: 580.0)
        
        // BarChart animation
        barChart.animate(yAxisDuration: 1.5, easingOption: .easeInOutQuart)
        
        // This must stay at the end of the function
        barChart.data = data
        barChart.notifyDataSetChanged()
        
    }
    
    func createCharts(cities: [City]) {
//        var dataEntries: [BarChartDataEntry] = []
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
        legend.verticalAlignment = .top
        legend.drawInside = true
        //        legend.orientation = .vertical
        //        legend.yOffset = 10.0;
        //        legend.xOffset = 10.0;
        legend.yEntrySpace = 0.0
        
        // barChart customization
        barChart.xAxis.drawGridLinesEnabled = false
        barChart.rightAxis.enabled = false
        barChart.scaleYEnabled = false
        barChart.scaleXEnabled = false
        barChart.highlighter = nil
        barChart.xAxis.labelPosition = .bottom
        barChart.xAxis.drawLabelsEnabled = false
        barChart.chartDescription?.text = "Temperature"
        barChart.chartDescription?.position = CGPoint(x: 50.0, y: 580.0)
        
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


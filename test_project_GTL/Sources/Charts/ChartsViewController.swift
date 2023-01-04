//
//  TestViewController.swift
//  test_project_GTL
//
//  Created by User on 02.01.2023.
//

import UIKit
import Charts

class ChartsViewController: UIViewController {

    let data: [ChartDataEntry] = [
        ChartDataEntry(x: 0, y: 0),
        ChartDataEntry(x: 1, y: 150),
        ChartDataEntry(x: 2, y: 155),
        ChartDataEntry(x: 3, y: 180),
        ChartDataEntry(x: 4, y: 140),
        ChartDataEntry(x: 5, y: 143),
        ChartDataEntry(x: 6, y: 120),
        ChartDataEntry(x: 7, y: 127),
        ChartDataEntry(x: 8, y: 150),
        ChartDataEntry(x: 9, y: 130),
        ChartDataEntry(x: 10, y: 135),
        ChartDataEntry(x: 11, y: 150),
        ChartDataEntry(x: 12, y: 155),
        ChartDataEntry(x: 13, y: 162),
        ChartDataEntry(x: 14, y: 140),
        ChartDataEntry(x: 15, y: 143),
        ChartDataEntry(x: 16, y: 127),
        ChartDataEntry(x: 17, y: 127),
        ChartDataEntry(x: 18, y: 143),
        ChartDataEntry(x: 19, y: 130),
        ChartDataEntry(x: 20, y: 140),
        ChartDataEntry(x: 21, y: 147),
        ChartDataEntry(x: 22, y: 155),
        ChartDataEntry(x: 23, y: 163),
        ChartDataEntry(x: 24, y: 140),
        ChartDataEntry(x: 25, y: 143),
        ChartDataEntry(x: 26, y: 120),
        ChartDataEntry(x: 27, y: 127),
        ChartDataEntry(x: 28, y: 140),
        ChartDataEntry(x: 29, y: 130),
        ChartDataEntry(x: 30, y: 125),
        ChartDataEntry(x: 11, y: 137),
    ]

    lazy var lineChartsView: LineChartView = {
        let view = LineChartView()
        view.rightAxis.enabled = false
        let yAxis = view.leftAxis
        yAxis.labelFont = .boldSystemFont(ofSize: 13)
        yAxis.setLabelCount(6, force: false)
        yAxis.labelTextColor = .systemCyan
        yAxis.axisLineColor = .systemCyan
        yAxis.drawZeroLineEnabled = false

        view.xAxis.labelPosition = .bottom
        view.xAxis.labelFont = .boldSystemFont(ofSize: 13)
        view.xAxis.setLabelCount(6, force: false)
        view.xAxis.labelTextColor = .systemCyan
        view.xAxis.axisLineColor = .systemCyan

        view.animate(xAxisDuration: 2)

        view.legend.enabled = false

        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupHierarchy()
        setupLayout()
        setData()
    }

    private func setupHierarchy() {
        view.addSubview(lineChartsView)
    }

    private func setupLayout() {
        lineChartsView.snp.makeConstraints { make in
            make.center.equalTo(view.snp.center)
            make.width.equalTo(view.snp.width).multipliedBy(0.88)
            make.height.equalTo(view.snp.height).multipliedBy(0.3)
        }
    }

    func setData() {
        let set1 = LineChartDataSet(entries: data, label: "Example Data")
        set1.drawCirclesEnabled = false
        set1.mode = .cubicBezier
        set1.lineWidth = 3

        set1.circleHoleColor = .white
        set1.setColor(.systemCyan)

        let chartData = LineChartData(dataSet: set1)
        chartData.setDrawValues(false)
        lineChartsView.data = chartData
    }


}

extension ChartsViewController: ChartViewDelegate {
    func chartValueSelected(
        _ chartView: ChartViewBase,
        entry: ChartDataEntry,
        highlight: Highlight
    ) {
        print(entry)
    }
}

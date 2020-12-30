//
//  ChartViewController.swift
//  ChartDemo
//
//  Created by Mithilesh Kumar on 29/12/20.
//

import UIKit
import WebKit
import ChartIQ

class ChartViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var chartIQView: ChartIQView!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        chartIQView.delegate = self
        chartIQView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Data
    
    // Sample code for loading data form your feed.
    func loadChartData(by params: ChartIQQuoteFeedParams, completionHandler: @escaping ([ChartIQData]) -> Void) {
        let urlString = "https://simulator.chartiq.com/datafeed?identifier=\(params.symbol)" +
            "&startdate=\(params.startDate)" +
            "\(params.endDate.isEmpty ? "" : "&enddate=\(params.endDate)")" +
            "&interval=\(params.interval)" +
            "&period=\(params.period)&seed=1001"
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else { return }
            guard let data = data else { return }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sssZ"
            var chartData = [ChartIQData]();
            let json = try! JSONSerialization.jsonObject(with: data, options: [])
            guard let result = json as? [[String: Any]] else { return }
            result.forEach({ (item) in
                let close = item["Close"] as? Double ?? 0
                let dt = item["DT"] as? String ?? ""
                let date = dateFormatter.date(from: dt)!
                let high = item["High"] as? Double ?? 0
                let low = item["Low"] as? Double ?? 0
                let open = item["Open"] as? Double ?? 0
                let volume = item["Volume"] as? Int ?? 0
                let _data = ChartIQData(date: date, open: open, high: high, low: low, close: close, volume: Double(volume), adj_close: close)
                chartData.append(_data)
            })
            completionHandler(chartData)
        }
        task.resume()
    }
}

// MARK: - ChartIQDelegate

extension ChartViewController: ChartIQDelegate {
    
    func chartIQViewDidFinishLoading(_ chartIQView: ChartIQView) {
        chartIQView.setDataMethod(.pull)
        chartIQView.setSymbol("APPL")
    }
    
}

// MARK: - ChartIQDataSource

extension ChartViewController: ChartIQDataSource {
    
    public func pullInitialData(by params: ChartIQQuoteFeedParams, completionHandler: @escaping ([ChartIQData]) -> Void) {
        // put code for initial data load from your feed here
        loadChartData(by: params, completionHandler: completionHandler)
    }
    
    public func pullUpdateData(by params: ChartIQQuoteFeedParams, completionHandler: @escaping ([ChartIQData]) -> Void) {
        // put code for initial data load from your feed here
        loadChartData(by: params, completionHandler: completionHandler)
    }
    
    public func pullPaginationData(by params: ChartIQQuoteFeedParams, completionHandler: @escaping ([ChartIQData]) -> Void) {
        // put code for initial data load from your feed here
        loadChartData(by: params, completionHandler: completionHandler)
    }
}

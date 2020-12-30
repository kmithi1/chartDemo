//
//  ViewController.swift
//  ChartDemo
//
//  Created by Mithilesh Kumar on 29/12/20.
//

import UIKit

class ViewController: UIViewController {
    enum ChartType {
        case iq
        case tradingView
    }
    
    private var chartType = ChartType.iq
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let chartVC = segue.destination as? ChartViewController else {
            return
        }
        
        // setup chart vc
    }
    
    @IBAction
    func didTapOpenChartIqsChart(_ sender: UIButton) {
        self.chartType = .iq
        performSegue(withIdentifier: "openChart", sender: self)
    }
}


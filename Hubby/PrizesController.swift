//
//  PrizesController.swift
//  Hubby
//
//  Created by Jaafar Rammal on 06/02/2022.
//

import Foundation
import UIKit
import SwiftUI

let vouchers = [
    [
      "company_name": "Pure Gym",
      "voucher_title": "Free PT Session",
      "voucher_code": "757fb57947768cf0b70211befa29e476",
      "metric": "200",
      "picture": "puregym"
    ],
    [
      "company_name": "Huel",
      "voucher_title": "Free Protein Shake",
      "voucher_code": "c81be088822b71fb103bf66994f404ea",
      "metric": "400",
      "picture": "huel"
    ],
//    [
//      "company_name": "Sports Direct",
//      "voucher_title": "Free Running Sneakers",
//      "voucher_code": "1d0da8fd862b57b7a72c5ce728ae544b",
//      "metric": "5000",
//      "picture": "sportsdirect"
//    ],
//    [
//      "company_name": "Virgin Active",
//      "voucher_title": "Free Weekly Pass",
//      "voucher_code": "0300812843c72070148dcaacd4c81192",
//      "metric": "150",
//      "picture": "virgin"
//    ],
    [
      "company_name": "Hello Fresh",
      "voucher_title": "40% Off Voucher",
      "voucher_code": "1060e12968f16090958efb2769168178",
      "metric": "100",
      "picture": "fresh"
    ],
//    [
//      "company_name": "Gousto",
//      "voucher_title": "30% Off Voucher",
//      "voucher_code": "4492e9f82cf0e218025efce4b33debdf",
//      "metric": "1000",
//      "picture": "gousto"
//    ],
//    [
//      "company_name": "Gym Shark",
//      "voucher_title": "50% Off Voucher",
//      "voucher_code": "602ed807e7025cafbdf34311a0fb62cf",
//      "metric": "750",
//      "picture": "shark"
//    ]
  ]

class PrizesController: UIViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        vouchers.forEach { voucher in
            let m = UIHostingController(rootView: Metric())
            m.view.translatesAutoresizingMaskIntoConstraints = false
            self.addChild(m)
            self.view.addSubview(m.view)
            m.didMove(toParent: self)
            NSLayoutConstraint.activate([
                m.view.widthAnchor.constraint(equalToConstant: self.view.frame.width),
                m.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            ])
        }
        
    }
}

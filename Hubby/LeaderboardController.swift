//
//  LeaderboardController.swift
//  Hubby
//
//  Created by Jaafar Rammal on 06/02/2022.
//

import UIKit
import SwiftUI
import TerraSwift

let users = [
    [
        "name": "Arjun",
        "score": "500",
        "device": "APPLE",
        "rank": "1",
    ],
    [
        "name": "Jaafar",
        "score": "\(progress)",
        "device": "FITBIT",
        "rank": "2",
    ],
    [
        "name": "Clara",
        "score": "190",
        "device": "GARMIN",
        "rank": "3",
    ],
    [
        "name": "Jason",
        "score": "10",
        "device": "GARMIN",
        "rank": "4",
    ]
]

class LeaderboardController: UIViewController {
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let m = UIHostingController(rootView: Leaderboard())
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

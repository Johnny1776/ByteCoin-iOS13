//
//  CoinProtocol.swift
//  ByteCoin
//
//  Created by John Durcan on 23/12/2022.
//  Copyright © 2022 The App Brewery. All rights reserved.
//

import Foundation

/// CustomViewDelegate to call functions in the source View
protocol CoinViewDelegate {
    func runCoinViewFunction()
    func didFailWithError(_ error: Error)
}

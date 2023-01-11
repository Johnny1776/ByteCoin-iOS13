//
//  CoinDataModels.swift
//  ByteCoin
//
//  Created by John Durcan on 23/12/2022.
//  Copyright © 2022 The App Brewery. All rights reserved.
//

import Foundation

///CoinData Model for retrieved data
struct CoinData: Decodable {
    let rate: Float
    init(rate: Float) {
        self.rate = rate
    }
}




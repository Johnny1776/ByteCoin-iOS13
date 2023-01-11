//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    @IBOutlet weak var currencyLabel: UILabel!
    
    let coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        coinManager.delegate = self
        // Do any additional setup after loading the view.
    }


}

///PickerView Functions
extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        print("We have \(coinManager.currencyArray.count) rows")

        return coinManager.currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("We are selecting:\(coinManager.currencyArray[row])")
        coinManager.getCoinPrice(for: coinManager.currencyArray[row])
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        print("We have \(coinManager.currencyArray[row]) title")

        return coinManager.currencyArray[row]
    }
}

///CoinViewDelegate and its associated functions
extension ViewController: CoinViewDelegate {
    ///Called when data in coinManager is updated
    ///
    ///Requires delegate to be assigned
    ///Updating screen requires DispatchQueue to be called.
    func runCoinViewFunction() {
        let queue = DispatchQueue(label: "update")
        queue.async {
            DispatchQueue.main.async {
                let currencySymbol = self.coinManager.currencyArray[self.currencyPicker.selectedRow(inComponent: 0)]
                self.currencyLabel.text = currencySymbol
                if let currencyValue = self.coinManager.coinData?.rate
                {
                    
                    let formatter = NumberFormatter()
                    formatter.currencySymbol = self.getSymbolForCurrencyCode(code: currencySymbol)
 // Change this to another locale if you want to force a specific locale, otherwise this is redundant as the current locale is the default already
                    formatter.numberStyle = .currency
                    if let formattedCurrency = formatter.string(from: currencyValue as NSNumber) {
                        self.bitcoinLabel.text = formattedCurrency
                    }

                }
            }
        }
    }
    
    func getSymbolForCurrencyCode(code: String) -> String {
        var candidates: [String] = []
        let locales: [String] = NSLocale.availableLocaleIdentifiers
        for localeID in locales {
            guard let symbol = findMatchingSymbol(localeID: localeID, currencyCode: code) else {
                continue
            }
            if symbol.count == 1 {
                return symbol
            }
            candidates.append(symbol)
        }
        let sorted = sortAscByLength(list: candidates)
        if sorted.count < 1 {
            return ""
        }
        return sorted[0]
    }

    func findMatchingSymbol(localeID: String, currencyCode: String) -> String? {
        let locale = Locale(identifier: localeID as String)
        guard let code = locale.currencyCode else {
            return nil
        }
        if code != currencyCode {
            return nil
        }
        guard let symbol = locale.currencySymbol else {
            return nil
        }
        return symbol
    }

    func sortAscByLength(list: [String]) -> [String] {
        return list.sorted(by: { $0.count < $1.count })
    }
    
    func didFailWithError(_ error: Error) {
        print(error)
    }
    
    
}

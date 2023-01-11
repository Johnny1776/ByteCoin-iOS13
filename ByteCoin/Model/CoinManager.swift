//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

class CoinManager: NSObject, URLSessionDelegate {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/"
    let apiKey = "7FD43F04-7946-4E33-B3D4-2706DBEFF9AC"
    let header = "X-CoinAPI-Key:"
    var mainCurrency = "BTC"
    
    var delegate: CoinViewDelegate?
    var coinData: CoinData?
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    
    func getCoinPrice(for currency: String){
        performRequest(with: "\(baseURL)\(mainCurrency)/\(currency)?apikey=\(apiKey)", header: nil)
//        performRequest(with: baseURL + currency, header: header)
    }
    
    
    
    /// Performs URL request
    /// Updates the objectData and calls the delegate.runDelegateFunction
    /// Note we also catch errors here. By implementing the didReceive URLSessionDelegate function, we ensure that URL Request errors are properly handled.
    /// In this instance, we continue with the loading if we recieve a SSL Error.
    ///
    /// - Parameters:
    /// - Parameter urlString: String or type URL

    func performRequest(with urlString:String, header header:String?){
        print (urlString)
        if let url = URL(string: urlString) { //We are creating a URL conforming to the URL Type
            let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil) //Here we are setting this class as the delegate to receive errors.
            
            var request = URLRequest(url: url)
            if (header != nil) {
                request.httpMethod = "GET"
                request.setValue(apiKey, forHTTPHeaderField: header!)
            }

            let task = session.dataTask(with: request) { data, response, error in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    if let dataObject = self.parseJSON(safeData) {
                        self.coinData = dataObject
                        print(self.coinData!.rate)
                        self.delegate?.runCoinViewFunction()
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ passedData: Data) -> CoinData?{
        let decoder = JSONDecoder()
        do { //A Do catch loop will catch errors thrown by functions to a try statement.
            let decodedData = try decoder.decode(CoinData.self, from: passedData)
            let objectData = try CoinData.init(rate: decodedData.rate)
            return objectData
        } catch {
            self.delegate?.didFailWithError(error)
            return nil
        }
    }
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let protectionSpace = challenge.protectionSpace
        guard protectionSpace.authenticationMethod ==
                NSURLAuthenticationMethodServerTrust,
              protectionSpace.host.contains("coinapi.io") else { //If we have an ssl error, proceed anyway provided its from this website.
            print("Ran default Handling and accepted")
            completionHandler(.performDefaultHandling, nil)
            return
        }
        completionHandler(.useCredential, nil)
        print("SSL error received.")
    }
    
    
}

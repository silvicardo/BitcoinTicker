//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Angela Yu on 23/01/2016.
//  Copyright © 2016 London App Brewery. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    var finalURL = ""

    //MARK: - IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    

    //MARK: - Metodi Standard del VC
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
       
    }

    
    //MARK: - Metodi UIPickerView Delegate
    
    //Una "sezione"
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    //tante righe quante le valute da monitorare
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    //per ogni riga il titolo da mostrare è uguale al contenuto nell'array valute all'indice "row"
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    //azione al momento della scelta della riga
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       
        print("Hai selezionato: \(currencyArray[row])\n")
        //creiamo un url personalizzato
        finalURL = baseURL + currencyArray[row]
        //tramite tale url otteniamo con Alamofire il JSON
        getBitcoinData(url: finalURL)
    }
    
    
//    
//    //MARK: - Networking
//    /***************************************************************/
    
    func getBitcoinData(url: String) {
        //esegue la richiesta all'url custom e ...
        Alamofire.request(url, method: .get).responseJSON { response in
                if response.result.isSuccess {//se abbiamo rispsta
                    
                    print("Successo! Ottenuti bitcoin datas\n")
                    //riversiamo la risposta in una costante di Tipo JSON
                    let bitcoinJSON : JSON = JSON(response.result.value!)
                    print("Questo è il JSON ottenuto: \n\n\(bitcoinJSON)\n")
                    //e la passiamo alla funzione preposta alla "lettura"
                    self.updateBitcoinData(json: bitcoinJSON)

                } else {//altrimenti comunichiamo l'errore
                    print("Error: \(String(describing: response.result.error))")
                    self.bitcoinPriceLabel.text = "Connection Issues"
                }
            }

    }

    //MARK: - JSON Parsing
    /***************************************************************/
    
    func updateBitcoinData(json : JSON) {
        //se il json è valido avrà la chiave last e
        if let bitcoinResult = json["last"].double {
            //mettiamo nella label e in console il risultato
            
            print("Abbiamo un JSON Valido;\nil valore di bitcoin nella valuta scelta è: \(bitcoinResult)")
            
            self.bitcoinPriceLabel.text = String(bitcoinResult)
            
        } else {//altrimenti comunichiamo l'errore all'utente
            
            self.bitcoinPriceLabel.text = "Non Disponibile"
        }

    }
    




}


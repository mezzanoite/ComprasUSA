//
//  DoubleConverter.swift
//  RafaelSoares
//
//  Created by Usuário Convidado on 25/04/18.
//  Copyright © 2018 fiap. All rights reserved.
//

import Foundation

extension String {
    
    // Converte uma String para Double tratando casos de vírgula e ponto
    var convertToDoubleDecimal: Double {
        let numberFormatter = NumberFormatter()
        numberFormatter.decimalSeparator = "."
        if let result = numberFormatter.number(from: self) {
            return result.doubleValue
        } else {
            numberFormatter.decimalSeparator = ","
            if let result = numberFormatter.number(from: self) {
                return result.doubleValue
            }
        }
        return 0
    }
    
}

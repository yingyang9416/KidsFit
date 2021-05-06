//
//  FlashAlert.swift
//  KidsFit
//
//  Created by Steven Yang on 5/6/21.
//

import Foundation
import SPAlert

class FlashAlert {
    static func present(error: Error) {
        SPAlert.present(message: error.localizedDescription, haptic: .error)
    }
    
    static func presentSuccess() {
        SPAlert.present(title: "Success!", preset: .done)
    }
    
    static func presentError(with message: String) {
        SPAlert.present(message: message, haptic: .error)
    }
}

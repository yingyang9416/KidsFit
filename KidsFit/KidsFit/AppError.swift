//
//  AppError.swift
//  KidsFit
//
//  Created by Steven Yang on 2/5/21.
//

import Foundation

enum AppError: Error {
    case networkError
    case noWodError
    case otherError
    
    var localizedDescription: String {
        switch self {
        case .networkError:
            return "Something went wrong with the network, please try again later"
        case .noWodError:
            return "Oops... We didn't find this WOD"
        case .otherError:
            return "Something went wrong... Please try again later"
        }
    }
}

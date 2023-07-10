//
//  AlertPresenter.swift
//  FakeNFT
//
//  Created by Konstantin Kirillov on 10.07.2023.
//

import UIKit

protocol AlertPresenterProtocol {
    func preparingDataAndDisplay(alertText: String, handler: @escaping () -> Void)
    func preparingAlertWithRepeat(alertText: String, handler: @escaping () -> Void )
}

protocol AlertPresenterDelegate: AnyObject {
    func showAlert(alert: UIAlertController)
}

struct AlertPresenter: AlertPresenterProtocol {
    weak var delegate: AlertPresenterDelegate?
    
    func preparingDataAndDisplay(alertText: String, handler: @escaping () -> Void ) {
        let alert = UIAlertController(title: "Произошла ошибка!",
                                      message: alertText,
                                      preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default) { _ in
            handler()
        }
        
        alert.addAction(alertAction)
        delegate?.showAlert(alert: alert)
    }
    
    func preparingAlertWithRepeat(alertText: String, handler: @escaping () -> Void ) {
        let alert = UIAlertController(title: "Произошла ошибка!",
                                      message: alertText,
                                      preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ок", style: .default)
        let alertRepeatAction = UIAlertAction(title: "Повторить", style: .default) { _ in
            handler()
        }
        
        alert.addAction(alertAction)
        alert.addAction(alertRepeatAction)
        
        delegate?.showAlert(alert: alert)
    }
}

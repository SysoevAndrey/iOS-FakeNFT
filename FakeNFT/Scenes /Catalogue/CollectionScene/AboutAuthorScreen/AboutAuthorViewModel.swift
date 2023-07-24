//
//  AboutAuthorViewModel.swift
//  FakeNFT
//
//  Created by Konstantin Kirillov on 11.07.2023.
//

import Foundation

final class AboutAuthorViewModel {
    let authorPageURL: String
    @Observable private(set) var loadingInProgress: Bool = false
    
    init(authorPageURL: String) {
        self.authorPageURL = authorPageURL
    }
    
    func changeLoadingStatus(loadingInProgress: Bool) {
        self.loadingInProgress = loadingInProgress
    }
}

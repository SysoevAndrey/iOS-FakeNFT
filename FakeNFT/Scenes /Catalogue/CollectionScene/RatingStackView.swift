//
//  RaitingUIImage.swift
//  FakeNFT
//
//  Created by Konstantin Kirillov on 09.07.2023.
//

import UIKit

final class RatingStackView: UIStackView {
    let countOfStars: Int
    
    init(countOfStars: Int) {
        self.countOfStars = countOfStars
        super.init(frame: .zero)
        
        setupView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        axis = .horizontal
        spacing = 2
        
        for _ in 0..<countOfStars {
            let starImageView = UIImageView(image: UIImage(systemName: "star.fill"))
            starImageView.tintColor = .lightGray
            
            NSLayoutConstraint.activate([
                starImageView.widthAnchor.constraint(equalToConstant: 12),
                starImageView.heightAnchor.constraint(equalToConstant: 12)
            ])
            addArrangedSubview(starImageView)
        }
    }
    
    func setupRating(rating: Int) {
        for star in 0..<rating {
            arrangedSubviews[star].tintColor = .yellow
        }
    }
}

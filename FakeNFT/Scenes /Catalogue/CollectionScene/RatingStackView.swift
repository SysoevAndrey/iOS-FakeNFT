//
//  RaitingUIImage.swift
//  FakeNFT
//
//  Created by Konstantin Kirillov on 09.07.2023.
//

import UIKit

final class RatingStackView: UIStackView {
    let countOfStars: Int
    let fillStarImageView = UIImage(named: "FillStar")
    let emptyStarImageView = UIImage(named: "EmptyStar")
    
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
        
        var starTag = 1
        for _ in 0..<countOfStars {
            let image = UIImageView()
            image.image = emptyStarImageView
            image.tag = starTag
            self.addArrangedSubview(image)
            starTag += 1
        }
    }
    
    func setupRating(rating: Int) {
        for subView in self.subviews {
            if let image = subView as? UIImageView{
                image.image = image.tag > rating ? emptyStarImageView : fillStarImageView
            }
        }
    }
}

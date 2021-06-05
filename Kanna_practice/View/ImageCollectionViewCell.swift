//
//  ImageCollectionViewCell.swift
//  Kanna_practice
//
//  Created by AlexandraTsai on 2021/6/5.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    func config(image: UIImage) {
        imageView.image = image
    }

    private let imageView = UIImageView()
}

private extension ImageCollectionViewCell {
    func setup() {
        addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

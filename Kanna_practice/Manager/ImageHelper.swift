//
//  ImageHelper.swift
//  Kanna_practice
//
//  Created by AlexandraTsai on 2021/9/3.
//

import UIKit

class ImageHelper {
    static func fetchImage(with url: String) -> UIImage? {
        guard let url = URL(string: url),
              let data = try? Data(contentsOf: url),
              let img = UIImage(data: data) else { return nil }
        return img
    }

    static func fetchImages(with urls: [String]) -> [UIImage] {
        var images = [UIImage]()
        urls.forEach {
            guard let url = URL(string: $0),
                  let data = try? Data(contentsOf: url),
                  let img = UIImage(data: data) else { return }
            images.append(img)
        }
        return images
    }
}

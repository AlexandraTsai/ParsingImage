//
//  ViewModel.swift
//  Kanna_practice
//
//  Created by AlexandraTsai on 2021/6/5.
//

import Alamofire
import Foundation
import Kanna
import RxCocoa
import RxSwift

protocol ViewModelInput {
    func fetchData()
}

protocol ViewModelOutput {
    var images: BehaviorRelay<[UIImage]> { get }
}

typealias ViewModelPrototype = ViewModelInput & ViewModelOutput

class ViewModel: ViewModelPrototype {
    // MARK: ViewModelOutput
    let images = BehaviorRelay<[UIImage]>(value: [])

    // MARK: ViewModelInput
    func fetchData() {
        AF.request("https://theslimlim.tumblr.com").responseString { response in
            guard let html = response.value else { return }
            self.parseHtml(html)
        }
    }

    func parseHtml(_ html: String) {
        guard let doc = try? Kanna.HTML(html: html, encoding: String.Encoding.utf8) else { return }

        let URLs = doc.xpath("//img").compactMap { node in
            node["src"]
        }
        fetchImages(with: URLs)
    }

    func fetchImages(with urls: [String]) {
        var images = [UIImage]()
        urls.forEach {
            guard let url = URL(string: $0),
                  let data = try? Data(contentsOf: url),
                  let img = UIImage(data: data) else { return }
            images.append(img)
        }
        self.images.accept(images)
    }
}

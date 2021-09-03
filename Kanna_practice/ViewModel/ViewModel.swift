//
//  ViewModel.swift
//  Kanna_practice
//
//  Created by AlexandraTsai on 2021/6/5.
//

import Foundation
import Kanna
import RxCocoa
import RxSwift

protocol ViewModelInput {
    func fetchData()
}

protocol ViewModelOutput {
    var post: BehaviorRelay<Post?> { get }
}

typealias ViewModelPrototype = ViewModelInput & ViewModelOutput

class ViewModel: ViewModelPrototype {
    // MARK: ViewModelOutput
    let post = BehaviorRelay<Post?>(value: nil)

    // MARK: ViewModelInput
    func fetchData() {
        Parser.fetchHtmlData(from: "https://theslimlim.tumblr.com")
            .done { html in
                self.parseHtml(html)
            }
            .catch { error in
                print(error)
            }
    }
}

private extension ViewModel {
    func parseHtml(_ html: String) {
        guard let doc = try? Kanna.HTML(html: html, encoding: String.Encoding.utf8) else { return }

        // Profile
        let profilURL = doc.xpath("//img[@class='acme-profile']").first?["src"]
        // Post
        let URLs = doc.xpath("//a[@class='acme-lightbox-activate']")
            .flatMap { node in
                node.xpath("//img").compactMap { node in
                    node["src"]
                }
            }

        let post = Post(posts: ImageHelper.fetchImages(with: URLs),
                        authorProfile: profilURL == nil ? nil : ImageHelper.fetchImage(with: profilURL!),
                        authorName: doc.xpath("//h1[@class='acme-heading -text']").first?.text ?? "",
                        authorEmail: doc.xpath("//p[@class='acme-subheading']").first?.text ?? "")
        self.post.accept(post)
    }
}

struct Post {
    let posts: [UIImage]
    var authorProfile: UIImage?
    let authorName: String
    let authorEmail: String
}

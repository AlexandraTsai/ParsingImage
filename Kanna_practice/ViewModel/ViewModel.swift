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
    var posts: BehaviorRelay<[UIImage]> { get }
    var authorProfile: BehaviorRelay<UIImage?> { get }
    var authorName: BehaviorRelay<String?> { get }
    var authorEmail: BehaviorRelay<String?> { get }
}

typealias ViewModelPrototype = ViewModelInput & ViewModelOutput

class ViewModel: ViewModelPrototype {
    // MARK: ViewModelOutput
    let posts = BehaviorRelay<[UIImage]>(value: [])
    let authorProfile = BehaviorRelay<UIImage?>(value: nil)
    let authorName = BehaviorRelay<String?>(value: nil)
    let authorEmail = BehaviorRelay<String?>(value: nil)

    // MARK: ViewModelInput
    func fetchData() {
        AF.request("https://theslimlim.tumblr.com").responseString { response in
            guard let html = response.value else { return }
            self.parseHtml(html)
        }
    }

    func parseHtml(_ html: String) {
        guard let doc = try? Kanna.HTML(html: html, encoding: String.Encoding.utf8) else { return }

        // Profile
        if let profilURL = doc.xpath("//img[@class='acme-profile']").first?["src"] {
            fetchProfile(with: profilURL)
        }

        authorName.accept(doc.xpath("//h1[@class='acme-heading -text']").first?.text)
        authorEmail.accept(doc.xpath("//p[@class='acme-subheading']").first?.text)
        // Post
        let URLs = doc.xpath("//a[@class='acme-lightbox-activate']")
            .flatMap { node in
                node.xpath("//img").compactMap { node in
                    node["src"]
                }
            }
        fetchPosts(with: URLs)
    }

    func fetchProfile(with url: String) {
        guard let url = URL(string: url),
              let data = try? Data(contentsOf: url),
              let img = UIImage(data: data) else { return }
        authorProfile.accept(img)
    }

    func fetchPosts(with urls: [String]) {
        var images = [UIImage]()
        urls.forEach {
            guard let url = URL(string: $0),
                  let data = try? Data(contentsOf: url),
                  let img = UIImage(data: data) else { return }
            images.append(img)
        }
        posts.accept(images)
    }
}

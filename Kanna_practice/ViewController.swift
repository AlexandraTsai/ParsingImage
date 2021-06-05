//
//  ViewController.swift
//  Kanna_practice
//
//  Created by AlexandraTsai on 2021/6/5.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.fetchData()
    }

    private let profileView = UIView()
    private let profileImage = UIImageView()
    private let authorName = UILabel()
    private let authorEmail = UILabel()
    private lazy var flowlayout: UICollectionViewFlowLayout = {
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.sectionInset = .zero
        flowlayout.minimumLineSpacing = 10
        flowlayout.minimumInteritemSpacing = 10
        flowlayout.scrollDirection = .vertical
        let width = (UIScreen.main.bounds.size.width - 10)/2
        flowlayout.itemSize = CGSize(width: width, height: width)
        return flowlayout
    }()
    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowlayout)
        cv.backgroundColor = .clear
        return cv
    }()
    private let viewModel: ViewModelPrototype = ViewModel()
    private let disposeBag = DisposeBag()
}

private extension ViewController {
    func setupUI() {
        view.backgroundColor = .lightGray
        setupProfileView()
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(profileView.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }

        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.nameOfClass)
    }

    func setupProfileView() {
        view.addSubview(profileView)
        profileView.backgroundColor = .clear
        profileView.snp.makeConstraints {
            $0.top.equalTo(view.snp.topMargin)
            $0.left.right.equalToSuperview()
        }
        profileImage.layer.cornerRadius = 50
        profileImage.clipsToBounds = true
        [profileImage, authorName, authorEmail].forEach { profileView.addSubview($0) }
        profileImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(10)
            $0.width.height.equalTo(100)
        }
        authorName.snp.makeConstraints {
            $0.top.equalTo(profileImage.snp.bottom).offset(24)
            $0.left.right.equalToSuperview()
        }
        authorEmail.snp.makeConstraints {
            $0.top.equalTo(authorName.snp.bottom).offset(10)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().inset(10)
        }

        authorName.numberOfLines = 0
        authorName.textAlignment = .center
        authorName.font = .boldSystemFont(ofSize: 16)
        authorName.textColor = .black
        authorEmail.numberOfLines = 0
        authorEmail.textAlignment = .center
        authorEmail.font = .systemFont(ofSize: 14)
        authorEmail.textColor = .darkGray
    }

    func bindViewModel() {
        viewModel.posts
            .bind(to: collectionView.rx.items(
                    cellIdentifier: ImageCollectionViewCell.nameOfClass,
                    cellType: ImageCollectionViewCell.self)) { _, image, cell in
                cell.config(image: image)
            }.disposed(by: disposeBag)

        viewModel.authorProfile
            .bind(to: profileImage.rx.image)
            .disposed(by: disposeBag)

        viewModel.authorName.bind(to: authorName.rx.text).disposed(by: disposeBag)
        viewModel.authorEmail.bind(to: authorEmail.rx.text).disposed(by: disposeBag)
    }
}

extension NSObject {
    /// name of class
    class var nameOfClass: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
    /// name of class
    var nameOfClass: String {
        return NSStringFromClass(type(of: self)).components(separatedBy: ".").last!
    }
}

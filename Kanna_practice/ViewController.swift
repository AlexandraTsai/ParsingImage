//
//  ViewController.swift
//  Kanna_practice
//
//  Created by AlexandraTsai on 2021/6/5.
//

import RxCocoa
import RxSwift
import SnapKit
import SkeletonView
import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.fetchData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startSkeleton()
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
        cv.dataSource = self
        return cv
    }()
    private let viewModel: ViewModelPrototype = ViewModel()
    private let disposeBag = DisposeBag()
}

extension ViewController: SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        ImageCollectionViewCell.nameOfClass
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.posts.value.count
    }

    func collectionSkeletonView(_ skeletonView: UICollectionView, skeletonCellForItemAt indexPath: IndexPath) -> UICollectionViewCell? {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.nameOfClass, for: indexPath) as? ImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.isSkeletonable = true
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.nameOfClass, for: indexPath) as? ImageCollectionViewCell else {
            return UICollectionViewCell()
        }

        guard !viewModel.posts.value.isEmpty else { return cell }
        cell.config(image: viewModel.posts.value[indexPath.row])
        return cell
    }
}

// MARK: Setup UI
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
            $0.left.right.equalToSuperview().inset(70).priority(.medium)
            $0.height.equalTo(24)
        }
        authorEmail.snp.makeConstraints {
            $0.top.equalTo(authorName.snp.bottom).offset(10)
            $0.left.right.equalToSuperview().inset(50).priority(.medium)
            $0.bottom.equalToSuperview().inset(10)
            $0.height.equalTo(24)
        }

        authorName.numberOfLines = 1
        authorName.textAlignment = .center
        authorName.font = .boldSystemFont(ofSize: 16)
        authorName.textColor = .black
        authorEmail.numberOfLines = 1
        authorEmail.textAlignment = .center
        authorEmail.font = .systemFont(ofSize: 14)
        authorEmail.textColor = .darkGray
    }
}

// MARK: Skeleton
private extension ViewController {
    func startSkeleton() {
        [view, collectionView, profileView, profileImage, authorName, authorEmail].forEach {
            $0.isSkeletonable = true
        }
        [authorName, authorEmail].forEach {
            $0.linesCornerRadius = 5
        }
        // SkeletonView is recursive, so if you want show the skeleton in all skeletonable views,
        // you only need to call the show method in the main container view. For example, with UIViewControllers.
        view.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .clouds),
                                          animation: nil,
                                          transition: .crossDissolve(0.25))
    }
}

// MARK: Binding
private extension ViewController {
    func bindViewModel() {
        viewModel.posts
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.collectionView.stopSkeletonAnimation()
                self.collectionView.reloadData()
                self.view.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.3))
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

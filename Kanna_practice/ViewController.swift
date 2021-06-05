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

    private lazy var flowlayout: UICollectionViewFlowLayout = {
        let tabflowlayout = UICollectionViewFlowLayout()
        tabflowlayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tabflowlayout.minimumLineSpacing = 0
        tabflowlayout.scrollDirection = .vertical
        tabflowlayout.itemSize = CGSize(width: UIScreen.main.bounds.size.width/2, height: UIScreen.main.bounds.size.width/2)
        return tabflowlayout
    }()
    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowlayout)
        return cv
    }()
    private let viewModel: ViewModelPrototype = ViewModel()
    private let disposeBag = DisposeBag()
}

private extension ViewController {
    func setupUI() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.nameOfClass)
    }

    func bindViewModel() {
        viewModel.images
            .bind(to: collectionView.rx.items(
                    cellIdentifier: ImageCollectionViewCell.nameOfClass,
                    cellType: ImageCollectionViewCell.self)) { _, image, cell in
                cell.config(image: image)
            }.disposed(by: disposeBag)
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

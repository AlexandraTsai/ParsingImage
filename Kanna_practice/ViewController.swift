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
        bindViewModel()
        viewModel.fetchData()

        view.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(300)
        }


    }


    let imageView = UIImageView()
    private let viewModel: ViewModelPrototype = ViewModel()
    private let disposeBag = DisposeBag()
}

private extension ViewController {
    func bindViewModel() {
        viewModel.images
            .subscribe(onNext: { [weak self] images in
                if let img = images.first {
                    self?.imageView.image = img
                }
            }).disposed(by: disposeBag)
    }
}

//
//  MenusSectionView.swift
//  nri_hack
//
//  Created by HiromuTsuruta on 2019/10/19.
//  Copyright © 2019 HIromu. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

// MARK: - View

final class MenusSectionView: UICollectionReusableView {
    
    // MARK: Properties
    
    var isOnHandler: ((Bool) -> Void)?
    var callHandler: ((MenusRequest.QueryType?) -> Void)?
    
    // MARK: IBOutlets
    
    // TODO refactor。時間があればボタンタイプをenumで管理すること
    
    @IBOutlet private weak var firstButton: UIButton! {
        didSet {
            firstButton.rx.tap.asDriver().drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.feedback(of: .heavy).impactOccurred()
                self.callHandler?(.carbohydrate)
                
                self.firstButton.setTitleColor(.white, for:  UIControl.State())
                self.secondButton.setTitleColor(.mBlack, for:  UIControl.State())
                self.thirdButton.setTitleColor(.mBlack, for:  UIControl.State())
                
                self.firstButton.backgroundColor = .mWine
                self.secondButton.backgroundColor = .white
                self.thirdButton.backgroundColor = .white
            }).disposed(by: rx.disposeBag)
        }
    }
    @IBOutlet private weak var secondButton: UIButton! {
        didSet {
            secondButton.rx.tap.asDriver().drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.feedback(of: .heavy).impactOccurred()
                self.callHandler?(.price)

                self.firstButton.setTitleColor(.mBlack, for:  UIControl.State())
                self.secondButton.setTitleColor(.white, for:  UIControl.State())
                self.thirdButton.setTitleColor(.mBlack, for:  UIControl.State())
                
                self.firstButton.backgroundColor = .white
                self.secondButton.backgroundColor = .mWine
                self.thirdButton.backgroundColor = .white
            }).disposed(by: rx.disposeBag)
        }
    }
    @IBOutlet private weak var thirdButton: UIButton! {
        didSet {
            thirdButton.rx.tap.asDriver().drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.feedback(of: .heavy).impactOccurred()
                self.callHandler?(nil)

                self.firstButton.setTitleColor(.mBlack, for:  UIControl.State())
                self.secondButton.setTitleColor(.mBlack, for:  UIControl.State())
                self.thirdButton.setTitleColor(.white, for:  UIControl.State())
                
                self.firstButton.backgroundColor = .white
                self.secondButton.backgroundColor = .white
                self.thirdButton.backgroundColor = .mWine
            }).disposed(by: rx.disposeBag)
        }
    }
    @IBOutlet private weak var toggleSwitch: UISwitch! {
        didSet {
            toggleSwitch.rx
                .controlEvent(.valueChanged)
                .withLatestFrom(toggleSwitch.rx.value)
                .subscribe(onNext: { [weak self] value in
                    self?.isOnHandler?(value)
                })
                .disposed(by: rx.disposeBag)
        }
    }
    
    
    // MARK: Overrides
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
}

extension MenusSectionView {
    
    func configure(
        isOnHandler: @escaping (Bool) -> Void,
        callHandler: @escaping (MenusRequest.QueryType?) -> Void
    ) {
        self.isOnHandler = isOnHandler
        self.callHandler = callHandler
    }
}

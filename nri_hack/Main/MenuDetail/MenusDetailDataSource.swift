//
//  MenusDetailDataSource.swift
//  nri_hack
//
//  Created by HiromuTsuruta on 2019/10/20.
//  Copyright © 2019 HIromu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

// MARK: - DataSource

final class MenusDetailDataSource: NSObject {
    
    private let menu: MenusRecord
    var menusRelay: BehaviorRelay<[MenusRecord]> = BehaviorRelay(value: [])
    
    init(menu: MenusRecord) {
        self.menu = menu
    }
    
    func call() {
        let request = MessageRequest(shopId: menu.shopId.value,
                                     shopUrl: menu.photoUrl.value,
                                     shopName: menu.shopName.value)
        
        /// TODO 現状LINEは成功しても失敗してもerrorが返ってくる。
        
        _ = APICliant
            .observe(request)
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: { result in
                debugPrint("-----onSuccess-----", result)
            }, onError: { error in
                debugPrint("-----onError-----", error.localizedDescription)
            })
            .disposed(by: rx.disposeBag)
    }
    
    func call(queryType: MenusRequest.QueryType?) {
        let request = MenusRequest(queryType: queryType)
        
        _ = APICliant
            .observe(request)
            .subscribe(onSuccess: { [weak self] result in
                self?.menusRelay.accept(result.records.shuffled())
            }, onError: { [weak self] _ in
                self?.menusRelay.accept([])
            })
            .disposed(by: rx.disposeBag)
    }
    
    func show() {
        UIAlertController(title: "Invite it!", message: nil, preferredStyle: .alert)
            .addAction(title: "Done", style: .default)
            .show()
    }
}


// MARK: - UICollectionViewDataSource

extension MenusDetailDataSource: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menusRelay.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(with: MenusCell.self, for: indexPath)
        cell.configure(with: menusRelay.value[indexPath.row])
        cell.set(isHidden: true)
        cell.set(type: .carbohydrate)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableView(
                with: MenuDetailSectionView.self,
                for: indexPath,
                ofKind: kind
            )
            header.configure(menu: menu) { [weak self] in
                self?.call()
                self?.show()
            }
            return header
            
        case UICollectionView.elementKindSectionFooter:
            assertionFailure("assertionFailure: fail to load Header or Footer")
            return UICollectionReusableView()
            
        default:
            assertionFailure("assertionFailure: fail to load Header or Footer")
            return UICollectionReusableView()
        }
    }
}

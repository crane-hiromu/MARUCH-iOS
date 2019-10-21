//
//  MenusDataSource.swift
//  nri_hack
//
//  Created by HiromuTsuruta on 2019/10/19.
//  Copyright © 2019 HIromu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

// MARK: - DataSource

final class MenusDataSource: NSObject {
    
    // MARK Enums
    
    enum ViewType {
        case single, multiple
    }
    
    // MARK: Properties
    
    var viewType: ViewType = .single
    var queryType: MenusRequest.QueryType?
    var menusRelay: BehaviorRelay<[MenusRecord]> = BehaviorRelay(value: [])
    
    func call(queryType: MenusRequest.QueryType?) {
        self.queryType = queryType
        let request = MenusRequest(queryType: queryType)
        
        _ = APICliant
            .observe(request)
            .subscribe(onSuccess: { [weak self] result in
                let records = result.records
                
                if queryType == nil { // front calc
                    self?.menusRelay.accept(records.sorted(by: { $0.time < $1.time }))
                } else {
                    self?.menusRelay.accept(records)
                }
                
            }, onError: { [weak self] _ in
                self?.menusRelay.accept([])
            })
            .disposed(by: rx.disposeBag)
    }
}


// MARK: - UICollectionViewDataSource

extension MenusDataSource: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menusRelay.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(with: MenusCell.self, for: indexPath)
        cell.configure(with: menusRelay.value[indexPath.row])
        cell.set(isHidden: (viewType == .single))
        cell.set(type: queryType)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableView(
                with: MenusSectionView.self,
                for: indexPath,
                ofKind: kind
            )
            header.configure(isOnHandler: { [weak self] value in
                self?.viewType = value ? .multiple : .single 
                collectionView.reloadData()

            }, callHandler: { [weak self] type in
                self?.call(queryType: type)
                
            })
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

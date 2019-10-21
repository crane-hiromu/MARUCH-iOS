//
//  MenusViewController.swift
//  nri_hack
//
//  Created by HiromuTsuruta on 2019/10/19.
//  Copyright © 2019 HIromu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Hero

// MARK - Controller

final class MenusViewController: UIViewController {
    
    // MARK: Proeperties
    
    private var menusDataSource = MenusDataSource()
    
    private lazy var collecitonView: UICollectionView = {
        let flow = UICollectionViewFlowLayout()
        flow.sectionHeadersPinToVisibleBounds = true
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: flow)
        collection.delegate = self
        collection.dataSource = menusDataSource
        collection.registerFromNib(type: MenusSectionView.self, ofKind: .header)
        collection.registerFromNib(type: MenusCell.self)
        collection.showsVerticalScrollIndicator = false
        collection.backgroundColor = .mBlack
        // collection.bounces = false
        return collection
    }()
    
    private lazy var iconItem: UIBarButtonItem = {
        let icon = #imageLiteral(resourceName: "icon_white").resize(to: CGSize(width: 30, height: 30))?.withRenderingMode(.alwaysOriginal)
        let item = UIBarButtonItem(
            image: icon,
            landscapeImagePhone: nil,
            style: .plain,
            target: nil,
            action: nil
        )
        return item
    }()
    
    
    // MARK: Overrides
    
    override func loadView() {
        super.loadView()
        
        view = collecitonView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initilize()
    }
}


// MARK: - UICollectionViewDelegate

extension MenusViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = menusDataSource.menusRelay.value[indexPath.row]
        let vc = MenuDetailViewController(menu: model)
        
        let nvaVC = UINavigationController(rootViewController: vc)
        nvaVC.hero.isEnabled = true
        nvaVC.hero.modalAnimationType = .selectBy(presenting: .zoom, dismissing: .zoomOut)
        present(nvaVC, animated: true)
    }
}


// MARK: - UICollectionViewDelegateFlowLayout

extension MenusViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width: CGFloat = {
            switch menusDataSource.viewType {
            case .single: return view.frame.width
            case .multiple: return view.frame.width/2
            }
        }()
        return CGSize(width: width, height: view.frame.width/2)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        
        return .zero
    }
}


// MARK: - Private

private extension MenusViewController {
    
    func initilize() {
        menusDataSource.menusRelay.subscribe(onNext: { [weak self] _ in
            self?.collecitonView.reloadData()
        }).disposed(by: rx.disposeBag)
        menusDataSource.call(queryType: nil) // all data
        
        title = "MARUCHI"
        navigationController?.navigationBar.barTintColor = .mWine
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        navigationItem.leftBarButtonItem = iconItem
    }
}


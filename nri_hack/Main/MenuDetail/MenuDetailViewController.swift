//
//  MenuDetailViewController.swift
//  nri_hack
//
//  Created by HiromuTsuruta on 2019/10/20.
//  Copyright © 2019 HIromu. All rights reserved.
//

import UIKit

// MARK: - Controller

final class MenuDetailViewController: UIViewController {
    
    // MARK: Properties
    
    private let menu: MenusRecord
    private var menuDetailDataSource: MenusDetailDataSource
    
    private lazy var collecitonView: UICollectionView = {
        let flow = UICollectionViewFlowLayout()
        // flow.sectionHeadersPinToVisibleBounds = true
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: flow)
        collection.delegate = self
        collection.dataSource = menuDetailDataSource
        collection.registerFromNib(type: MenuDetailSectionView.self, ofKind: .header)
        collection.registerFromNib(type: MenusCell.self)
        collection.showsVerticalScrollIndicator = false
        collection.backgroundColor = .mBlack
        // collection.bounces = false
        return collection
    }()
    
    private lazy var backButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: nil)
        item.tintColor = .white
        item.rx.tap.asDriver().drive(onNext: { [weak self] () in
            self?.dismiss(animated: true)
        }).disposed(by: rx.disposeBag)
        return item
    }()
    
    
    // MARK: init
    
    init(menu: MenusRecord) {
        self.menu = menu
        self.menuDetailDataSource = MenusDetailDataSource(menu: menu)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("") }
    
    
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


// MARK: - UICollectionViewDelegateFlowLayout

extension MenuDetailViewController: UICollectionViewDelegateFlowLayout {
    
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
        
        return CGSize(width: view.frame.width, height: view.frame.width/2)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: collectionView.frame.width,
                      height: collectionView.frame.width + 160)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        
        return .zero
    }
}


// MARK: - UICollectionViewDelegate

extension MenuDetailViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = menuDetailDataSource.menusRelay.value[indexPath.row] // TODO get?
        let vc = MenuDetailViewController(menu: model)
        
        let nvaVC = UINavigationController(rootViewController: vc)
        nvaVC.hero.isEnabled = true
        nvaVC.hero.modalAnimationType = .selectBy(presenting: .zoom, dismissing: .zoomOut)
        present(nvaVC, animated: true)
    }
}


// MARK: - Private

private extension MenuDetailViewController {
    
    func initilize() {
        menuDetailDataSource.menusRelay.subscribe(onNext: { [weak self] _ in
            self?.collecitonView.reloadData() 
        }).disposed(by: rx.disposeBag)
        menuDetailDataSource.call(queryType: nil)
        
        title = "Menu"
        navigationController?.navigationBar.barTintColor = .mWine
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        navigationItem.rightBarButtonItem = backButtonItem
    }
}

//
//  MenuDetailSectionView.swift
//  nri_hack
//
//  Created by HiromuTsuruta on 2019/10/20.
//  Copyright © 2019 HIromu. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Nuke

// MARK: - View

final class MenuDetailSectionView: UICollectionReusableView {
    
    // MARK: Properties
    
    var inviteHandler: (() -> Void)?
    
    
    // MARK: IBOutlets
    
    @IBOutlet private weak var headerImage: UIImageView!
    @IBOutlet private weak var inviteButton: UIButton! {
        didSet {
            inviteButton.rx.tap.asDriver().drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.feedback(of: .heavy).impactOccurred()
                self.inviteHandler?()
                self.inviteButton.isEnabled = false
                self.inviteButton.setTitle("Invited", for: UIControl.State())
                self.inviteButton.setTitleColor(.lightGray, for:  UIControl.State())
                self.inviteButton.backgroundColor = .white
            }).disposed(by: rx.disposeBag)
        }
    }
    
    
    // MARK: Overrides
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        Nuke.cancelRequest(for: headerImage)
        headerImage.image = nil
    }
}


// MARK: - Internal

extension MenuDetailSectionView {
    
    func configure(menu: MenusRecord, handler: @escaping () -> Void) {
        self.inviteHandler = handler
        
        guard let url = URL(string: menu.photoUrl.value) else { return }
        
        let options = ImageLoadingOptions(placeholder: #imageLiteral(resourceName: "logo-place"), transition: .fadeIn(duration: 0.5))
        Nuke.loadImage(with: url, options: options, into: headerImage)
    }
}

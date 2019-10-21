//
//  MenusCell.swift
//  nri_hack
//
//  Created by HiromuTsuruta on 2019/10/19.
//  Copyright © 2019 HIromu. All rights reserved.
//

import UIKit
import Nuke

// MARK: - Cell

final class MenusCell: UICollectionViewCell {

    // MARK: Properties
    
    private lazy var gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.clear.cgColor,
            UIColor(white: 0, alpha: 0.5).cgColor
        ]
        gradient.frame = CGRect(
            x: 0,
            y: UIScreen.main.bounds.width/2,
            width: UIScreen.main.bounds.width,
            height: UIScreen.main.bounds.width/2
        )
        return gradient
    }()
    
    private var kcal: Int = 0
    
    // MAKR: IBOutlets
    
    @IBOutlet private weak var layerView: UIView!
    @IBOutlet private weak var sugarLabel: UILabel!
    @IBOutlet private weak var kcalLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var bigLabel: UILabel!
    @IBOutlet private weak var menuImageView: UIImageView!
    
    
    // MARK: Overrides
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        Nuke.cancelRequest(for: menuImageView)
        menuImageView.image = nil
        kcalLabel.text = nil
        sugarLabel.text = nil
        priceLabel.text = nil
        bigLabel.text = nil
        
        layerView.layer.sublayers?.forEach {
            guard let shapeLayer = $0 as? CAGradientLayer else { return }
            shapeLayer.removeFromSuperlayer()
        }
    }
}


// MARK: - Internal

extension MenusCell {
    
    func configure(with menu: MenusRecord) {
        kcal = menu.time
        kcalLabel.text = "\(menu.calorie.value)kcal"
        sugarLabel.text = "\(menu.carbohydrate.value).0g"
        priceLabel.text = "¥\(menu.price.value)"
        
        if let url = URL(string: menu.photoUrl.value)  {
            let options = ImageLoadingOptions(transition: .fadeIn(duration: 0.5))
            Nuke.loadImage(with: url, options: options, into: menuImageView)
            
        }

        gradientLayer.frame = CGRect(
            x: 0,
            y: layerView.frame.height/3*2,
            width: frame.size.width,
            height: layerView.frame.height/2
        )
        layerView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func set(isHidden: Bool) {
        sugarLabel.isHidden = isHidden
        priceLabel.isHidden = isHidden
        kcalLabel.isHidden = isHidden
        bigLabel.isHidden = !isHidden
    }
    
    func hiddenAll() {
        sugarLabel.isHidden = true
        priceLabel.isHidden = true
        kcalLabel.isHidden = true
        bigLabel.isHidden = true
    }
    
    func set(type: MenusRequest.QueryType?) {
        bigLabel.text = {
            switch type {
            case .carbohydrate?: return sugarLabel.text
            case .price?: return priceLabel.text
            default: return "\(kcal)min"
            }
        }()
    }
}

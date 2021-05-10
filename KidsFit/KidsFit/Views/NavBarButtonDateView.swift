//
//  NavBarButtonDateView.swift
//  KidsFit
//
//  Created by Steven Yang on 5/7/21.
//

import UIKit

class NavBarButtonDateView: UIView {
    let nibName = "NavBarButtonDateView"
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        imageView.isUserInteractionEnabled = false
        titleLabel.isUserInteractionEnabled = false

    }
    
    func loadViewFromNib() -> UIView? {
        isUserInteractionEnabled = true
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }

}

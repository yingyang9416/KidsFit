//
//  TextfieldWithTitle.swift
//  KidsFit
//
//  Created by Steven Yang on 5/8/21.
//

import UIKit

class TextfieldWithTitle: UIView {
    let nibName = "TextfieldWithTitle"
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var textField: UITextField!
    
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
        
        textField.borderStyle = .none
    }
    
    func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }

}

//
//  TextfieldWithTitle.swift
//  KidsFit
//
//  Created by Steven Yang on 5/8/21.
//

import UIKit

enum textviewType {
    case largeWhite
    case smallGray
}

enum textEntrySecurity: Int {
    case insecure
    case secure
}

class TextfieldWithTitle: UIView {
    let nibName = "TextfieldWithTitle"
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var textField: UITextField!
    @IBOutlet var bottomBorderView: UIView!
    @IBOutlet var eyeImageView: UIImageView!
    
    var type: textviewType = .smallGray {
        didSet {
            switch type {
            case .largeWhite:
                tintColor = .white
                titleLabel.textColor = .white
                titleLabel.font = UIFont.avenirBook(size: 14)
                textField.textColor = .white
                textField.font = UIFont.avenirHeavy(size: 20)
                bottomBorderView.backgroundColor = .white
            default:
                print("small gray")
            }
        }
    }
    
    var text: String? {
        get {
            textField.text
        }
        set {
            textField.text = newValue
        }
    }
    
    var title: String? {
        get {
            titleLabel.text
        }
        set {
            titleLabel.text = newValue
        }
    }
    
    var isPasswordView: Bool = false {
        didSet {
            eyeImageView.isHidden = !isPasswordView
            eyeImageView.tag = isPasswordView ? 1 : 0
            textField.isSecureTextEntry = eyeImageView.tag == 1
        }
    }
    
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
        self.backgroundColor = .clear
        textField.borderStyle = .none
        
        eyeImageView.isUserInteractionEnabled = true
        let gesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(eyeImageTapped))
        eyeImageView.addGestureRecognizer(gesture)
        bringSubviewToFront(eyeImageView)
        isPasswordView = false
    }
    
    func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    @objc func eyeImageTapped() {
        eyeImageView.tag = eyeImageView.tag == 0 ? 1 : 0
        eyeImageView.image = eyeImageView.tag == 0 ? UIImage.eye : UIImage.eyeClosed
        textField.isSecureTextEntry = eyeImageView.tag == 1
    }

}

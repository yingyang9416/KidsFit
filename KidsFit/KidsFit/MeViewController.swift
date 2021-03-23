//
//  MeViewController.swift
//  KidsFit
//
//  Created by Steven Yang on 2/7/21.
//

import UIKit

class MeViewController: UIViewController {
    @IBOutlet var testView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func test(_ sender: Any) {
        testView.setY(30)
    }
    
    
}

extension MeViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }
}

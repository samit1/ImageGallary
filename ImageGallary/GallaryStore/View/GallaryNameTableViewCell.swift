//
//  GallaryNameTableViewCell.swift
//  ImageGallary
//
//  Created by Sami Taha on 6/5/18.
//  Copyright © 2018 Sami Taha. All rights reserved.
//

import UIKit

protocol UserInputDelegate : class {
    func userUpdatedTextFieldValue(with resulting: String, sender : GallaryNameTableViewCell)
}

class GallaryNameTableViewCell: UITableViewCell {

    weak var delegate : UserInputDelegate?
    
    @IBOutlet weak var textField: UITextField! {didSet  {
            self.textField.delegate = self
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    /// Flag if cell is editable
    override var isEditing: Bool  {
        didSet {
            textField.isEnabled = isEditing
            
            if isEditing {
                textField.becomeFirstResponder()
            } else {
                textField.resignFirstResponder()
            }
        }
        
    }
}

extension GallaryNameTableViewCell : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            isEditing = false
            delegate?.userUpdatedTextFieldValue(with: text, sender: self )
            
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        isEditing  = false
        return true
    }
}

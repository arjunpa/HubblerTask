//
//  TypeTextCell.swift
//  HubblerTask
//
//  Created by Arjun P A on 24/11/16.
//  Copyright © 2016 Arjun P A. All rights reserved.
//

import UIKit

class TypeTextCell: TypeBaseCell {

    @IBOutlet weak var textField:UITextField!
    @IBOutlet weak var fieldLabel:UILabel!
    @IBOutlet weak var errorLabel:UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func configure(model: RawModel) {
        super.configure(model: model)
        self.fieldLabel.text = model.field_name.capitalized
      //  self.errorLabel.text = ""
    }

    override func prepareForReuse() {
        self.textField.text = ""
        self.fieldLabel.text = ""
        self.errorLabel.text = ""
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func setValidation(){
        
        super.setValidation()
        if let isValidation = self.model.validation{
            self.errorLabel.text = isValidation.message
        }
        else{
            self.errorLabel.text = ""
        }
        
    }
    
}

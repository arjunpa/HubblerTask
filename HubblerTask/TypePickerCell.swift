//
//  TypePickerCell.swift
//  HubblerTask
//
//  Created by Arjun P A on 26/11/16.
//  Copyright © 2016 Arjun P A. All rights reserved.
//

import UIKit

class TypePickerCell: TypeBaseCell {

    @IBOutlet weak var fieldLabel:UILabel!
    @IBOutlet weak var errorLabel:UILabel!
    @IBOutlet weak var btnText:UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
    
    override func configure(model: RawModel) {
        super.configure(model: model)
        self.fieldLabel.text = model.field_name.capitalized
    }
    
    
    
    
}

//
//  TypeMultiLineCell.swift
//  HubblerTask
//
//  Created by Arjun P A on 24/11/16.
//  Copyright © 2016 Arjun P A. All rights reserved.
//

import UIKit

class TypeMultiLineCell: TypeBaseCell {

    @IBOutlet weak var textView:UITextView!
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
        self.textView.text = ""
        self.fieldLabel.text = ""
        self.errorLabel.text = ""
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func preferredSizeFittingTargetSize(targetSize: CGSize) -> CGSize {
        
        var size = super.preferredSizeFittingTargetSize(targetSize: targetSize)
        size.height += 10
        return size
    }
    override func setValidation(){
        if let isValidation = self.model.validation{
            self.errorLabel.text = isValidation.message
        }
        else{
            self.errorLabel.text = ""
        }
    }
}

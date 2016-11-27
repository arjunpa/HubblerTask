//
//  TypeBaseCell.swift
//  HubblerTask
//
//  Created by Arjun P A on 24/11/16.
//  Copyright © 2016 Arjun P A. All rights reserved.
//

import UIKit

class TypeBaseCell: UITableViewCell {

    var model:RawModel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(model:RawModel){
        self.model = model
        let views = self.contentView.subviews
        for view in views{
            if let tf = view as? UITextField{
                if model.type == "number"{
                    tf.keyboardType = .numberPad
                }
                else {
                    tf.keyboardType = .default
                }
            }
            else if let tv = view as? UITextView{
                if model.type == "number"{
                    tv.keyboardType = .numberPad
                }
                else {
                    tv.keyboardType = .default
                }
            }
      }
        self.setValidation()
    }
    
    func setValidation(){
    
    }
    
    func preferredSizeFittingTargetSize(targetSize:CGSize) -> CGSize{
        
        var size = UILayoutFittingCompressedSize
        size.width = targetSize.width
        self.setNeedsUpdateConstraints()
        self.updateConstraintsIfNeeded()
        self.setNeedsLayout()
        self.layoutIfNeeded()
        let calculatedSize = self.contentView.systemLayoutSizeFitting(size, withHorizontalFittingPriority: 1000, verticalFittingPriority: 250)
        return calculatedSize
        
    }
    
}

//
//  PersonListCell.swift
//  HubblerTask
//
//  Created by Arjun P A on 26/11/16.
//  Copyright © 2016 Arjun P A. All rights reserved.
//

import UIKit

class PersonListCell: UITableViewCell {

    @IBOutlet weak var field1:UILabel!
    @IBOutlet weak var value1:UILabel!
    @IBOutlet weak var field2:UILabel!
    @IBOutlet weak var value2:UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(result:UserDetailFetchResult){
        
        let firstData = result.rawData.first
        field1.text = firstData?.field_name
        value1.text = firstData?.userText
        if firstData?.userText == ""{
            field1.text = ""
        }
        
        if result.rawData.count > 1{
            let secondData = result.rawData[1]
            value2.text = secondData.userText
            field2.text = secondData.field_name
            
            if secondData.userText == ""{
                field2.text = ""
            }
            
        }
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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

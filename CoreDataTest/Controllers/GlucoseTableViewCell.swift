//
//  GlucoseTableViewCell.swift
//  CoreDataTest
//
//  Created by Pedro Ésli Vieira do Nascimento on 14/10/21.
//

import UIKit

class GlucoseTableViewCell: UITableViewCell {
    
    static let identifier = "GlucoseCell"
    
    @IBOutlet weak var glucoseImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var glucoseLevelLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(glucose: Glucose){
        glucoseImageView.image = glucose.getUIImage()
        timeLabel.text = glucose.getFormatedTime()
        glucoseLevelLabel.text = "\(glucose.level)mg/dl"
    }

}

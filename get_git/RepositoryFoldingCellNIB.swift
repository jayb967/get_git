//
//  RepositoryFoldingCellNIB.swift
//  get_git
//
//  Created by Rio Balderas on 7/7/17.
//  Copyright © 2017 Jay Balderas. All rights reserved.
//

import UIKit
import FoldingCell
import FoldingCell.Swift

protocol MyFoldingCellDelegate {
    func didTapMoreDetail(_ sender: Any?)
}


class RepositoryFoldingCellNIB: FoldingCell {
    //foregroundView Labels
    @IBOutlet weak var repoNameLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
   
    var delegate: MyFoldingCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func animationDuration(_ itemIndex: NSInteger, type: FoldingCell.AnimationType) -> TimeInterval {
        // durations count equal it itemCount
        let durations = [0.2, 0.26, 0.2] // timing animation for each view
        return durations[itemIndex]
    }
}

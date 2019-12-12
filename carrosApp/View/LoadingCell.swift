//
//  LoadingCell.swift
//  carrosApp
//
//  Created by Victor Vieira Veiga on 11/12/19.
//  Copyright © 2019 Victor Veiga. All rights reserved.
//

import UIKit

class LoadingCell: UITableViewCell {

    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

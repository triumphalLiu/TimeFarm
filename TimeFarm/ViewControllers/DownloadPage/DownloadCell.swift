//
//  DownloadCell.swift
//  TimeFarm
//
//  Created by apple on 2017/12/20.
//  Copyright © 2017年 liu. All rights reserved.
//

import Foundation
import UIKit
class DownloadCell : UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var sizeLabel: UILabel!
    var downloading : Bool = false
}

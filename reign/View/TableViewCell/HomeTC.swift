//
//  HomeTC.swift
//  reign
//
//  Created by Beto Salcido on 04/10/20.
//  Copyright © 2020 BetoSalcido. All rights reserved.
//

import UIKit

class HomeTC: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configCell(data: Hit, labelManager: LabelManager, dateFormat: DateFormat) {
        if let title = data.title, title.count > 0 {
            titleLabel.text = title
        } else if let title = data.storyTitle?.value, title.count > 0 {
            titleLabel.text = title
        } else {
            titleLabel.text = "No disponible"
        }
        titleLabel.numberOfLines = labelManager.countLines(of: titleLabel, maxHeight: 50)
        
        authorLabel.text = data.author ?? ""
        
        var date: String = data.createdAt ?? ""
        date = date.fromUTCToLocalDate()
        
        createdAtLabel.text = dateFormat.getPublicationDate(date: date)
        
    }
}

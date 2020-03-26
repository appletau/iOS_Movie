//
//  MovieListCell.swift
//  HelloRxSwift
//
//  Created by ST_Ben.Huang 黃韋韜 on 2020/3/26.
//  Copyright © 2020 ST_Ben.Huang 黃韋韜. All rights reserved.
//

import UIKit
import Kingfisher

class MovieListCell: UITableViewCell {
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var publishDateLabel: UILabel!
    @IBOutlet weak var movieDurationLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        self.titleLabel.text = ""
        self.categoryLabel.text? = "類型："
        self.publishDateLabel.text? = "上映日期："
        self.movieDurationLabel.text? = "片長:"
    }
    
    func setup(model:MovieSubject){
        var movieSubject:Subject
        
        if let subject = model as? BoxSubject {
            movieSubject = subject.subject
        } else if let subject = model as? WeeklySubject {
            movieSubject = subject.subject
        } else if let subject = model as? Subject {
            movieSubject = subject
        } else {
            return
        }
        
        self.titleLabel.text = movieSubject.title
        for (i,type) in movieSubject.genres.enumerated() {
            if i == 0 {
                self.categoryLabel.text? += type
            } else {
                self.categoryLabel.text? += "/\(type)"
            }
        }
        
        self.publishDateLabel.text? += movieSubject.pubdates.first ?? ""
        self.movieImageView.kf.setImage(with: movieSubject.images["small"])
        self.movieDurationLabel.text? += movieSubject.durations.first ?? ""
    }
    
}

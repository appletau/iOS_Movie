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
    @IBOutlet weak var cornerView: UIView!
    @IBOutlet weak var shadowView: UIView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOpacity = 0.3
        shadowView.layer.shadowRadius = 10
        shadowView.layer.shadowOffset = .zero
        shadowView.backgroundColor = .none
        cornerView.layer.cornerRadius = 15
        cornerView.clipsToBounds = true
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
        
        self.publishDateLabel.text? += String(movieSubject.pubdates.first?.prefix(10) ?? "")
        self.movieImageView.kf.setImage(with: movieSubject.images["small"])
        self.movieDurationLabel.text? += movieSubject.durations.first ?? ""
    }
    
}

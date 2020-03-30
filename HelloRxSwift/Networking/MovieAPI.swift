//
//  MovieListAPI.swift
//  HelloRxSwift
//
//  Created by ST_Ben.Huang 黃韋韜 on 2020/3/25.
//  Copyright © 2020 ST_Ben.Huang 黃韋韜. All rights reserved.
//

import Foundation
import Moya

enum MovieListType:String, CaseIterable {
    case top250 = "Top250"
    case us_box = "北美票房榜"
    case weekly = "口碑榜"
    case new_movies = "新片榜"
    case in_theaters = "正在熱映"
    case coming_soon = "即將上映"
    
    init?<T:MovieList>(type:T.Type) {
         switch type {
         case is TopMovie.Type:
            self = .top250
         case is USBox.Type:
            self = .us_box
         case is WeeklyBox.Type:
            self = . weekly
         case is NewMovie.Type:
            self = .new_movies
         case is InTheaters.Type:
            self = .in_theaters
         case is ComingSoon.Type:
            self = .coming_soon
         default:
            return nil
        }
    }
    
    var urlPath:String {
        switch self {
        case .top250:
            return "top250"
        case .us_box:
            return "us_box"
        case .weekly:
            return "weekly"
        case .new_movies:
            return "new_movies"
        case .in_theaters:
            return "in_theaters"
        case .coming_soon:
            return "coming_soon"
        }
    }
}

protocol MovieListApiTargetType:ApiTargetType {}

extension MovieListApiTargetType{}

enum Movie {
    
    struct GetMovieList<T:MovieList>: MovieListApiTargetType {
        typealias ResponseDataType = T
        var path: String {return listType.urlPath}
        
        var task: Task { return .requestParameters(parameters: parameters, encoding: URLEncoding.default) }
        
        private var parameters:Dictionary<String,String>
        private var listType:MovieListType
        
        init(type:T.Type , parameters:Dictionary<String,String>) {
            guard let type = MovieListType(type:type) else {fatalError("Wrong Type of Movie List")}
            self.listType = type
            self.parameters = parameters
        }
    }
}

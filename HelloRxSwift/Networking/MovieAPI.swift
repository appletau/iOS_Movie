//
//  MovieListAPI.swift
//  HelloRxSwift
//
//  Created by ST_Ben.Huang 黃韋韜 on 2020/3/25.
//  Copyright © 2020 ST_Ben.Huang 黃韋韜. All rights reserved.
//

import Foundation
import Moya

protocol MovieListApiTargetType:ApiTargetType {}

extension MovieListApiTargetType{}

enum Movie {
    
    enum MovieListType:String {
        case top250,us_box,weekly,new_movies,in_theaters,coming_soon,null
        
        init<T>(type:T) {

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
                self = .null
            }
        }
    }
    
    struct GetMovieList<T:Codable>: MovieListApiTargetType {
        typealias ResponseDataType = T
        var path: String {return listType.rawValue}
        
        var task: Task { return .requestParameters(parameters: parameters, encoding: URLEncoding.default) }
        
        private var parameters:Dictionary<String,String>
        private var listType:MovieListType
        
        init(type:T.Type , parameters:Dictionary<String,String>) {
            self.parameters = parameters
            self.listType = MovieListType(type:type)
            
        }
    }
}

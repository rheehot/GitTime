//
//  SearchService.swift
//  GitTime
//
//  Created by Kanz on 09/08/2019.
//  Copyright © 2019 KanzDevelop. All rights reserved.
//

import RxSwift

protocol SearchServiceType {
    func searchUser(query: String, page: Int) -> Observable<([User], Bool)>
    func searchRepo(query: String, page: Int, language: String?) -> Observable<([Repository], Bool)>
}

class SearchService: SearchServiceType {
    
    fileprivate let networking: GitTimeProvider<GitHubAPI>
    
    init(networking: GitTimeProvider<GitHubAPI>) {
        self.networking = networking
    }
    
    func searchUser(query: String, page: Int) -> Observable<([User], Bool)> {
        return self.networking.request(.searchUser(query: query, page: page))
            .map(SearchResults<User>.self)
            .map { result -> ([User], Bool) in
                let canLoadMore = result.totalCount > page * 30
                return (result.items, canLoadMore)
            }
            .asObservable()
    }
    
    func searchRepo(query: String, page: Int, language: String?) -> Observable<([Repository], Bool)> {
        return self.networking.request(.searchRepo(query: query, page: page, language: language))
            .map(SearchResults<Repository>.self)
            .map { result -> ([Repository], Bool) in
                let canLoadMore = result.totalCount > page * 30
                return (result.items, canLoadMore)
        }
    }
}

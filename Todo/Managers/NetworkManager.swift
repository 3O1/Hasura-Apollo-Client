//
//  NetworkManager.swift
//  Todo
//
//  Created by James on 7/23/21.
//

import Foundation
import Apollo
import UIKit

final class NetworkManager {
    static let shared = NetworkManager()
    let graphEndpoint = "https://hasura.io/learn/graphql"
    let graphWSEndpoint = "wss://hasura.io/learn/graphql"
    var apolloClient : ApolloClient?
    
    func createApolloClient(accessToken: String) {
        
        self.apolloClient = {
            let cache = InMemoryNormalizedCache()
            let store = ApolloStore(cache: cache)
            
            let authPayloads = ["Authorization": "Bearer \(accessToken)"]
            let configuration = URLSessionConfiguration.default
            configuration.httpAdditionalHeaders = authPayloads
            
            let client = URLSessionClient()
            let provider = NetworkInterceptorProvider(store: store, client: client)
            let url = URL(string: "https://hasura.io/learn/graphql")!
                    
            let requestChainTransport = RequestChainNetworkTransport(interceptorProvider: provider, endpointURL: url, additionalHeaders: authPayloads)

            return ApolloClient(networkTransport: requestChainTransport,
                                store: store)
        }()
    }
    
}

struct NetworkInterceptorProvider: InterceptorProvider {
    
    private let store: ApolloStore
    private let client: URLSessionClient
    
    init(store: ApolloStore,
         client: URLSessionClient) {
        self.store = store
        self.client = client
    }
    
    func interceptors<Operation: GraphQLOperation>(for operation: Operation) -> [ApolloInterceptor] {
        return [
            MaxRetryInterceptor(),
            CacheReadInterceptor(store: self.store),
            NetworkFetchInterceptor(client: self.client),
            ResponseCodeInterceptor(),
            JSONResponseParsingInterceptor(cacheKeyForObject: self.store.cacheKeyForObject),
            AutomaticPersistedQueryInterceptor(),
            CacheWriteInterceptor(store: self.store)
        ]
    }
}

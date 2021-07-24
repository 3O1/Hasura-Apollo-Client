//
//  SessionManager.swift
//  Todo
//
//  Created by James on 7/23/21.
//

import UIKit
import Auth0
final class SessionManager {
    static let shared = SessionManager()
    private let authentication = Auth0.authentication()
    let credentialsManager: CredentialsManager!
    
    var profile: UserInfo?
    var credentials: Credentials?
    var patchMode: Bool = false
    var userName: String = "Username"
    
    private init () {
        self.credentialsManager = CredentialsManager(authentication: Auth0.authentication())
        _ = self.authentication.logging(enabled: true)
    }
    
    func retrieveProfile(_ callback: @escaping (Error?) -> ()) {
        guard let accessToken = self.credentials?.accessToken
            else { return callback(CredentialsManagerError.noCredentials) }
        self.authentication
            .userInfo(withAccessToken: accessToken)
            .start { result in
                switch(result) {
                case .success(let profile):
                    self.profile = profile
                    self.userName = profile.nickname!
                    callback(nil)
                case .failure(let error):
                    callback(error)
                }
        }
    }
    
    func renewAuth(_ callback: @escaping (Error?) -> ()) {
        guard self.credentialsManager.hasValid() else {
            return callback(CredentialsManagerError.noCredentials)
        }
        self.credentialsManager.credentials { error, credentials in
            guard error == nil, let credentials = credentials else {
                return callback(error)
            }
            self.credentials = credentials
            callback(nil)
        }
    }
    
    func store(credentials: Credentials) -> Bool {
        self.credentials = credentials
        return self.credentialsManager.store(credentials: credentials)
    }

}

func plistValues(bundle: Bundle) -> (clientId: String, domain: String)? {
    guard
        let path = bundle.path(forResource: "Auth0", ofType: "plist"),
        let values = NSDictionary(contentsOfFile: path) as? [String: Any]
        else {
            print("Missing Auth0.plist file with 'ClientId' and 'Domain' entries in main bundle!")
            return nil
    }
    
    guard
        let clientId = values["ClientId"] as? String,
        let domain = values["Domain"] as? String
        else {
            print("Auth0.plist file at \(path) is missing 'ClientId' and/or 'Domain' entries!")
            print("File currently has the following entries: \(values)")
            return nil
    }
    return (clientId: clientId, domain: domain)
}

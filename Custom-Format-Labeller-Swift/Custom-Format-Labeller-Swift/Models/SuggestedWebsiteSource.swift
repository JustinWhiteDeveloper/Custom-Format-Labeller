//
//  SuggestedWebsiteSource.swift
//  Custom-Format-Labeller-Swift
//
//  Created by Justin White on 29/10/21.
//

import Foundation

protocol SuggestedWebsiteSource {
    func getWebsiteForFilename(label: String) -> String
}

class BillingualSuggestedWebsiteSource {
    
    enum Constants {
        static let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
        
        static let googleSearchPrefix = "https://www.google.com/search?q="
        
        static let imdbString = "imdb"

        static let amazonJpString = "amazon jp"
    }
    
    func getWebsiteForFilename(label: String) -> String {
        
        
        let containsEnglish = label.rangeOfCharacter(from: Constants.characterset) != nil

        if containsEnglish {
            let searchTerm = ("\(label) \(Constants.imdbString)"
                                .addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)) ?? ""
            return Constants.googleSearchPrefix + searchTerm

        } else {
            let searchTerm = ("\(label) \(Constants.amazonJpString)"
                                .addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)) ?? ""
            return Constants.googleSearchPrefix + searchTerm
        }
    }

}

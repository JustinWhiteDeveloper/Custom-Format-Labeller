//
//  SuggestedWebsiteSource.swift
//  Custom-Format-Labeller-Swift
//
//  Created by Justin White on 29/10/21.
//

import Foundation

protocol SuggestedWebsiteSource {
    func urlForFilename(label: String) -> String
    
    func googleSearchUrlForFilename(label: String) -> String
    
    func googleAmazonSearchUrlForFilename(label: String) -> String
}

class BillingualSuggestedWebsiteSource: SuggestedWebsiteSource {
    
    enum Constants {
        static let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
        
        static let googleSearchPrefix = "https://www.google.com/search?q="
        
        static let imdbSuffix = "imdb"

        static let amazonJpSuffix = "amazon jp"
    }
    
    func urlForFilename(label: String) -> String {
        
        
        let containsEnglish = label.rangeOfCharacter(from: Constants.characterset) != nil

        if containsEnglish {
            let searchTerm = ("\(label) \(Constants.imdbSuffix)"
                                .addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)) ?? ""
            return Constants.googleSearchPrefix + searchTerm

        } else {
            let searchTerm = ("\(label) \(Constants.amazonJpSuffix)"
                                .addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)) ?? ""
            return Constants.googleSearchPrefix + searchTerm
        }
    }
    
    func googleSearchUrlForFilename(label: String) -> String {
        let searchTerm = label.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        return Constants.googleSearchPrefix + searchTerm
    }
    
    func googleAmazonSearchUrlForFilename(label: String) -> String {
        
        let searchTerm = ("\(label) \(Constants.amazonJpSuffix)"
                            .addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)) ?? ""
        return Constants.googleSearchPrefix + searchTerm
    }
}

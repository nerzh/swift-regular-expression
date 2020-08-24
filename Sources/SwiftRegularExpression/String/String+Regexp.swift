//
//  String+Regexp.swift
//  
//
//  Created by Oleh Hudeichuk on 12.05.2020.
//

import Foundation

// MARK: REGEXP
extension String {

    /// regexp: "string"[#"^\w+$"#]
    /// => string
    public subscript(regexpPattern: String) -> String {
        get {
            var result = ""
            let range = NSRange(location: 0, length: self.utf16.count)
            let regex = try? NSRegularExpression(pattern: regexpPattern)
            if let range = regexpMatchAtNumber(regex?.firstMatch(in: self, options: [], range: range)) {
                result = String(self[range])
            }

            return result
        }
    }

    /// regexp: "string"[#"^\w+$"#]
    /// => true
    public subscript(regexpPattern: String) -> Bool {
        get {
            if let regex = try? NSRegularExpression(pattern: regexpPattern) {
                let range = NSRange(location: 0, length: self.utf16.count)
                return regex.firstMatch(in: self, options: [], range: range) != nil
            }
            return false
        }
    }

    /// regexp: "match".regexp(#"(ma)([\s\S]+)"#)
    /// => [0: "match", 1: "ma", 2:"tch"]
    public func regexp(_ regexpPattern: String, _ options: NSRegularExpression.Options = []) -> [Int:String] {
        var result = [Int:String]()
        let matches = self.matches(regexpPattern, options)

        var lastIndex = matches.count - 1
        while lastIndex >= 0 {
            let match = matches[lastIndex]
            for number in 0..<match.numberOfRanges {
                if let resultRange = regexpMatchAtNumber(match, number) {
                    result[number] = String(self[resultRange])
                }
            }
            lastIndex -= 1
        }

        return result
    }

    /// "111 Hello 111".replaceFirst(#"\d+"#, "!!!")
    /// => "!!! Hello 111"
    public func replaceFirst(_ regexpPattern: String,
                             _ value: String,
                             _ options: NSRegularExpression.Options = []
    ) -> String {
        var result = self
        result.replaceFirstSelf(regexpPattern, value, options)
        return result
    }

    /// "111 Hello 111".replaceFirstSelf(#"\d+"#, "!!!")
    /// Mutating "!!! Hello 111"
    public mutating func replaceFirstSelf(_ regexpPattern: String,
                                          _ value: String,
                                          _ options: NSRegularExpression.Options = []
    ) {
        let range = NSRange(location: 0, length: self.utf16.count)
        let regex = try! NSRegularExpression(pattern: regexpPattern, options: options)
        if let resultRange = regexpMatchAtNumber(regex.firstMatch(in: self, options: [], range: range)) {
            self.replaceSubrange(resultRange, with: value)
        }
    }

    /// "111 Hello 111".replaceFirst(#"\d+"#) { (value) -> String in  return value == "111" ? "???" : value }
    ///  => "??? Hello 111"
    public func replaceFirst(_ regexpPattern: String,
                             _ options: NSRegularExpression.Options = [],
                             _ handler: (String) -> String
    ) -> String {
        var result = self
        result.replaceFirstSelf(regexpPattern, options, handler)
        return result
    }

    /// "111 Hello 111".replaceFirstSelf(#"\d+"#) { (value) -> String in  return value == "111" ? "???" : value }
    /// Mutate to "??? Hello 111"
    public mutating func replaceFirstSelf(_ regexpPattern: String,
                                          _ options: NSRegularExpression.Options = [],
                                          _ handler: (String) -> String
    ) {
        let range = NSRange(location: 0, length: self.utf16.count)
        let regex = try! NSRegularExpression(pattern: regexpPattern, options: options)
        if let resultRange = regexpMatchAtNumber(regex.firstMatch(in: self, options: [], range: range)) {
            self.replaceSubrange(resultRange, with: handler(String(self[resultRange])))
        }
    }

    /// "111 Hello 111".replace(#"\d+"#, "!!!")
    /// =>  "!!! Hello !!!"
    public func replace(_ regexpPattern: String,
                        _ value: String,
                        _ options: NSRegularExpression.Options = []
    ) -> String {
        var result = self
        result.replaceSelf(regexpPattern, value, options)
        return result
    }

    /// "111 Hello 111".replaceSelf(#"\d+"#, "!!!")
    /// Mutate to  "!!! Hello !!!"
    public mutating func replaceSelf(_ regexpPattern: String,
                                     _ value: String,
                                     _ options: NSRegularExpression.Options = []
    ) {
        if let regex: NSRegularExpression = try? .init(pattern: regexpPattern, options: options) {
            self = regex.stringByReplacingMatches(in: self,
                                                  options: [],
                                                  range: NSMakeRange(0, self.count),
                                                  withTemplate: value)
        }
    }

    /// "111 Hello 222".replace(#"\d+"#) { (value) -> String in  return value == "222" ? "111" : value }
    /// =>  "111 Hello 111"
    public func replace(_ regexpPattern: String,
                        _ options: NSRegularExpression.Options = [],
                        _ handler: (String) -> String
    ) -> String {
        var result = self
        result.replaceSelf(regexpPattern, options, handler)
        return result
    }

    /// "111 Hello 222".replaceSelf(#"\d+"#) { (value) -> String in  return value == "222" ? "111" : value }
    /// Mutate to "111 Hello 111"
    public mutating func replaceSelf(_ regexpPattern: String,
                                     _ options: NSRegularExpression.Options = [],
                                     _ handler: (String) -> String
    ) {
        let arrayRanges: [[Range<String.Index>: String]] = self.matchesWithRange(regexpPattern)
        var orderRange: Int = arrayRanges.count - 1
        while orderRange >= 0 {
            for (range, text) in arrayRanges[orderRange] {
                let value: String = handler(text)
                self.replaceSubrange(range, with: value)
            }
            orderRange -= 1
        }
    }

    /// "23 34".matchesWithRange(#"\d+"#)
    /// => [Range<String.Index> : "23", Range<String.Index> : "34"]
    public func matchesWithRange(_ regexpPattern: String,
                                 _ options: NSRegularExpression.Options = []
    ) -> [Range<String.Index>: String] {
        var result = [Range<String.Index>: String]()
        iterateFoundRanges(regexpPattern, options) { (resultRange) in
            result[resultRange] = String(self[resultRange])
        }
        return result
    }

    /// "23 34".matchesWithRange(#"\d+"#)
    /// => [[Range<String.Index> : "23", Range<String.Index> : "34"]]
    public func matchesWithRange(_ regexpPattern: String,
                                 _ options: NSRegularExpression.Options = []
    ) -> [[Range<String.Index>: String]] {
        var result = Array<[Range<String.Index>: String]>()
        iterateFoundRanges(regexpPattern, options) { (resultRange) in
            result.append([resultRange: String(self[resultRange])])
        }
        return result
    }
}



// MARK: PRIVATE HELPERS
extension String {

    /// Helper for iterate REGEXP matches
    private func regexpMatchAtNumber(_ maybeMatch: NSTextCheckingResult?, _ number: Int = 0) -> Range<String.Index>? {
        guard let match = maybeMatch else { return nil }
        /// beru range v stroke po nomeru iz sovpadeniy => {2, 5}
        let rangeOfMatch: NSRange = match.range(at: number)
        /// ZAGLUSHKA - BRED!!! Esli vlozhennost ((\d)|(\d)) gluk rangeOfMatch mozhet bit tipa {3123123, 0}
        /// [BUG] If ((\d)|(\d)) then we can have the rangeOfMatch for example as this {3123123, 0}
        if rangeOfMatch.location > self.utf16.count { return nil }

        let startLocation: Int = rangeOfMatch.location
        let endLocation: Int = startLocation + rangeOfMatch.length

        return self.utf16.index(self.startIndex, offsetBy: startLocation) ..< self.utf16.index(self.startIndex, offsetBy: endLocation)
    }

    private func matches(_ regexpPattern: String,
                         _ regexpOptions: NSRegularExpression.Options = [],
                         _ matchOptions: NSRegularExpression.MatchingOptions = []
    ) -> [NSTextCheckingResult] {
        do {
            let regexp: NSRegularExpression = try .init(pattern: regexpPattern, options: regexpOptions)
            return regexp.matches(in: self, options: matchOptions, range: NSRange(location: 0, length: self.utf16.count))
//            return regexp.matches(in: self, options: matchOptions, range: NSRange(location: 0, length: self.count))
        } catch {
            return []
        }
    }

    private func iterateFoundRanges(_ regexpPattern: String,
                                    _ regexpOptions: NSRegularExpression.Options = [],
                                    _ matchOptions: NSRegularExpression.MatchingOptions = [],
                                    _ handler: (Range<String.Index>) -> Void
    ) {
        let matches: [NSTextCheckingResult] = self.matches(regexpPattern, regexpOptions, matchOptions)
        for match in matches {
            if let range = regexpMatchAtNumber(match) {
                handler(range)
            }
        }
    }
}

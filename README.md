# swift-regular-expression

## Swift REGEXP ( swift regular expression )

### Install

```ruby
pod 'SwiftRegularExpression'
```

or

```swift
// swift-tools-version:5.2
...

dependencies: [
    .package(name: "SwiftRegularExpression", url: "https://github.com/nerzh/swift-regular-expression.git", .upToNextMajor(from: "0.2.0"))
],
targets: [
    .target(
        name: "nameProject",
        dependencies: [
            .product(name: "SwiftRegularExpression", package: "SwiftRegularExpression")
        ]
    )
]

...
```

### Usage
```swift
import SwiftRegularExpression 
```
#### regexp: Find String matches
```swift
"hello world"[#"[^\s]+"#]
/// => String: "hello"
/// => String: "" if no matches
```
#### regexp: Return Bool
```swift
"hello world"[#"[^\s]+"#]
/// => Bool: true
```

#### regexp: Return Dictionary of numbered matches
```swift
"match".regexp(#"(ma)([\s\S]+)"#)
/// => Dictionary: [0: "match", 1: "ma", 2:"tch"]
```

#### regexp: Replace First match to value

```swift
"111 Hello 111".replaceFirst(#"\d+"#, "!!!") 
/// => String: "!!! Hello 111"
```

```swift
var str = "111 Hello 111"
str.replaceFirstSelf(#"\d+"#, "!!!")
/// Mutating "!!! Hello 111"
```

```swift
"111 Hello 111".replaceFirst(#"\d+"#) { (value) -> String in  
    return value == "111" ? "???" : value
}
///  => "??? Hello 111"
```

```swift
var str = "111 Hello 111"
str.replaceFirstSelf(#"\d+"#) { (value) -> String in  
    return value == "111" ? "???" : value
}
/// Mutate to "??? Hello 111"
```

#### regexp: Replace All match to values

```swift
"111 Hello 111".replace(#"\d+"#, "!!!")
/// =>  "!!! Hello !!!"
```

```swift
var str = "111 Hello 111"
str.replaceSelf(#"\d+"#, "!!!")
/// Mutate to  "!!! Hello !!!"
```

```swift
"111 Hello 222".replace(#"\d+"#) { (value) -> String in  
    return value == "222" ? "111" : value
}
/// =>  "111 Hello 111"
```

```swift
var str = "111 Hello 222"
str.replaceSelf(#"\d+"#) { (value) -> String in  return value == "222" ? "111" : value }
/// Mutate to "111 Hello 111"
```

#### regexp: Get All Match Ranges
```swift
"23 34".matchesWithRange(#"\d+"#)
/// => [Range<String.Index> : "23", Range<String.Index> : "34"]
```

```swift
"23 34".matchesWithRange(#"\d+"#)
/// => [[Range<String.Index> : "23", Range<String.Index> : "34"]]
```










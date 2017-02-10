# learnalist-ios
- I dont know what I am doing, when it comes to swift / iOS development or UI / UX design.

By default the server is set to "https://learnalist.net/api", changing this
allows you to run your own [server](https://github.com/freshteapot/learnalist-api).

# Setup
After the code has been cloned.

- open in xcode

```
cd learnalist-ios
open -axcode .
```

Back in the terminal, you need to download dependencies.

```
carthage update
```

# Working with carthage

Update single package format.

```
carthage build --platform iOS PACKAGE
```
An example, updating Signals
```
carthage build --platform iOS Signals
```

# Packages I am using
For more uptodate, checkout the Cartfile

- [SQLite.swift](https://github.com/stephencelis/SQLite.swift)
- [Alamofire](https://github.com/Alamofire/Alamofire)
- [SnapKit](https://github.com/SnapKit/SnapKit)
- [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)
- [Signals](https://github.com/artman/Signals/)
- Dollar (not yet)



# Notes and urls I find that are helping me understand, grow my knowledge.

- http://samwize.com/2016/06/08/complete-guide-to-implementing-wkwebview/

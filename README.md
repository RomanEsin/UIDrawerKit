# UIDrawerKit
## A framework that allows you to create a `Drawer` like in [Shortcuts](https://itunes.apple.com/us/app/shortcuts/id915249334?mt=8) app.
## Also UIDrawerKit allows you to present custom view controller in `UIDrawerView`

### How to use it:
  1. Create an object of `UIDrawerView`.
  Its as simple as creating a `UIView`, but even easier. 
  `var drawer = UIDrawerView()`
  
  2. Present drawer on your view.
  For now its only possible to do with view that is presented on view controller.
  Theres a special UIView extension for this.
  `view.addContainerSubview(drawer, to: yourViewController)`
  
  3. Present your view controller in drawer.
  `drawer.present(viewController)`
  
As you see its very simple to use.
Please, report all bugs by tagging me in Twitter  [@EsinRomanSwift](https://www.twitter.com/EsinRomanSwift)
And also leave a comment about what new features do you want to see

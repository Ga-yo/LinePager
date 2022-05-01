# LinePager
## Temporary Usage
Plan to expand to Cocoapod, SPM, and Carthage in the future
### Sample
<img src = "https://user-images.githubusercontent.com/49550838/166138690-3852ecdb-f9b1-4bcc-b98f-28d197a046f2.mov" width="220" height="440"> 

### Example
```swift
  class ViewController: PagerViewController {

    init() {
        super.init(title: ["프로필", "채팅", "동네생활"], //Title of the desired tab bar
                   viewControllers: [RedViewController(), BludViewController(), BlackViewController()], //Register the view controller to be assigned to each tab bar
                   height: 48) //height of tab bar
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

}
```

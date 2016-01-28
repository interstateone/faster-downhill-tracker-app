import UIKit

final class AppStyle {
    static func applyStyle() {
        UITabBar.appearance().tintColor = UIColor.vanBrownColor
        UITableViewCell.appearance().tintColor = UIColor.vanBrownColor
    }
}

extension UIColor {
    static var vanBrownColor: UIColor {
        return UIColor(red: 159.0/255.0, green: 124.0/255.0, blue: 94.0/255.0, alpha: 1.0)
    }
}
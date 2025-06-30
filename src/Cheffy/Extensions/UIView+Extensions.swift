
import Foundation
import UIKit
extension UIView {
    func applyShadow() {
        self.layer.masksToBounds = false
//        self.layer.shadowColor = HSColorConstants.Colors.shadowColor.cgColor
        self.layer.shadowOpacity = 1.0
        self.layer.shadowOffset = CGSize(width: 2, height: 3)
        self.layer.shadowRadius = 10
    }
    func applyShadow2() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = #colorLiteral(red: 0.722735703, green: 0.6931557059, blue: 0.7236583829, alpha: 1)
        self.layer.shadowOpacity = 0.4
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 2
    }
    func applyShadow3() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = #colorLiteral(red: 0.3999576569, green: 0.4000295997, blue: 0.3999481499, alpha: 1)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 1
    }
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        if #available(iOS 11.0, *) {
            clipsToBounds = true
            layer.masksToBounds = true
            layer.cornerRadius = radius
            layer.maskedCorners = CACornerMask(rawValue: corners.rawValue)
        } else {
            let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            layer.mask = mask
        }
    }
    func animShow() {
        let screenSize = UIScreen.main.bounds.size
        UIView.animate(withDuration: 2, delay: 0, options: [.curveEaseIn],
                               animations: {
                            self.frame = CGRect(x: 0, y: screenSize.height - self.frame.height, width: self.frame.width, height: self.frame.height)
                        self.layoutIfNeeded()
                       }, completion: nil)
        self.isHidden = false
    }
    func animHide() {
        let screenSize = UIScreen.main.bounds.size
        UIView.animate(withDuration: 2, delay: 0, options: [.curveLinear],
                              animations: {
                            self.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: self.frame.height)
                            self.isHidden = true
                       })
    }
    class func fromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)?[0] as? T ?? .init()
    }
    func addTopBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        border.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: borderWidth)
        addSubview(border)
    }
    func addBottomBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        border.frame = CGRect(x: 0, y: frame.size.height - borderWidth, width: frame.size.width, height: borderWidth)
        addSubview(border)
    }

    func addLeftBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.frame = CGRect(x: 0, y: 0, width: borderWidth, height: frame.size.height)
        border.autoresizingMask = [.flexibleHeight, .flexibleRightMargin]
        addSubview(border)
    }

    func addRightBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleHeight, .flexibleLeftMargin]
        border.frame = CGRect(x: frame.size.width - borderWidth, y: 0, width: borderWidth, height: frame.size.height)
        addSubview(border)
    }
    func layoutView() {
        let containerView = UIView()
        // set the shadow of the view's layer
        layer.backgroundColor = UIColor.clear.cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1.0)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 4.0

        // set the cornerRadius of the containerView's layer
        containerView.layer.cornerRadius = 1.0
//        containerView.roundCorners([.topLeft, .topRight], radius: <#T##CGFloat#>)
        containerView.layer.masksToBounds = true

        addSubview(containerView)

        //
        // add additional views to the containerView here
        //

        // add constraints
        containerView.translatesAutoresizingMaskIntoConstraints = false

        // pin the containerView to the edges to the view
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    func addShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        let backgroundCGColor = backgroundColor?.cgColor
        backgroundColor = nil
        layer.backgroundColor =  backgroundCGColor
    }
    func roundCornersWithShadow(_ corners: UIRectCorner, radius: CGFloat) {
        let contentView = UIView()
        contentView.roundCorners(corners, radius: radius)
        contentView.layer.masksToBounds = true

        self.applyShadow()

        contentView.frame = self.bounds
        contentView.autoresizingMask = [
            .flexibleWidth, .flexibleHeight
        ]
        self.addSubview(contentView)
    }
    func fixInView(_ container: UIView!) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.frame = container.frame
        container.addSubview(self)
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
     func fromNib(named: String? = nil) -> Self {
           let name = named ?? "\(Self.self)"
           guard
               let nib2 = Bundle.main.loadNibNamed(name, owner: nil, options: nil)
               else { fatalError("missing expected nib named: \(name)") }
           guard
               let view = nib2.first as? Self
               else { fatalError("view of type \(Self.self) not found in \(nib2)") }
           return view
       }
}
enum VerticalLocation: String {
    case bottom
    case topSide
}

extension UIView {
    func addShadow(location: VerticalLocation, color: UIColor = .black, opacity: Float = 0.5, radius: CGFloat = 5.0) {
        switch location {
        case .bottom:
             addShadow(offset: CGSize(width: 0, height: 10), color: color, opacity: opacity, radius: radius)
        case .topSide:
            addShadow(offset: CGSize(width: 0, height: -10), color: color, opacity: opacity, radius: radius)
        }
    }

    func addShadow(offset: CGSize, color: UIColor = .black, opacity: Float = 0.2, radius: CGFloat = 1.0) {
        self.layer.masksToBounds = false
//        self.layer.shadowColor = HSColorConstants.Colors.shadowColor.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
    }
}

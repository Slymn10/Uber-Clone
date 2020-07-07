//
//  Extensions.swift
//  Uber
//
//  Created by Süleyman Koçak on 9.05.2020.
//  Copyright © 2020 Suleyman Kocak. All rights reserved.
//

import MapKit
import UIKit

extension UIView {
   func anchor(
      top: NSLayoutYAxisAnchor? = nil,
      left: NSLayoutXAxisAnchor? = nil,
      bottom: NSLayoutYAxisAnchor? = nil,
      right: NSLayoutXAxisAnchor? = nil,
      paddingTop: CGFloat = 0,
      paddingLeft: CGFloat = 0,
      paddingBottom: CGFloat = 0,
      paddingRight: CGFloat = 0,
      width: CGFloat? = nil,
      height: CGFloat? = nil
   ) {

      translatesAutoresizingMaskIntoConstraints = false

      if let top = top {
         topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
      }

      if let left = left {
         leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
      }

      if let bottom = bottom {
         bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
      }

      if let right = right {
         rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
      }

      if let width = width {
         widthAnchor.constraint(equalToConstant: width).isActive = true
      }

      if let height = height {
         heightAnchor.constraint(equalToConstant: height).isActive = true
      }
   }

   func centerX(inView view: UIView) {
      translatesAutoresizingMaskIntoConstraints = false
      centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
   }

   func centerY(
      inView view: UIView, leftAnchor: NSLayoutXAxisAnchor? = nil,
      paddingLeft: CGFloat = 0, constant: CGFloat = 0
   ) {

      translatesAutoresizingMaskIntoConstraints = false
      centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant).isActive = true

      if let left = leftAnchor {
         anchor(left: left, paddingLeft: paddingLeft)
      }
   }

   func setDimensions(height: CGFloat, width: CGFloat) {
      translatesAutoresizingMaskIntoConstraints = false
      heightAnchor.constraint(equalToConstant: height).isActive = true
      widthAnchor.constraint(equalToConstant: width).isActive = true
   }

   func addShadow() {
      layer.shadowColor = UIColor.black.cgColor
      layer.shadowOpacity = 0.55
      layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
      layer.masksToBounds = false
   }


}
extension UIView {
   func inputContainerView(image: UIImage, textField: UITextField? = nil, segmentedControl: UISegmentedControl? = nil) -> UIView {
      let view = UIView()
      let iv = UIImageView()
      iv.image = image
      iv.alpha = 0.87
      view.addSubview(iv)
      iv.centerY(inView: view)
      iv.anchor(left: view.leftAnchor, paddingLeft: 8, width: 24, height: 24)
      if let textField = textField {
         view.addSubview(textField)
         textField.centerY(inView: view)
         textField.anchor(left: iv.rightAnchor, right: view.rightAnchor, paddingLeft: 8, paddingRight: 5)
      }
      if let sc = segmentedControl {
         view.addSubview(sc)
         sc.centerY(inView: view)
         sc.anchor(left: iv.rightAnchor, right: view.rightAnchor, paddingLeft: 8, paddingRight: 5)
      }
      let seperatorView = UIView()
      seperatorView.backgroundColor = .lightGray
      view.addSubview(seperatorView)
      seperatorView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 8, height: 0.75)
      return view
   }
}

extension UITextField {

   func textField(withPlaceholder placeholder: String, isSecureTextEntry: Bool = false, keyboardType: UIKeyboardType = .default) -> UITextField {
      let tf = UITextField()
      tf.borderStyle = .none
      tf.textColor = .white
      tf.font = UIFont.systemFont(ofSize: 16)
      tf.keyboardType = keyboardType
      tf.keyboardAppearance = .dark
      tf.isSecureTextEntry = isSecureTextEntry
      tf.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
      return tf
   }

}
extension UIColor {
   static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
      return UIColor.init(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1.0)
   }

   static let backgroundColor = UIColor.rgb(red: 25, green: 25, blue: 25)
   static let mainBlueTint = UIColor.rgb(red: 17, green: 154, blue: 237)
   static let outlineStrokeColor = UIColor.rgb(red: 234, green: 46, blue: 111)
   static let trackStrokeColor = UIColor.rgb(red: 56, green: 25, blue: 49)
   static let pulsatingFillColor = UIColor.rgb(red: 86, green: 30, blue: 63)
}

extension MKPlacemark {

   var address: String? {
      guard let subThoroughfare = subThoroughfare else { return nil }
      guard let thoroughfare = thoroughfare else { return nil }
      guard let locality = locality else { return nil }
      guard let adminArea = administrativeArea else { return nil }
      return "\(subThoroughfare) \(thoroughfare) \(locality), \(adminArea)"
   }
}

extension MKMapView {
   func zoomToFit(annotations: [MKAnnotation]) {
      var zoomRect = MKMapRect.null
      annotations.forEach { (annotation) in
         let annotationPoint = MKMapPoint(annotation.coordinate)
         let pointRect = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 0.01, height: 0.01)
         zoomRect = zoomRect.union(pointRect)
      }
      let insets = UIEdgeInsets(top: 75, left: 75, bottom: 200, right: 75)
      setVisibleMapRect(zoomRect, edgePadding: insets, animated: true)
   }
}

extension UIViewController {
   func shouldPresentLoadingView(_ present: Bool, message: String? = nil) {
      if present {
         let loadingView = UIView()
         loadingView.frame = self.view.frame
         loadingView.backgroundColor = .black
         loadingView.alpha = 0
         loadingView.tag = 1

         let indicator = UIActivityIndicatorView()
         indicator.style = .large
         indicator.center = view.center

         let label = UILabel()
         label.text = message
         label.font = UIFont.systemFont(ofSize: 20)
         label.textColor = .white
         label.textAlignment = .center
         label.alpha = 0.87

         view.addSubview(loadingView)
         loadingView.addSubview(indicator)
         loadingView.addSubview(label)

         label.centerX(inView: view)
         label.anchor(top: indicator.bottomAnchor, paddingTop: 32)

         indicator.startAnimating()

         UIView.animate(withDuration: 0.3) {
            loadingView.alpha = 0.7
         }
      } else {
         view.subviews.forEach { (subview) in
            if subview.tag == 1 {
               UIView.animate(
                  withDuration: 0.3,
                  animations: {
                     subview.alpha = 0
                  },
                  completion: { _ in
                     subview.removeFromSuperview()
                  })
            }
         }
      }
   }
}
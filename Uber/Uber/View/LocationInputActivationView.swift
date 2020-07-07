//
//  LocationInputActivationView.swift
//  Uber
//
//  Created by Süleyman Koçak on 10.05.2020.
//  Copyright © 2020 Suleyman Kocak. All rights reserved.
//

import UIKit

protocol LocationInputActivationViewDelegate: class {
   func presentLocationInputView()
}

class LocationInputActivationView: UIView {

   weak var delegate: LocationInputActivationViewDelegate?
   private let indicatorView: UIView = {
      let view = UIView()
      view.backgroundColor = .black
      view.layer.cornerRadius = 3
      view.clipsToBounds = true
      return view
   }()
   private let placeholderLabel: UILabel = {
      let label = UILabel()
      label.text = "Where to?"
      label.font = UIFont.systemFont(ofSize: 18)
      label.textColor = .darkGray
      return label
   }()

   override init(frame: CGRect) {
      super.init(frame: frame)
      backgroundColor = UIColor(white: 1, alpha: 0.8)
      layer.shadowColor = UIColor.black.cgColor
      layer.shadowRadius = 5
      layer.shadowOpacity = 0.6
      layer.shadowOffset = CGSize(width: 1, height: 1)
      layer.cornerRadius = 8
      layer.masksToBounds = false

      addSubview(indicatorView)
      indicatorView.centerY(inView: self)
      indicatorView.anchor(left: self.leftAnchor, paddingLeft: 16)
      indicatorView.setDimensions(height: 6, width: 6)
      addSubview(placeholderLabel)
      placeholderLabel.centerY(inView: self, leftAnchor: indicatorView.rightAnchor, paddingLeft: 20)

      let tap = UITapGestureRecognizer(target: self, action: #selector(presentLocationInputview))
      addGestureRecognizer(tap)
   }

   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }

   @objc func presentLocationInputview() {
      delegate?.presentLocationInputView()
   }

}

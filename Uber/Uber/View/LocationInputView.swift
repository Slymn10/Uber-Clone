//
//  LocationInputView.swift
//  Uber
//
//  Created by Süleyman Koçak on 12.05.2020.
//  Copyright © 2020 Suleyman Kocak. All rights reserved.
//

import UIKit

protocol LocationInputViewDelegate: class {
   func dismissLocationInputView()
   func executeSearh(query: String)
}

class LocationInputView: UIView {
   var user: User? {
      didSet{
         self.titleLabel.text = user?.fullname
      }
   }

   weak var delegate: LocationInputViewDelegate?
   private let backButton: UIButton = {
      let button = UIButton(type: .system)
      button.setImage(#imageLiteral(resourceName: "baseline_arrow_back_black_36dp-1").withRenderingMode(.alwaysOriginal), for: .normal)
      button.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)
      return button
   }()
   private let titleLabel: UILabel = {
      let label = UILabel()
      label.text = ""
      label.textColor = .secondaryLabel
      label.font = UIFont.systemFont(ofSize: 16)
      return label
   }()
   private let startIndicatorView: UIView = {
      let view = UIView()
      view.backgroundColor = .lightGray
      view.layer.cornerRadius = 3
      return view
   }()
   private let linkingIndicatorView: UIView = {
      let view = UIView()
      view.backgroundColor = .darkGray
      return view
   }()
   private let destinationIndicatorView: UIView = {
      let view = UIView()
      view.backgroundColor = .black
      view.layer.cornerRadius = 3
      return view
   }()
   private lazy var startingLocationTextField: UITextField = {
      let tf = UITextField()
      tf.attributedPlaceholder = NSAttributedString(string: "Current Location", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)])
      tf.backgroundColor = .tertiarySystemGroupedBackground
      let paddingView = UIView()
      paddingView.setDimensions(height: 30, width: 8)
      tf.leftView = paddingView
      tf.leftViewMode = .always
      tf.isEnabled = false
      return tf
   }()
   private lazy var destinationLocationTextField: UITextField = {
      let tf = UITextField()
      tf.delegate = self
      tf.attributedPlaceholder = NSAttributedString(string: "Enter a destination...", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.7), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)])
      tf.returnKeyType = .search
      let paddingView = UIView()
      paddingView.setDimensions(height: 30, width: 8)
      tf.leftView = paddingView
      tf.leftViewMode = .always
      tf.backgroundColor = .lightGray
      return tf
   }()

   override init(frame: CGRect) {
      super.init(frame: frame)

      addShadow()
      backgroundColor = UIColor(white: 1, alpha: 0.95)
      addSubview(backButton)
      backButton.anchor(top: safeAreaLayoutGuide.topAnchor, left: leftAnchor, paddingTop: 16, paddingLeft: 12, width: 24, height: 24)
      addSubview(titleLabel)
      titleLabel.centerY(inView: backButton)
      titleLabel.centerX(inView: self)

      addSubview(startingLocationTextField)
      startingLocationTextField.anchor(top: backButton.bottomAnchor, left: backButton.rightAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 5, paddingRight: 35, height: 30)
      addSubview(destinationLocationTextField)
      destinationLocationTextField.anchor(top: startingLocationTextField.bottomAnchor, left: backButton.rightAnchor, right: rightAnchor, paddingTop: 12, paddingLeft: 5, paddingRight: 35, height: 30)

      addSubview(startIndicatorView)
      startIndicatorView.centerY(inView: startingLocationTextField, leftAnchor: leftAnchor, paddingLeft: 20)
      startIndicatorView.setDimensions(height: 6, width: 6)
      addSubview(destinationIndicatorView)
      destinationIndicatorView.centerY(inView: destinationLocationTextField, leftAnchor: leftAnchor, paddingLeft: 20)
      destinationIndicatorView.setDimensions(height: 6, width: 6)
      addSubview(linkingIndicatorView)
      linkingIndicatorView.centerX(inView: startIndicatorView)
      linkingIndicatorView.anchor(top: startIndicatorView.bottomAnchor, bottom: destinationIndicatorView.topAnchor, paddingTop: 4, paddingBottom: 4, width: 1)
   }

   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }


   //MARK: - Selectors

   @objc func handleBackButton() {
      delegate?.dismissLocationInputView()
   }

}
//MARK: - UITextFieldDelegate
extension LocationInputView: UITextFieldDelegate {
   //for search button action on keyboard
   func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      guard let query = textField.text else { return false }
      delegate?.executeSearh(query: query)
      return true

   }


}

//
//  LoginVC.swift
//  Uber
//
//  Created by Süleyman Koçak on 9.05.2020.
//  Copyright © 2020 Suleyman Kocak. All rights reserved.
//

import UIKit
import Firebase
class LoginVC: UIViewController {

   //MARK: - Properties
   private let titleLabel: UILabel = {
      let label = UILabel()
      label.text = "UBER"
      label.font = UIFont(name: "Avenir-Light", size: 36)
      label.textColor = UIColor(white: 1, alpha: 0.8)
      return label
   }()
   private lazy var emailContainerView: UIView = {
    let view = UIView().inputContainerView(image: #imageLiteral(resourceName: "ic_mail_outline_white_2x"), textField: emailTextField)
    view.heightAnchor.constraint(equalToConstant: 50).isActive = true
    return view
   }()
   private lazy var passwordContainerView: UIView = {
      let view =  UIView().inputContainerView(image: #imageLiteral(resourceName: "ic_lock_outline_white_2x"), textField: passwordTextField)
    view.heightAnchor.constraint(equalToConstant: 50).isActive=true
    return view
   }()
   private let emailTextField: UITextField = {
      return UITextField().textField(withPlaceholder: "Email", keyboardType: .emailAddress)
   }()
   private let passwordTextField: UITextField = {
      return UITextField().textField(withPlaceholder: "Password", isSecureTextEntry: true)
   }()

   private let loginButton: AuthButton = {
      let button = AuthButton(type: .system)
      button.setTitle("Login", for: .normal)
      button.addTarget(self, action: #selector(hangleLogin), for: .touchUpInside)
      return button
   }()
   private let orLabel: UILabel = {
      let label = UILabel()
      label.font = UIFont.systemFont(ofSize: 16)
      label.textColor = UIColor(white: 1, alpha: 0.32)
      label.text = "or"
      label.textAlignment = .center
      return label
   }()


   private let dontHaveAccountButton: UIButton = {
      let button = UIButton(type: .system)
      let attributedTitle = NSMutableAttributedString(string: "Don't have an account?  ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.lightGray])

      attributedTitle.append(NSAttributedString(string: "Sign Up", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.systemPink]))

      button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)

      button.setAttributedTitle(attributedTitle, for: .normal)
      return button
   }()
   //MARK: - Lifecycle

   override func viewDidLoad() {
      super.viewDidLoad()
      configureUI()
   }
   //MARK: - Selectors

   @objc func handleShowSignUp() {
      navigationController?.pushViewController(SignupVC(), animated: true)
   }
   @objc func hangleLogin() {

    guard let email = emailTextField.text?.lowercased() else{return}
    guard let password = passwordTextField.text else{return}
    Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
        if error != nil {
            let animation = CABasicAnimation(keyPath: "position")
            animation.duration = 0.07
            animation.repeatCount = 4
            animation.autoreverses = true
            animation.fromValue = NSValue(cgPoint: CGPoint(x: self.loginButton.center.x - 10, y: self.loginButton.center.y))
            animation.toValue = NSValue(cgPoint: CGPoint(x: self.loginButton.center.x + 10, y: self.loginButton.center.y))
            self.loginButton.layer.add(animation, forKey: nil)
            print(error!.localizedDescription)
            return
        }
        self.navigationController?.pushViewController(HomeVC(), animated: true)
    }






   }

   //MARK: - Helpers
   func configureUI() {
      configureNavigationBar()
      view.backgroundColor = .backgroundColor

      view.addSubview(titleLabel)
      titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 0)
      titleLabel.centerX(inView: view)

      let stack = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView, loginButton, orLabel, dontHaveAccountButton])
      stack.distribution = .fillEqually
      stack.axis = .vertical
      stack.spacing = 24

      view.addSubview(stack)
      stack.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 40, paddingLeft: 16, paddingRight: 16)
   }

   func configureNavigationBar() {
      navigationController?.navigationBar.isHidden = true
      navigationController?.navigationBar.barStyle = .black
   }


}

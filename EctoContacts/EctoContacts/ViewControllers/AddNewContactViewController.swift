//
//  AddNewContactViewController.swift
//  EctoContacts
//
//  Created by Pavan Powani on 10/05/20.
//  Copyright © 2020 PavanPowani. All rights reserved.
//

import UIKit

class AddNewContactViewController: UIViewController {
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var contactImageView: UIImageView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    var gradient = CAGradientLayer()

    static func getController() -> AddNewContactViewController? {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        if let controller = storyBoard.instantiateViewController(withIdentifier: "AddNewContactViewController") as? AddNewContactViewController {
            return controller
        }
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        contactImageView.layer.cornerRadius = contactImageView.frame.size.height / 2
        contactImageView.layer.borderWidth = 4
        contactImageView.layer.borderColor = UIColor.white.cgColor
        setupNavBar()
        applyGradient()
        setupTextFields()
    }

    override func viewWillLayoutSubviews() {
        self.gradient.frame = self.headerView.bounds
    }

    func setupNavBar() {
        self.navigationController?.navigationBar.tintColor = Themes.primaryColour
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.done(_:)))
        self.navigationItem.setRightBarButton(doneButton, animated: false)
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancel(_:)))
        self.navigationItem.setLeftBarButton(cancelButton, animated: false)
    }

    func applyGradient() {
        let startingColour = UIColor.white
        let endingColour = Themes.primaryColour.withAlphaComponent(0.5)
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        gradient.colors = [startingColour.cgColor, endingColour.cgColor]
        headerView.layer.insertSublayer(self.gradient, at: 0)
        print(headerView.layer.sublayers)
    }

    func setupTextFields() {
        self.firstNameTextField.delegate = self
        self.lastNameTextField.delegate = self
        self.emailTextField.delegate = self
        self.phoneTextField.delegate = self
    }

    @objc func cancel(_ sender: Any) {
        //POST new contact here
        self.dismiss(animated: true)
    }

    @objc func done(_ sender: Any) {
        //POST new contact here
    }
}

extension AddNewContactViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

extension AddNewContactViewController {
    // MARK: - Keyboard Delegates
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}

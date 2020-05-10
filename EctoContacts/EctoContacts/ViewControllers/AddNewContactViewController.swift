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
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    var gradient = CAGradientLayer()
    var viewModel: AddNewContactViewModel!

    static func getController() -> AddNewContactViewController? {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        if let controller = storyBoard.instantiateViewController(withIdentifier: "AddNewContactViewController") as? AddNewContactViewController {
            controller.viewModel = AddNewContactViewModel(delegate: controller)
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
        hideLoader()
    }

    override func viewWillLayoutSubviews() {
        self.gradient.frame = self.headerView.bounds
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    func showLoader() {
        self.view.isUserInteractionEnabled = false
        loader.startAnimating()
        loader.isHidden = false
    }

    func hideLoader() {
        self.view.isUserInteractionEnabled = true
        loader.isHidden = true
        loader.stopAnimating()
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
    }

    func setupTextFields() {
        self.firstNameTextField.delegate = self
        self.lastNameTextField.delegate = self
        self.emailTextField.delegate = self
        self.phoneTextField.delegate = self
    }

    @objc func cancel(_ sender: Any) {
        self.dismiss(animated: true)
    }

    @objc func done(_ sender: Any) {
        self.view.endEditing(true)
        showLoader()
        var params = [String: String]()
        params["firstName"] = self.firstNameTextField.text
        params["lastName"] = self.lastNameTextField.text
        params["email"] = self.emailTextField.text
        params["phone"] = self.phoneTextField.text
        viewModel.addNewContact(with: params)
    }
}

extension AddNewContactViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

extension AddNewContactViewController: AddNewContactVCDelegate {
    func showError(with message: String) {
        let alert = UIAlertController(title: "Sorry!", message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .default) { (_) in
            self.dismiss(animated: true)
        }
        alert.addAction(okayAction)
        self.present(alert, animated: true)
    }

    func dismiss() {
        self.dismiss(animated: true)
        hideLoader()
    }
}

extension AddNewContactViewController {
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

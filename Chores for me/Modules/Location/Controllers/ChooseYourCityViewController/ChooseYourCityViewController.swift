//
//  ChooseYourCityViewController.swift
//  Chores for me
//
//  Created by Chores for me 2019 on 14/04/21.
//

import UIKit

class ChooseYourCityViewController: ServiceBaseViewController {

    // MARK: - Outlets

    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var radiousTextField: UITextField!
    @IBOutlet weak var nextButtonBottomCostraint: NSLayoutConstraint!

    // MARK: - Properties

    private var initialBotoomDistance: CGFloat = 0

    // MARK: - Lifecycle

    // Custom initializers go here

    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: self)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: self)
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

//        stepLabel.text = "1/6"
        locationTextField.delegate = self
        navigationItem.title = AppString.CHOOSE_YOUR_CITY
        subscribeToShowKeyboardNotifications()
        initialBotoomDistance = nextButtonBottomCostraint.constant
//        navigationController?.darkNavigationBar()
    }

    // MARK: - Layout

    // MARK: - User Interaction

    @IBAction func selctOnMapButtonAction(_ sender: Any) {
       // navigate(.chooseLocationOnMap)
    }

    @IBAction func nextButoonAction(_ sender: Any) {
        navigate(.chooseService)
    }

    // MARK: - Additional Helpers

    private func subscribeToShowKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_ :)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(_ :)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        if nextButtonBottomCostraint.constant != initialBotoomDistance {
            self.view.layoutIfNeeded() // call
            UIView.animate(withDuration: 1) { [weak self] in
                guard let self = self else { return }
                self.nextButtonBottomCostraint.constant = self.initialBotoomDistance
                self.view.layoutIfNeeded() // call
            }
        }
    }

    @objc private func keyboardWillChangeFrame(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let height = keyboardSize.height
            self.view.layoutIfNeeded() // call
            UIView.animate(withDuration: 1) { [weak self] in
                guard let self = self else { return }
                self.nextButtonBottomCostraint.constant = height
                self.view.layoutIfNeeded() // call
            }
        }
    }
}

// MARK: - UITextFieldDelegate

extension ChooseYourCityViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        switch textField {
        case locationTextField:
            radiousTextField.becomeFirstResponder()
        case radiousTextField: break
        // Implemet navigation action
        default:
            textField.resignFirstResponder()
        }

        return true
    }
}

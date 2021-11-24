//
//  BaseViewController.swift
//  Chores for me
//
//  Created by Chores for me 2021 on 14/04/21.
//

import UIKit
import Toast_Swift
import NVActivityIndicatorView

class BaseViewController: UIViewController {

    // MARK: - Outlets

    // MARK: - Properties

    override var navigationController: BaseNavigationController? {
        return super.navigationController as? BaseNavigationController
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: - Lifecycle

    // Custom initializers go here

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
    }


    // MARK: - Layout
    
    // MARK: - User Interaction

    // MARK: - Additional Helpers
    func showMessage(_ withMessage : String) {
        var style = ToastStyle()
        style.messageColor = .white
        style.cornerRadius = 5.0
        style.backgroundColor = .black
        style.messageFont = UIFont.boldSystemFont(ofSize: 18.0)
        self.view.clearToastQueue()
        self.view.makeToast(withMessage, duration: 2.0, position: .top, style: style)
    }

    func showActivity() {
        let activityData = ActivityData(size: CGSize(width: 30, height: 30), type: .circleStrokeSpin, color: .white, backgroundColor: UIColor(named: "AppColor"))
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
    }

    func hideActivity() {
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
    }

}

extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }

    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}


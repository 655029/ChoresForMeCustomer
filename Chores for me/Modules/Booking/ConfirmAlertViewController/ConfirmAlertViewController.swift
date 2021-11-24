//
//  ConfirmAlertViewController.swift
//  Chores for me
//
//  Created by Bright Roots 2019 on 20/07/21.
//

import UIKit

class ConfirmAlertViewController: UIViewController {


    var jobId: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()

    }

    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            navigationController?.setNavigationBarHidden(true, animated: animated)
        jobId = UserStoreSingleton.shared.jobId
        }

        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            navigationController?.setNavigationBarHidden(false, animated: animated)
        }

    lazy var blurredView: UIView = {
            // 1. create container view
            let containerView = UIView()
            // 2. create custom blur view
            let blurEffect = UIBlurEffect(style: .light)
            let customBlurEffectView = CustomVisualEffectView(effect: blurEffect, intensity: 0.2)
            customBlurEffectView.frame = self.view.bounds
            // 3. create semi-transparent black view
            let dimmedView = UIView()
        dimmedView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            dimmedView.frame = self.view.bounds

            // 4. add both as subviews
            containerView.addSubview(customBlurEffectView)
            containerView.addSubview(dimmedView)
            return containerView
        }()

    func setupView() {
            // 6. add blur view and send it to back
            view.addSubview(blurredView)
            view.sendSubviewToBack(blurredView)
        }

    
    @IBAction func cancelButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func confirmButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let secondVc = storyboard.instantiateViewController(withIdentifier: "CheckOutViewController") as! CheckOutViewController
        secondVc.jobid = jobId
        navigationController?.pushViewController(secondVc, animated: true)
    }

}

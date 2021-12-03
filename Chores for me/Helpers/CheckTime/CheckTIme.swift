//
//  CheckTIme.swift
//  Chores for me
//
//  Created by Bright Roots 2019 on 02/12/21.
//

import Foundation
import UIKit

class CheckTimeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

let button = UIButton()
let button2 = UIButton()
extension UIViewController {

    func CheckTimeFunc(){
        let componets = Calendar.current.dateComponents([.hour, .minute, .second], from: Date())
        let currentHour = componets.hour
        if currentHour! < 7 || currentHour! > 21 {
            print ("show popup")
            self.TimePopupAlert()
        } else {
            print ("do nothing")
            button.removeFromSuperview()
            button2.removeFromSuperview()
        }
    }
    @objc func TimePopupAlert(){
        let window = UIApplication.shared.windows.last!
        let alert = UIAlertController(title: "Chores for Me",
                                      message: "you use this app only 7am to 10pm",
                                      preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { [self] (action) -> Void in
            print("Ok button tapped")

            button.setTitle("you use this app only 7am to 10pm", for  : .normal)
            button.setTitleColor(UIColor.black, for: .normal)
            button.backgroundColor = .white

            button2.setTitle("Okay", for  : .normal)
            button2.setTitleColor(UIColor.systemBlue, for: .normal)
            button2.backgroundColor = .clear
            button2.addTarget(self, action: #selector(self.buttonAction), for: .touchUpInside)
            button2.tag = 1

            button.frame = CGRect(x: 0, y: 0, width: window.frame.size.width, height: window.frame.size.height)

            button2.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            button2.titleEdgeInsets.top = 60
            button2.center = self.view.center
            button.addSubview(button2)
            window.addSubview(button)

        })
        alert.addAction(ok)
      //  self.present(alert, animated: true, completion: nil)
        window.rootViewController?.present(alert, animated: true, completion: nil)

    }

    @objc func buttonAction(){
        let componets = Calendar.current.dateComponents([.hour, .minute, .second], from: Date())
        let currentHour = componets.hour
        if currentHour! < 7 || currentHour! > 21 {
            print ("show popup")
            button.removeFromSuperview()
            button2.removeFromSuperview()
            self.TimePopupAlert()
        } else {
            print ("do nothing")
            button.removeFromSuperview()
            button2.removeFromSuperview()
        }
    }

}

//
//  LoginViewController.swift
//  Chores for me
//
//  Created by Chores for me 2019 on 14/04/21.
//

import UIKit
import Designable
import Alamofire
import Toast_Swift
import NVActivityIndicatorView
import GoogleSignIn
import FBSDKLoginKit
import CoreLocation
import FirebaseAuth


class LoginViewController: BaseViewController {


    // MARK: - Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var googleLoginButton: DesignableButton!
    @IBOutlet weak var showAndHidePasswordButtoon: UIButton!
    @IBOutlet weak var facebookLoginButton: DesignableButton!


    // MARK: - Properties
    var iconClick: Bool = true
    let locationManager = CLLocationManager()
    var tokenForPresentedLogoutVc:[String: String?] = [:]
    var tokenFromSegue: String?


    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        navigationController?.navigationBar.tintColor = .white
//        facebookLoginButton.layer.borderWidth = 1.0
//        facebookLoginButton.layer.borderColor = UIColor.white.cgColor
//        facebookLoginButton.layer.cornerRadius = 5.0
        if let token = AccessToken.current,
                !token.isExpired {
                // User is logged in, do work such as go to next view controller.
            }
        applyDesigns()
        googleSignIn()
        facebookLoginButton.addTarget(self, action: #selector(didTappedFacebookButton(_:)), for: .touchUpInside)

    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.navigationController?.navigationBar.isHidden = true
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "myToken"), object: nil, userInfo: tokenForPresentedLogoutVc as [AnyHashable : Any])
        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    @objc func didTappedFacebookButton(_ sender: DesignableButton) {
        let loginManger = LoginManager()
        loginManger.logIn(permissions: ["public_profile"], from: self) { result, error in
            if let error = error {
                print("Encountered Erorr: \(error)")
            } else if let result = result, result.isCancelled {
                print("Cancelled")
            } else {
                print("Logged In")
            }
            
        }
        
    }


    // MARK: - Layout
    private func applyDesigns() {
        googleLoginButton.addSpaceBetweenImageAndTitle(spacing: 6.0)
        let imageView = UIImage(named: "square-with-round")?.withRenderingMode(.alwaysTemplate)
        showAndHidePasswordButtoon.setImage(imageView, for: .normal)
        let imageView2 = UIImage(named: "checkbox")?.withRenderingMode(.alwaysTemplate)
        showAndHidePasswordButtoon.setImage(imageView2, for: .selected)
        showAndHidePasswordButtoon.tintColor = .white
    }


    // MARK: - User Interaction
    @IBAction func loginButtonAction(_ sender: Any) {
       // logIn()
        if let email = emailTextField.text, let password = passwordTextField.text {
            if email == ""{
                openAlert(title: "Alert", message: "Please Enter valid Email Id", alertStyle: .alert, actionTitles: ["Okay"], actionsStyles: [.default], actions: [{ _ in
                    print("Okay")
                }])
            }
            else if !email.isValidEmail {
                openAlert(title: "Alert", message: "Please Enter valid Email Id", alertStyle: .alert, actionTitles: ["Okay"], actionsStyles: [.default], actions: [{ _ in
                    print("Okay")
                }])

            }

            else if password == "" {
                openAlert(title: "Alert", message: "Please Enter Password", alertStyle: .alert, actionTitles: ["Okay"], actionsStyles: [.default], actions: [{ _ in
                    print("Okay")
                }])
            }

//            else if password.isPasswordValid {
//                openAlert(title: "Alert", message: "Password is not valid", alertStyle: .alert, actionTitles: ["Okay"], actionsStyles: [.default], actions: [{ _ in
//                    print("Okay")
//                }])
//            }

            else {
                self.userLogin()

            }
        }
        

    }

    @IBAction func forgotPasswordButtonAction(_ sender: Any) {
        navigate(.forgotPassword)
    }

    @IBAction func registerButtonAction(_ sender: Any) {
//        let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
//       let vc =  storyboard.instantiateViewController(withIdentifier: "RegisterViewController")
//        navigationController?.pushViewController(vc, animated: true)
        navigate(.register)
    }

    @IBAction func showAndHideButtonAction(_ sender: Any) {
        if (iconClick ==  true) {
            passwordTextField.isSecureTextEntry = false
        }
        else {
            passwordTextField.isSecureTextEntry = true
        }
        iconClick = !iconClick
        showAndHidePasswordButtoon.isSelected.toggle()
        
    }

    @IBAction func googleLoginButton(_ sender: DesignableButton) {
        GIDSignIn.sharedInstance()?.signIn()


        
    }

//    @IBAction func facebookLoginButtonAction(_ sender: )


    // MARK: - Additional Helpers
    func googleSignIn() {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
    }
    
}



// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            break
        default:
            textField.resignFirstResponder()
        }

        return true
    }

    func userLogin() {
        self.showActivity()
        guard let gitUrl = URL(string:"http://3.18.59.239:3000/api/v1/login") else { return }
        print(gitUrl)
        let request = NSMutableURLRequest(url: gitUrl)
        let parameters = [
            "email" :emailTextField.text ?? "",
            "password": passwordTextField.text ?? "",
            "signupType":"0",
            "deviceID":UserStoreSingleton.shared.fcmToken ?? "",
            "deviceType":1,
        ] as [String : Any]
        let session = URLSession.shared
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])

        session.dataTask(with: request as URLRequest) { data, response, error in
            guard let data = data else { return }
            do {
                let gitData = try JSONDecoder().decode(LoginModel.self, from: data)
                print("response data:", gitData)
                DispatchQueue.main.async {
                    self.hideActivity()
                    let phoneNumber = gitData.data?.phone
                    let headersvalue = gitData.data?.token
                    let responseMessage = gitData.status
                    if responseMessage == 200 {
                        self.hideActivity()
                        self.tokenForPresentedLogoutVc = ["token": headersvalue]
                        UserStoreSingleton.shared.isLoggedIn = true
                        UserStoreSingleton.shared.Token = headersvalue
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "myToken"), object: nil, userInfo: self.tokenForPresentedLogoutVc as [AnyHashable : Any])
                        self.tokenFromSegue = headersvalue
                        LogoutViewController.tokenForPresentedLogout = headersvalue
                        UserStoreSingleton.shared.email = self.emailTextField.text
                        UserStoreSingleton.shared.phoneNumer = phoneNumber
                        UserStoreSingleton.shared.userToken = gitData.data?.token
                        self.callingGetUserProfile()
                        if CLLocationManager.locationServicesEnabled() {
                            RootRouter().loadMainHomeStructure()
                        }
                        else {
                            self.navigate(.allowLocation)
                        }
                    }
                    else{
                        self.showMessage(gitData.message ?? "")
                    }
                }
            } catch let err {
                print("Err", err)
                print("Not Logedin")
            }
        }.resume()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVc = segue.destination as! LogoutViewController
        LogoutViewController.tokenForPresentedLogout = tokenFromSegue
    }

    func CheckLocationPermision() -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                return false
            case .authorizedAlways, .authorizedWhenInUse:
                return true
            default:
                return false
            }
        } else {
            return false
        }
    }


    func callingGetUserProfile() {
        self.showActivity()
            var request = URLRequest(url: URL(string: "http://3.18.59.239:3000/api/v1/get-user-Profile")!,timeoutInterval: Double.infinity)
            request.addValue("\(UserStoreSingleton.shared.Token ?? "")", forHTTPHeaderField:"Authorization")
            request.httpMethod = "GET"
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                self.hideActivity()
                do {
                    let json =  try JSONDecoder().decode(SetUpProfile.self, from: data ?? Data())
                    debugPrint(json)
                    DispatchQueue.main.async {
                        UserStoreSingleton.shared.name = json.data?.first_name
                        UserStoreSingleton.shared.userID = json.data?.userId
                        UserStoreSingleton.shared.profileImage = json.data?.image
                    }
                } catch {
                    print(error)
                    self.hideActivity()
                }
            }
            task.resume()
        }


    func callingSocialSignInAPI() {
        self.showActivity()
        guard let gitUrl = URL(string:"http://3.18.59.239:3000/api/v1/social-signIn") else { return }
        print(gitUrl)
        let request = NSMutableURLRequest(url: gitUrl)
        let parameters = ["socialKey" : RegisterViewController.socailKey ?? "",
                          "signupType":"0"]
        let session = URLSession.shared
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])

        session.dataTask(with: request as URLRequest) { data, response, error in

            guard let data = data else { return }
            do {

                let gitData = try JSONDecoder().decode(SocailSignInModel.self, from: data)
                print("response data:", gitData)
                DispatchQueue.main.async {
                    self.hideActivity()
                    let phoneNumber = gitData.data?.phone
                    let headersvalue = gitData.data?.token

                    let responseMessage = gitData.status
                    if responseMessage == 200 {
                        UserStoreSingleton.shared.isLoggedIn = true
                        UserStoreSingleton.shared.Token = headersvalue
                        UserStoreSingleton.shared.email = self.emailTextField.text
                        UserStoreSingleton.shared.phoneNumer = phoneNumber
                        UserStoreSingleton.shared.userToken = gitData.data?.token
                        self.showMessage(gitData.message ?? "")
                        RootRouter().loadMainHomeStructure()
                    }
                    else{
                        self.showMessage(gitData.message ?? "")
                    }

                }
            } catch let err {
                print("Err", err)
                print("Not Logedin")
            }
        }.resume()

    }

}


extension LoginViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
//        let socialKey = GIDSignIn.sharedInstance()?.currentUser.userID
//        let gmailUserName = GIDSignIn.sharedInstance()?.currentUser.profile.name
//        let gmailUserEmail = GIDSignIn.sharedInstance()?.currentUser.profile.email
//        let gmailUserImageUrl = GIDSignIn.sharedInstance()?.currentUser.profile.imageURL(withDimension: 120)?.absoluteString
        self.callingSocialSignInAPI()
    }
    

}

extension LoginViewController: LoginButtonDelegate {
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        let token = result?.token?.tokenString

        let request = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["feilds": "email,name"], tokenString: token, version: nil, httpMethod: .get)
        request.start { (connection, result, error) in
                   print("\(String(describing: result))")

        }
    }

    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
    }


}

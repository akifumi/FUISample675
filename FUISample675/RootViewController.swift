//
//  RootViewController.swift
//  FUISample675
//
//  Created by akifumi.fukaya on 2019/05/09.
//  Copyright © 2019 Akifumi Fukaya. All rights reserved.
//

import UIKit
import FirebaseUI

class RootViewController: UIViewController {

    init() {
        super.init(nibName: nil, bundle: .main)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction private func onAuthButtonTap(_ sender: UIButton) {
        openAuthScene()
    }

    private func openAuthScene() {
        guard let authUI = FUIAuth.defaultAuthUI() else { return }
        authUI.providers = [
            FUIFacebookAuth(),
            FUIGoogleAuth()
        ]
        authUI.shouldAutoUpgradeAnonymousUsers = true
        authUI.delegate = self

        let authViewController = authUI.authViewController()
        present(authViewController, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension RootViewController: FUIAuthDelegate {

    public func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        if let error = error as NSError?,
            error.code == FUIAuthErrorCode.mergeConflict.rawValue {
            // Merge conflict error, discard the anonymous user and login as the existing
            // non-anonymous user.
            guard let credential = error.userInfo[FUIAuthCredentialKey] as? AuthCredential else {
                print("Error: Received merge conflict error without auth credential!")
                return
            }

            Auth.auth().signInAndRetrieveData(with: credential) { (dataResult, error) in
                if let error = error as NSError? {
                    print("Error: Failed to re-login: \(error)")
                    return
                }

                // Handle successful login
                print("Authorized!")
                if let user = authUI.auth?.currentUser {
                    print("user uid : \(user.uid), isAnonymous ? \(user.isAnonymous)")
                }
            }
        } else if let error = error {
            // Some non-merge conflict error happened.
            print("Error: Failed to log in: \(error)")
            return
        }

        // Handle successful login
        print("Authorized!")
        if let user = authUI.auth?.currentUser {
            print("user uid : \(user.uid), isAnonymous ? \(user.isAnonymous)")
        }
    }
}


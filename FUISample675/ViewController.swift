//
//  ViewController.swift
//  FUISample675
//
//  Created by akifumi.fukaya on 2019/05/09.
//  Copyright © 2019 Akifumi Fukaya. All rights reserved.
//

import UIKit
import FirebaseUI

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        let auth = Auth.auth()
        if let user = auth.currentUser {
            print("user uid : \(user.uid), isAnonymous ? \(user.isAnonymous)")
            openRootScene()
            return
        }

        auth.signInAnonymously() { [weak self] (authResult, error) in
            guard let self = self else { return }
            if let error = error {
                print("Error: \(error)")
                return
            }
            guard let user = authResult?.user else {
                print("Error: user not found")
                return
            }
            print("user uid : \(user.uid), isAnonymous ? \(user.isAnonymous)")

            self.openRootScene()
        }
    }

    private func openRootScene() {
    }
}

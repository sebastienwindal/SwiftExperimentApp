//
//  MainViewController.swift
//  SwiftExperimentApp
//
//  Created by Sebastien on 1/13/15.
//
//

import UIKit

class MainViewController: UIViewController {

    var loader: LoadingStateMachine;

    @IBOutlet weak var urlTextField: UITextField!

    @IBOutlet weak var statusLabel: UILabel!

    required init(coder aDecoder: NSCoder) {
        loader = LoadingStateMachine();

        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        loader.registerForStateChange { (state:LoadingStates) -> Void in
            self.statusLabel.text = "\(state)"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func loadAction(sender: AnyObject) {

        loader .startLoadingURL(url: urlTextField.text)
    }
}


//
//  AddChannelViewController.swift
//  Smack
//
//  Created by Tiago Santos on 16/12/17.
//  Copyright © 2017 Tiago Santos. All rights reserved.
//
//  TODO: addCloseWhenTappedGesture and closeWhenTapped functions are being repeated. Extract
//  them to a different class.

import UIKit

class AddChannelViewController: UIViewController {

    @IBOutlet weak var channelName: UITextField!
    @IBOutlet weak var channelDescription: UITextField!
    @IBOutlet weak var backgroundView: UIView!
    
    var socketService: SocketService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        socketService = SocketService()
        setupView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createChannelTapped(_ sender: Any) {
        guard let channelNameText = channelName.text, channelName.text != "" else { return }
        guard let channelDescriptionText = channelDescription.text, channelDescription.text != "" else { return }
        
        socketService.addChannel(channelName: channelNameText, channelDescription: channelDescriptionText) { (success) in
            if success {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil )
    }
    
    
    func setupView() {
        addCloseWhenTappedGesture()
        
        channelName.attributedPlaceholder = NSAttributedString(string: "name", attributes: [NSAttributedStringKey.foregroundColor: Smack_Purple_Place_Holder])
        channelDescription.attributedPlaceholder = NSAttributedString(string: "description", attributes: [NSAttributedStringKey.foregroundColor: Smack_Purple_Place_Holder])
    }
    
    func addCloseWhenTappedGesture() {
        let closeTouch = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.closeWhenTapped(_:)))
        backgroundView.addGestureRecognizer(closeTouch)
    }
    
    @objc func closeWhenTapped(_ recognizer: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
}

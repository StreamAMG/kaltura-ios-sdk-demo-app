//
//  FullScreenPlayerViewController.swift
//  StreamAMGTest
//
//  Created by Franco Driansetti on 20/09/2018.
//  Copyright © 2018 StreamAMG. All rights reserved.
//

import UIKit

class FullScreenPlayerViewController: UIViewController {
    
    // MARK: - Private properties
    private let mediaServer = "" /// Set here your media server URL
    private let mediaUiConfID = "" /// Set here your UIconfigID
    private let mediaPartnerID = ""  /// Set here your Partner ID
    private var player : KPViewController!
    private var containerView: UIView = UIView()
    
    // MARK: - Initialize/Livecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let config = KPPlayerConfig(server: mediaServer, uiConfID: mediaUiConfID, partnerId: mediaPartnerID)
        config!.entryId = "" /// Set here your Entry ID 
        
        /*
         Add here other config that you need
         */
        
        // If you're using default view with fullScreen button, you can remove it
        config?.addKey("fullScreenBtn.plugin", withValue: "false")
        
        player = KPViewController(configuration: config)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
        
        /* Setup player container in fullScreen mode */
        containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        player.view.frame = containerView.bounds
        self.player.loadPlayer(into: self)
        containerView.addSubview(player.view)
        self.view.addSubview(containerView)
        
        /* Add back button */
        let buttonBack = UIButton(frame: CGRect(x: 10, y: 45, width: 50, height: 50))
        buttonBack.setImage(UIImage(named: "ic_close_player"), for: .normal)
        buttonBack.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        self.view.addSubview(buttonBack)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        /* Deinit player */
        player.kPlayer.remove()
        player.removePlayer()
        player = nil
    }
    
    // MARK: - Action methods
    
    @objc func buttonAction(sender: UIButton!) {
        /* Add here your animation if need */
        self.dismiss(animated: true, completion: nil)
    }
}

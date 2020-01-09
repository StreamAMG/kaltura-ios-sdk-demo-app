//
//  ViewController.swift
//  StreamAMGTest
//
//  Created by Franco Driansetti on 16/03/2018.
//  Copyright © 2018 StreamAMG. All rights reserved.
//

import UIKit
import GoogleCast
import MediaPlayer

class ViewController: UIViewController {
    
    @IBOutlet weak var reply: UIButton!
    
    // MARK: - Private properties
    
    private let mediaServer = "" /// Set here your media server URL
    private let mediaUiConfID = "" /// Set here your UIconfigID
    private let mediaPartnerID = ""  /// Set here your Partner ID
    private var player : KPViewController!
    private var castProvider:GoogleCastProvider?
    private var containerView: UIView = UIView()
     private var isInFullScreen = false
    // MARK: - Initialize/Livecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCastButton()
        
        reply.isHidden = true
        
        /* Initialize player */
        let config = KPPlayerConfig(server: mediaServer, uiConfID: mediaUiConfID, partnerId: mediaPartnerID)
        config!.entryId = "" /// Set here your entryID 
        
        /* Setup ks if you need */
        //config?.ks = ""
        
        player = KPViewController(configuration: config)
        
        /* Setup player container */
        containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 200, width: self.view.bounds.width, height: self.view.bounds.width / 16 * 9)
        player.view.frame = containerView.bounds
        self.player.loadPlayer(into: self)
        containerView.addSubview(player.view)
        self.view.addSubview(containerView)
        player.delegate = self
        self.addChildViewController(player!)
        castProvider = GoogleCastProvider.init()
        castProvider?.delegate = self
        
    }
    override func willAnimateRotation(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        
        
        // Sending toggleFullScreen notification to the player SDK if cast device is not connected
        
        if UIDevice.current.orientation.isLandscape, player != nil, isInFullScreen == false {
            
            isInFullScreen = true
            player?.toggleFullscreen()
            self.tabBarController?.tabBar.isHidden = true
        } else if UIDevice.current.orientation.isPortrait, isInFullScreen == true, player != nil  {
            
            isInFullScreen = false
            self.player?.toggleFullscreen()
            self.tabBarController?.tabBar.isHidden = false
        }
        
        if UIDevice.current.orientation.isPortrait {
            
            
            
            self.containerView.layoutIfNeeded()
            self.player?.view.layoutIfNeeded()
            
        }
        
    }
    func setupCastButton() {
        
        
        // Set AirPlay button
        let airPlayBtn = MPVolumeView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        airPlayBtn.showsVolumeSlider = false
        airPlayBtn.showsRouteButton = true
        let buttonItem = UIBarButtonItem.init(customView: airPlayBtn)
        buttonItem.tintColor = UIColor.blue
        navigationItem.rightBarButtonItem = buttonItem
        
        // Set chrome-cast button
        let frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        let castButton:GCKUICastButton = GCKUICastButton(frame: frame)
        castButton.tintColor = UIColor.white
        let barbuttonItem = UIBarButtonItem(customView: castButton)
        barbuttonItem.tintColor = UIColor.blue
        self.navigationItem.rightBarButtonItems?.append(barbuttonItem)
        
        //        if #available(iOS 11.0, *) {
        //            let routePickerView = AVRoutePickerView(frame: .init(x: self.view.frame.maxX/2, y: self.view.frame.maxY/2, width: 40, height: 40))
        //            routePickerView.tintColor = .black
        //
        //            view.addSubview(routePickerView)
        //        } else {
        //            // Fallback on earlier versions
        //        }
    }
    
    // MARK: - Actions methods
    
    // Native play call
    @IBAction func playPressed(_ sender: Any) {
        player.kPlayer.play()
    }
    
    // Native pause call
    @IBAction func pausePressed(_ sender: Any) {
        player.kPlayer.pause()
    }
    
    // Native reply call
    @IBAction func replyButtonPressed(_ sender: Any) {
        player.kPlayer.play()
        reply.isHidden = true
    }
    
    // Native seek call
    @IBAction func seekPressed(_ sender: Any) {
        player.kPlayer.currentPlaybackTime = player.kPlayer.duration - 3
    }
    
    // Push the player in fullScreen
    // Instead of the button you can set a view with the thumbnail of the content
    @IBAction func playInFullScreen(_ sender: Any) {
        let vc = FullScreenPlayerViewController()
        
        /*
         Present push with your favourite animation
         */
        
        self.present(vc, animated: true, completion: nil)
    }
    
    // Change subtitle programatically - if the content has
    @IBAction func subtitlePressed(_ sender: Any) {
        player.kPlayer.selectTextTrack!("English")
    }
}

// MARK: KPlayerDelegate methods

extension ViewController: KPViewControllerDelegate  {
    
    func kPlayer(_ player: KPViewController!, playerFullScreenToggled isFullScreen: Bool) {
        print("fullScreen")
    }
    
    func kPlayer(_ player: KPViewController!, playerPlaybackStateDidChange state: KPMediaPlaybackState) {
        print(state)
        if state == KPMediaPlaybackState.ended {
            reply.isHidden = false
        } else if state == KPMediaPlaybackState.seekingBackward {
            player.kPlayer.play()
        }
    }
}

extension ViewController: KPCastProviderDelegate {
    
    func updateProgress(_ currentTime: TimeInterval) {
        
    }
    
    func ready(toPlay streamDuration: TimeInterval) {
        player?.castProvider = castProvider
    }
    
    func castPlayerState(_ state: String!) {
        
    }
    
    func startCasting() {
        player?.castProvider = castProvider
    }
    
    func stopCasting() {
    }
}

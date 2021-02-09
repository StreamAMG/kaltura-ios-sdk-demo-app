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

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var reply: UIButton!
    @IBOutlet weak var advertPicker: UIPickerView!
    
    // MARK: - Private properties
    
    private let mediaServer = "" /// Set here your media server URL
    private let mediaUiConfID = "" /// Set here your UIconfigID
    private let mediaPartnerID = ""  /// Set here your Partner ID
    private var player : KPViewController?
    private var castProvider:GoogleCastProvider?
    private var containerView: UIView = UIView()
     private var isInFullScreen = false
    
    private var adverts: [AdvertModel] = []
    // MARK: - Initialize/Livecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCastButton()
        
        reply.isHidden = true
        
        setUpAdverts()
        
        playMedia(advert: nil)
    }
    

    
    func playMedia(advert: String?) {
        
        if let playerInstance = player {
            playerInstance.kPlayer.pause()
            playerInstance.kPlayer.delegate = nil
            playerInstance.kPlayer.remove()
        }
        
        /* Initialize player */
        let config = KPPlayerConfig(server: mediaServer, uiConfID: mediaUiConfID, partnerId: mediaPartnerID)
        config!.entryId = "" /// Set here your entryID
        
        /* Setup ks if you need */
        //config?.ks = ""
        
        if let ad = advert {
            config?.addKey("doubleClick.plugin", withValue: "true")
            config?.addKey("doubleClick.leadWithFlash", withValue: "false")
            config?.addKey("doubleClick.adTagUrl", withValue: ad)
        } else {
            config?.addKey("doubleClick.plugin", withValue: "false")
            config?.addKey("doubleClick.leadWithFlash", withValue: "false")
            config?.addKey("doubleClick.adTagUrl", withValue: nil)
        }
        
        player = KPViewController(configuration: config)
        
        /* Setup player container */
        containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 200, width: self.view.bounds.width, height: self.view.bounds.width / 16 * 9)
        player?.view.frame = containerView.bounds
        self.player?.loadPlayer(into: self)
        containerView.addSubview(player!.view)
        self.view.addSubview(containerView)
        player?.delegate = self
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

    }
    
    func setUpAdverts(){
        adverts.append(AdvertModel(adID: 0, adName: "None", adURL: nil))
        adverts.append(AdvertModel(adID: 1, adName: "Single Inline Linear", adURL: "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&iu=/124319096/external/single_ad_samples&ciu_szs=300x250&impl=s&gdfp_req=1&env=vp&output=vast&unviewed_position_start=1&cust_params=deployment%3Ddevsite%26sample_ct%3Dlinear&correlator="))
        adverts.append(AdvertModel(adID: 2, adName: "Single Skippable Inline", adURL: "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&iu=/124319096/external/single_ad_samples&ciu_szs=300x250&impl=s&gdfp_req=1&env=vp&output=vast&unviewed_position_start=1&cust_params=deployment%3Ddevsite%26sample_ct%3Dskippablelinear&correlator="))
        adverts.append(AdvertModel(adID: 3, adName: "Single Redirect Linear", adURL: "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&iu=/124319096/external/single_ad_samples&ciu_szs=300x250&impl=s&gdfp_req=1&env=vp&output=vast&unviewed_position_start=1&cust_params=deployment%3Ddevsite%26sample_ct%3Dredirectlinear&correlator="))
        adverts.append(AdvertModel(adID: 4, adName: "VMAP Session Ad Rule Pre-roll", adURL: "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&iu=/124319096/external/ad_rule_samples&ciu_szs=300x250&ad_rule=1&impl=s&gdfp_req=1&env=vp&output=vmap&cust_params=sar%3Da0f2&unviewed_position_start=1&tfcd=0&npa=0&correlator="))
        adverts.append(AdvertModel(adID: 5, adName: "VMAP Pre-roll", adURL: "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&iu=/124319096/external/ad_rule_samples&ciu_szs=300x250&ad_rule=1&impl=s&gdfp_req=1&env=vp&output=vmap&unviewed_position_start=1&cust_params=deployment%3Ddevsite%26sample_ar%3Dpreonly&cmsid=496&vid=short_onecue&correlator="))
        adverts.append(AdvertModel(adID: 6, adName: "VMAP Pre-roll + Bumper", adURL: "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&iu=/124319096/external/ad_rule_samples&ciu_szs=300x250&ad_rule=1&impl=s&gdfp_req=1&env=vp&output=vmap&unviewed_position_start=1&cust_params=deployment%3Ddevsite%26sample_ar%3Dpreonlybumper&cmsid=496&vid=short_onecue&correlator="))
        adverts.append(AdvertModel(adID: 7, adName: "VMAP Post-roll", adURL: "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&iu=/124319096/external/ad_rule_samples&ciu_szs=300x250&ad_rule=1&impl=s&gdfp_req=1&env=vp&output=vmap&unviewed_position_start=1&cust_params=deployment%3Ddevsite%26sample_ar%3Dpostonly&cmsid=496&vid=short_onecue&correlator="))
        adverts.append(AdvertModel(adID: 8, adName: "VMAP Post-roll + Bumper", adURL: "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&iu=/124319096/external/ad_rule_samples&ciu_szs=300x250&ad_rule=1&impl=s&gdfp_req=1&env=vp&output=vmap&unviewed_position_start=1&cust_params=deployment%3Ddevsite%26sample_ar%3Dpostonlybumper&cmsid=496&vid=short_onecue&correlator="))
        adverts.append(AdvertModel(adID: 9, adName: "VMAP Pre-, Mid-, and Post-rolls, Single Ads", adURL: "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&iu=/124319096/external/ad_rule_samples&ciu_szs=300x250&ad_rule=1&impl=s&gdfp_req=1&env=vp&output=vmap&unviewed_position_start=1&cust_params=deployment%3Ddevsite%26sample_ar%3Dpremidpost&cmsid=496&vid=short_onecue&correlator="))
        adverts.append(AdvertModel(adID: 10, adName: "VMAP - Pre 1 ad, Mid 3 ads, Post 1 ad", adURL: "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&iu=/124319096/external/ad_rule_samples&ciu_szs=300x250&ad_rule=1&impl=s&gdfp_req=1&env=vp&output=vmap&unviewed_position_start=1&cust_params=deployment%3Ddevsite%26sample_ar%3Dpremidpostpod&cmsid=496&vid=short_onecue&correlator="))
        adverts.append(AdvertModel(adID: 11, adName: "VMAP - Optimised Pre 1 ad, Mid 3 ads, Post 1 ad", adURL: "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&iu=/124319096/external/ad_rule_samples&ciu_szs=300x250&ad_rule=1&impl=s&gdfp_req=1&env=vp&output=vmap&unviewed_position_start=1&cust_params=deployment%3Ddevsite%26sample_ar%3Dpremidpostoptimizedpod&cmsid=496&vid=short_onecue&correlator="))
        adverts.append(AdvertModel(adID: 12, adName: "VMAP - Bumpers Pre 1 ad, Mid 3 ads, Post 1 ad", adURL: "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&iu=/124319096/external/ad_rule_samples&ciu_szs=300x250&ad_rule=1&impl=s&gdfp_req=1&env=vp&output=vmap&unviewed_position_start=1&cust_params=deployment%3Ddevsite%26sample_ar%3Dpremidpostpodbumper&cmsid=496&vid=short_onecue&correlator="))
        adverts.append(AdvertModel(adID: 13, adName: "VMAP - Optimised Bumpers Pre 1 ad, Mid 3 ads, Post 1 ad", adURL: "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&iu=/124319096/external/ad_rule_samples&ciu_szs=300x250&ad_rule=1&impl=s&gdfp_req=1&env=vp&output=vmap&unviewed_position_start=1&cust_params=deployment%3Ddevsite%26sample_ar%3Dpremidpostoptimizedpodbumper&cmsid=496&vid=short_onecue&correlator="))
        adverts.append(AdvertModel(adID: 14, adName: "VMAP - Pre 1 ad, Mid 5 (10s), Post 1 ad", adURL: "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&iu=/124319096/external/ad_rule_samples&ciu_szs=300x250&ad_rule=1&impl=s&gdfp_req=1&env=vp&output=vmap&unviewed_position_start=1&cust_params=deployment%3Ddevsite%26sample_ar%3Dpremidpostlongpod&cmsid=496&vid=short_tencue&correlator="))
        adverts.append(AdvertModel(adID: 15, adName: "SIMID Survey Pre-roll", adURL: "https://pubads.g.doubleclick.net/gampad/ads?iu=/21775744923/external/simid&description_url=https%3A%2F%2Fdevelopers.google.com%2Finteractive-media-ads&tfcd=0&npa=0&sz=640x480&gdfp_req=1&output=vast&unviewed_position_start=1&env=vp&impl=s&correlator="))
    }
    
    
    
    // MARK: - Actions methods
    
    
    @IBAction func selectAdvert(_ sender: Any) {
        let ad = adverts[advertPicker.selectedRow(inComponent: 0)]
        playMedia(advert: ad.adURL)
    }
    
    // Native play call
    @IBAction func playPressed(_ sender: Any) {
        player?.kPlayer.play()
    }
    
    // Native pause call
    @IBAction func pausePressed(_ sender: Any) {
        player?.kPlayer.pause()
    }
    
    // Native reply call
    @IBAction func replyButtonPressed(_ sender: Any) {
        player?.kPlayer.play()
        reply.isHidden = true
    }
    
    // Native seek call
    @IBAction func seekPressed(_ sender: Any) {
        player?.kPlayer.currentPlaybackTime = player!.kPlayer.duration - 3
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
        player?.kPlayer.selectTextTrack!("English")
    }
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return adverts.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let ad = adverts[row]
        return "\(ad.adID) - \(ad.adName)"
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

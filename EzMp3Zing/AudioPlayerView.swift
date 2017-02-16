//
//  AudioPlayerView.swift
//  EzMp3Zing
//
//  Created by iOS Student on 2/14/17.
//  Copyright © 2017 tek4fun. All rights reserved.
//

import UIKit
import AVFoundation

class AudioPlayerView: UIViewController, AVAudioPlayerDelegate {
    var overlayView: UIView!
    var alertView: UIView!
    var animator: UIDynamicAnimator!
    var attachmentBehavior : UIAttachmentBehavior!
    var snapBehavior : UISnapBehavior!

    let audioPlayer = AudioPlayer.sharedInstance
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var sld_Volume: UISlider!
    @IBOutlet weak var sld_Duration: UISlider!
    @IBOutlet weak var lbl_TotalTime: UILabel!
    @IBOutlet weak var lbl_CurrentTime: UILabel!
    @IBOutlet weak var btn_Play: UIButton!
    var checkAddObserverAudio = false

    override func viewDidLoad() {
        super.viewDidLoad()
        btn_Play.isEnabled = false
        NotificationCenter.default.addObserver(self, selector: #selector(setupObserverAudio), name: NSNotification.Name(rawValue: "setupObserverAudio"), object: nil)
        createOverlay()
        createAlert()
    }

    func setupObserverAudio()
    {
        lbl_Title.text = audioPlayer.titleSong
        addThumbImgForButton()
        if (audioPlayer.playing && !checkAddObserverAudio)
        {
            btn_Play.isEnabled = true
            checkAddObserverAudio = true
            Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timeUpdate), userInfo: nil, repeats: true)
            NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: audioPlayer.player.currentItem)
        }
    }

    func playerItemDidReachEnd(_ notification: Notification){
        if audioPlayer.repeating {
            audioPlayer.player.seek(to: kCMTimeZero)
            audioPlayer.player.play()
        } else {
            btn_Play.setBackgroundImage(UIImage(named:"play.png"), for: .normal)
            audioPlayer.player.pause()
        }
    }

    func timeUpdate() {
        audioPlayer.duration = Float((audioPlayer.player.currentItem?.duration.value)!)/Float((audioPlayer.player.currentItem?.duration.timescale)!)
        audioPlayer.currentTime = Float(audioPlayer.player.currentTime().value)/Float(audioPlayer.player.currentTime().timescale)

        let m = Int(floor(audioPlayer.currentTime/60))
        let s = Int(round(audioPlayer.currentTime - Float(m)*60))
        if audioPlayer.duration > 0 {
            let mduration = Int(floor(audioPlayer.duration/60))
            let sdduration = Int(round(audioPlayer.duration - Float(mduration)*60))
            self.lbl_CurrentTime.text = String(format: "%02d", m) + ":" + String(format: "%02d", s)
            self.lbl_TotalTime.text = String(format: "%02d", mduration) + ":" + String(format: "%02d", sdduration)
            self.sld_Duration.value = Float(audioPlayer.currentTime/audioPlayer.duration)
            self.sld_Volume.value = audioPlayer.player.volume
        }
    }

    func addThumbImgForButton() {
        if(audioPlayer.playing == true) {
            btn_Play.setBackgroundImage(UIImage(named:"pause.png"), for: .normal)
        } else {
            btn_Play.setBackgroundImage(UIImage(named:"play.png"), for: .normal)
        }
    }

    //action
    @IBAction func Repeat(_ sender: UISwitch) {
        audioPlayer.Repeat(sender.isOn)
    }

    @IBAction func action_PlayPause(_ sender: AnyObject) {
        audioPlayer.action_PlayPause()
        addThumbImgForButton()
    }
    @IBAction func sld_Duration(_ sender: UISlider) {
        audioPlayer.sld_Duration(sender.value)
    }
    @IBAction func sld_Volume(_ sender: UISlider) {
        audioPlayer.sld_Volume(sender.value)
    }

    @IBAction func actionShowLyric(_ sender: AnyObject) {
        showAlert()
    }



    // alert

    func createOverlay() {

        overlayView = UIView(frame: view.bounds)
        overlayView.backgroundColor = UIColor.gray
        overlayView.alpha = 0.0
        view.addSubview(overlayView)
    }

    func createAlert() {

        let alertWidth: CGFloat = 375
        let alertHeight: CGFloat = 150
        let buttonWidth: CGFloat = 40
        let alertViewFrame: CGRect = CGRect(x: 0, y: 0, width: alertWidth, height: alertHeight)
        alertView = UIView(frame: alertViewFrame)
        alertView.backgroundColor = UIColor.white
        alertView.alpha = 0.0
        alertView.layer.cornerRadius = 10;
        alertView.layer.shadowColor = UIColor.black.cgColor;
        alertView.layer.shadowOffset = CGSize(width: 0, height: 5);
        alertView.layer.shadowOpacity = 0.3;
        alertView.layer.shadowRadius = 10.0;


        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "Dismiss.png"), for: UIControlState())
        button.backgroundColor = UIColor.clear
        button.frame = CGRect(x: alertWidth/2 - buttonWidth/2, y: -buttonWidth/2, width: buttonWidth, height: buttonWidth)

        button.addTarget(self, action: #selector(AudioPlayerView.dismissAlert), for: UIControlEvents.touchUpInside)

        let rectLabel = CGRect(x: 0, y: button.frame.origin.y + button.frame.height, width: alertWidth, height: alertHeight - buttonWidth/2)
        let label = UILabel(frame: rectLabel)
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = audioPlayer.lyric
        label.textAlignment = .center

        alertView.addSubview(label)
        alertView.addSubview(button)
        view.addSubview(alertView)
    }

    func showAlert() {
        if (alertView == nil) {
            createAlert()
        }
        // Animate in the overlay
        UIView.animate(withDuration: 0.4, animations: {
            self.overlayView.alpha = 1.0
        })

        // Animate the alert view using UIKit Dynamics.
        alertView.alpha = 1.0

    }

    func dismissAlert() {

        UIView.animate(withDuration: 0.4, animations: {
            self.overlayView.alpha = 0.0
            self.alertView.alpha = 0.0
            }, completion: {
                (value: Bool) in
                self.alertView.removeFromSuperview()
                self.alertView = nil
        })

    }
    
}

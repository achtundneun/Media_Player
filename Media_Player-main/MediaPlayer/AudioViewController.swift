//
//  AudioViewController.swift
//  MediaPlayer
//
//  Created by Cавва Никитин on 12.02.2022.
//

import UIKit
import AVFoundation

final class AudioViewController: UIViewController {
    
    //MARK: - Properties
    
    private var player: AVAudioPlayer!
    
    private var numberOfTrack: Int = 0
    
    private var playPauseButtonFlag: Bool = false {
        didSet{
            if playPauseButtonFlag == false {
                playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            } else {
                playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            }
            
        }
    }
    
    @IBOutlet private var trackImageView: UIImageView!
    @IBOutlet private var bandNameLabel: UILabel!
    @IBOutlet private var trackNameLabel: UILabel!
    @IBOutlet private var trackProgressView: UIProgressView!
    @IBOutlet private var playPauseButton: UIButton!
    @IBOutlet private var stopButton: UIButton!
    @IBOutlet private var backwardButton: UIButton!
    @IBOutlet private var forwardButton: UIButton!
    @IBOutlet private var backwardTenSecondsButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settings()
        
        trackImageView.layer.cornerRadius = 12
        
        makeCircleButtons(buttons: [playPauseButton, stopButton, backwardButton, forwardButton, backwardTenSecondsButton])
        
        playerSettings()
    }
    
    //MARK: - Settings
    
    private func playerSettings() {
        if let track = Storage.shared.tracks[numberOfTrack].url {
            do {
                player = try AVAudioPlayer(contentsOf: track)
                player.prepareToPlay()
            }
            catch {
                print(error)
            }
        }
        
    }
    
    private func settings() {
        trackImageView.image = Storage.shared.tracks[numberOfTrack].image
        bandNameLabel.text = Storage.shared.tracks[numberOfTrack].band
        trackNameLabel.text = Storage.shared.tracks[numberOfTrack].name
    }
    
    private func makeCircleButtons(buttons: [UIButton]) {
        for button in buttons {
            button.layer.cornerRadius = button.frame.height / 2
        }
    }
    
    //MARK: - Actions
    
    private func buttonAnimate(button: UIButton) {
        UIView.animate(withDuration: 0.3) {
            button.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        } completion: { (bool) in
            button.transform = .identity
        }
    }
    
    private func imageAndLabelsAnimate() {
        UIView.animate(withDuration: 0.3) {
            self.trackImageView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            self.bandNameLabel.alpha = 0
            self.trackNameLabel.alpha = 0
        } completion: { (bool) in
            self.settings()
            self.trackImageView.transform = .identity
            self.bandNameLabel.alpha = 1
            self.trackNameLabel.alpha = 1
        }

    }
    
    private func playNextTrack() {
        
        if numberOfTrack != Storage.shared.tracks.count - 1 {
            numberOfTrack += 1
        } else {
            numberOfTrack = 0
        }
        
        imageAndLabelsAnimate()
        playerSettings()
        
        if playPauseButtonFlag == true {
            player.play()
        }
        
    }
    
    @IBAction private func playPauseAction(_ sender: UIButton) {
        buttonAnimate(button: sender)

        let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] (timer) in
            guard let currentTime = self?.player.currentTime, let duration = self?.player.duration else {
                return
            }
            let currentTimeFloat = Float(currentTime / duration)
            self?.trackProgressView.setProgress(currentTimeFloat, animated: true)
            if self?.player.isPlaying == false && self?.playPauseButtonFlag == true {
                self?.playNextTrack()
            }
        })
        
        playPauseButtonFlag.toggle()
        
        if playPauseButtonFlag == true {
            player.play()
            timer.fire()
        } else {
            player.pause()
            timer.invalidate()
        }
    }
    
    @IBAction private func stopAction(_ sender: UIButton) {
        buttonAnimate(button: sender)
        
        if player.isPlaying {
            player.stop()
            playPauseButtonFlag.toggle()
            player.currentTime = 0
        } else {
            player.currentTime = 0
        }
    }
    
    @IBAction private func forwardAction(_ sender: UIButton) {
        buttonAnimate(button: sender)
        playNextTrack()
    }
    
    @IBAction private func backwardAction(_ sender: UIButton) {
        buttonAnimate(button: sender)
        
        if numberOfTrack != 0 {
            numberOfTrack -= 1
        } else {
            numberOfTrack = Storage.shared.tracks.count - 1
        }
        
        imageAndLabelsAnimate()
        playerSettings()
        
        if playPauseButtonFlag == true {
            player.play()
        }
    }
    
    @IBAction private func backwardTenSecondsAction(_ sender: UIButton) {
        buttonAnimate(button: sender)
        
        if player.currentTime >= 10 {
            player.currentTime -= 10
        } else {
            player.currentTime = 0
        }
    }
    

}

//
//  RecordingViewController.swift
//  MediaPlayer
//
//  Created by Егор Никитин on 26.02.2021.
//

import UIKit
import AVFoundation

final class RecordingViewController: UIViewController, AVAudioRecorderDelegate {
    
    private var audioRecorder: AVAudioRecorder!
    private var player: AVAudioPlayer!
    private var meterTimer: Timer!
    private var isAudioRecordingGranted: Bool!
    private var audioFilename: URL!
    
    private var playPauseButtonFlag: Bool = false {
        didSet{
            if playPauseButtonFlag == false {
                playStopButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            } else {
                playStopButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            }
            
        }
    }
    
    @IBOutlet private var recordImageView: UIImageView!
    @IBOutlet private var recordingTimeLabel: UILabel!
    @IBOutlet private var stopButton: UIButton!
    @IBOutlet private var recordButton: UIButton!
    @IBOutlet private var playStopButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playStopButton.isEnabled = false
        
        makeCircleButtons(buttons: [stopButton, recordButton, playStopButton])
        
        switch AVAudioSession.sharedInstance().recordPermission {
        case AVAudioSession.RecordPermission.granted:
            isAudioRecordingGranted = true
            break
        case AVAudioSession.RecordPermission.denied:
            isAudioRecordingGranted = false
            break
        case AVAudioSession.RecordPermission.undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.isAudioRecordingGranted = true
                    } else {
                        self.isAudioRecordingGranted = false
                    }
                }
            }
            break
        default:
            break
        }
        recordImageView.layer.cornerRadius = 12
        recordImageView.clipsToBounds = true
    }
    
    override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()

            audioRecorder = nil
        }
    
    private func playerSettings() {
        if let audio = audioFilename {
            do {
                player = try AVAudioPlayer(contentsOf: audio)
                player.prepareToPlay()
            }
            catch {
                print(error)
            }
        }
        
    }
    
    private func makeCircleButtons(buttons: [UIButton]) {
        for button in buttons {
            button.layer.cornerRadius = button.frame.height / 2
        }
    }
    
    private func buttonAnimate(button: UIButton) {
        UIView.animate(withDuration: 0.3) {
            button.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        } completion: { (bool) in
            button.transform = .identity
        }
    }
    
    //MARK:- Audio recorder buttons action.
        @IBAction private func audioRecorderAction(_ sender: UIButton) {
            
            buttonAnimate(button: sender)
            
            if isAudioRecordingGranted {

                //Create the session.
                let session = AVAudioSession.sharedInstance()

                do {
                    //Configure the session for recording and playback.
                    try session.setCategory(AVAudioSession.Category.playAndRecord, options: .defaultToSpeaker)
                    try session.setActive(true)
                    //Set up a high-quality recording session.
                    let settings = [
                        AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                        AVSampleRateKey: 44100,
                        AVNumberOfChannelsKey: 2,
                        AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
                    ]
                    //Create audio file name URL
                    audioFilename = getDocumentsDirectory().appendingPathComponent("audioRecording.m4a")
                    //Create the audio recording, and assign ourselves as the delegate
                    audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
                    audioRecorder.delegate = self
                    audioRecorder.isMeteringEnabled = true
                    audioRecorder.record()
                    meterTimer = Timer.scheduledTimer(timeInterval: 0.1, target:self, selector:#selector(self.updateAudioMeter(timer:)), userInfo:nil, repeats:true)
                }
                catch let error {
                    print("Error for start audio recording: \(error.localizedDescription)")
                }
            }
        }

        @IBAction private func stopAudioRecordingAction(_ sender: UIButton) {
            
            buttonAnimate(button: sender)
            
            finishAudioRecording(success: true)
            
            playerSettings()
            
            playStopButton.isEnabled = true
        }

        private func finishAudioRecording(success: Bool) {
            
            if audioRecorder != nil {
                audioRecorder.stop()
                audioRecorder = nil
                meterTimer.invalidate()
            } else {
                stopButton.isEnabled = false
            }
            
            if success {
                print("Recording finished successfully.")
            } else {
                print("Recording failed")
            }
        }

    @objc func updateAudioMeter(timer: Timer) {

            if audioRecorder.isRecording {
                let hr = Int((audioRecorder.currentTime / 60) / 60)
                let min = Int(audioRecorder.currentTime / 60)
                let sec = Int(audioRecorder.currentTime.truncatingRemainder(dividingBy: 60))
                let totalTimeString = String(format: "%02d:%02d:%02d", hr, min, sec)
                recordingTimeLabel.text = totalTimeString
                audioRecorder.updateMeters()
            }
        }

        private func getDocumentsDirectory() -> URL {

            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let documentsDirectory = paths[0]
            return documentsDirectory
        }

    @IBAction func playStopAudio(_ sender: UIButton) {
        buttonAnimate(button: sender)
        
        playPauseButtonFlag.toggle()
        
        if playPauseButtonFlag == true {
            player.play()
        } else {
            player.pause()
        }
        
    }
    //MARK:- Audio recorder delegate methods
        func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {

            if !flag {
                finishAudioRecording(success: false)
            }
        }
    
}

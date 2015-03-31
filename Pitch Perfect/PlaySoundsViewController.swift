//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Atul Acharya on 1/28/15.
//  Copyright (c) 2015 Atul Acharya. All rights reserved.
//

import UIKit
import AVFoundation


class PlaySoundsViewController: UIViewController {
    
    var audioPlayer: AVAudioPlayer!
    var receivedAudio: RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioFile:  AVAudioFile!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        
        // init audio engine
        audioEngine = AVAudioEngine()
        
        // init AudioFile
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // stop all audio and reset
    func stopAllAudio() {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    func refreshAndPlay(rate:Float) {
        stopAllAudio()
        audioPlayer.currentTime = 0.0
        audioPlayer.rate = rate
        audioPlayer.play()
    }
    
    
    
    @IBAction func playSlowAudio(sender: UIButton) {
        
        refreshAndPlay(0.5) // play 0.5x the normal speed
    }

    @IBAction func playFastAudio(sender: UIButton) {
        refreshAndPlay(2.0)  // play 2x the normal speed
    }
    
    @IBAction func stopAudio(sender: AnyObject) {
        stopAllAudio()
    }
    
    @IBAction func playChipmunkEffect(sender: AnyObject) {
        playAudioWithVariablePitch(1000)
     }
    
    @IBAction func playDarthEffect(sender: AnyObject) {
        playAudioWithVariablePitch(-1000)
    }
    
    // helper func to play variable pitch sound effects
    func playAudioWithVariablePitch(pitch: Float) {
       
        stopAllAudio()
        
        // create AudioPlayerNode
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        // create some effect (higher pitch) with UnitTimePitch
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        // connect the nodes
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        // play it finally - schedule the File to play
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
    }
    

}

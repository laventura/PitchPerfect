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
        // ORIGINAL
        // playAudioWithVariablePitch(1000)
        // create some effect (higher pitch) with UnitTimePitch
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = 1000     // chipmunk: high pitch effect
        
        playEffect(changePitchEffect)

     }
    
    @IBAction func playDarthEffect(sender: AnyObject) {
        //// playAudioWithVariablePitch(-1000)
        
        // create some effect (higher pitch) with UnitTimePitch
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = -1000     // DARTH effect: low pitch
        
        playEffect(changePitchEffect)

        
    }
    
    // generate a reasonable echo without overwhelming the user
    @IBAction func playEchoEffect(sender: UIButton) {
        var echoEffectNode = AVAudioUnitDelay()
        echoEffectNode.delayTime = 0.08     // 80 ms
        echoEffectNode.feedback = 40        // 40%
        
        playEffect(echoEffectNode)
    }
    
    // reverb effect
    @IBAction func playReverbEffect(sender: UIButton) {
        // create Reverb effect
        var reverb = AVAudioUnitReverb()
        reverb.wetDryMix = Float(80.0)      // stronger mix of effect
        reverb.loadFactoryPreset(AVAudioUnitReverbPreset.LargeChamber)
        
        playEffect(reverb)
        
    }
    
    
    // helper func to play effect based on given effectNode
    func playEffect(effectNode: AVAudioNode) {
        stopAllAudio()
        
        // create AudioPlayerNode
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        // attach the audioNode supplied to our engine
        audioEngine.attachNode(effectNode)
        
        // connect the nodes
        audioEngine.connect(audioPlayerNode, to: effectNode, format: nil)
        audioEngine.connect(effectNode, to: audioEngine.outputNode, format: nil)
        
        // play it finally - schedule the File to play
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
        
        
    }

    

}

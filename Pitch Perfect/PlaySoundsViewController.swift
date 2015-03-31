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
        
//        if var filePath = NSBundle.mainBundle().pathForResource("Box-of-chocolates", ofType: "mp3") {
//            var filePathUrl = NSURL.fileURLWithPath(filePath)
//            
//        } else {
//            println("file path is empty")
//        }
        
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        
        // init audio engine
        audioEngine = AVAudioEngine()
        
        // init AudioFile
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshAndPlay(rate:Float) {
        audioPlayer.stop()
        audioPlayer.currentTime = 0.0
        audioPlayer.rate = rate
        audioPlayer.play()
    }
    
    @IBAction func playSlowAudio(sender: UIButton) {
        //TODO: play audio slooowly
        refreshAndPlay(0.5) // play 0.5x the normal speed
    }

    @IBAction func playFastAudio(sender: UIButton) {
        refreshAndPlay(2.0)  // play 2x the normal speed
    }
    
    @IBAction func stopAudio(sender: AnyObject) {
        audioPlayer.stop()
    }
    
    @IBAction func playChipmunkEffect(sender: AnyObject) {
        playAudioWithVariablePitch(1000)
     }
    
    @IBAction func playDarthEffect(sender: AnyObject) {
        playAudioWithVariablePitch(-1000)
    }
    
    // helper func to play variable pitch sound effects
    func playAudioWithVariablePitch(pitch: Float) {
       
        // reset everything first
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

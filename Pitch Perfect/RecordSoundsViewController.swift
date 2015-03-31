//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Atul Acharya on 1/27/15.
//  Copyright (c) 2015 Atul Acharya. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation


class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        changeRecordingIndicator("Tap to record a short audio", hidden: false)

    }

    
    override func viewDidAppear(animated: Bool) {
        // draw the init state -- allow user to record
        recordButton.enabled = true
        stopRecordingButton.hidden = true
        changeRecordingIndicator("Tap to record a short audio", hidden: false)
    }

    @IBAction func recordAudio(sender: AnyObject) {
        // Reverse the init state: disable record button, show recording msg, show stop button
        stopRecordingButton.hidden = false
        changeRecordingIndicator("Recording...", hidden: false)
        recordButton.enabled = false
        
        // record the user's voice
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let currentDateTime = NSDate()
        
        var formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        var recordingName = formatter.stringFromDate(currentDateTime) + ".wav"
        var pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        
        // setup audio session
        var avsession = AVAudioSession.sharedInstance()
        avsession.setCategory(AVAudioSessionCategoryPlayAndRecord, error:nil)
        // init and prepate the recorder 
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
    func changeRecordingIndicator(message:String, hidden:Bool) {
        recordingInProgress.text = message
        recordingInProgress.hidden = hidden
    }
    
    
    @IBAction func stopAudio (sender: AnyObject) {
        
        changeRecordingIndicator("unused", hidden: true)
        // stop recording and save it
        audioRecorder.stop()
        // deact AV session
        var audiosession = AVAudioSession.sharedInstance()
        audiosession.setActive(false, error:nil)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "goToNextView") {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            
            // sender is the object that initiated the segue (i.e. recordedAudio in our case)
            let recordedDataToPlay = sender as RecordedAudio
            // pass it on to our next ViewController
            playSoundsVC.receivedAudio = recordedDataToPlay
            
        }
        
    }
    
    // MARK: - Delegate method
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        
        if(flag) {
            //  1. Save the recorded audio
            recordedAudio = RecordedAudio(filePathUrl: recorder.url!, title: recorder.url!.lastPathComponent!)
            
            // 2. Move to next scene, aka perform segue
            // this is the name of our segue b/w the two ViewControllers
            self.performSegueWithIdentifier("goToNextView", sender: recordedAudio)
            
        } else {
            println("Recording was not successful")
            recordButton.enabled = true
            stopRecordingButton.hidden = true
        }
    }
    

}


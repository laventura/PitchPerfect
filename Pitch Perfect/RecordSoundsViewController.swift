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
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        stopRecordingButton.hidden = true
    }

    @IBAction func recordAudio(sender: AnyObject) {
        stopRecordingButton.hidden = false
        println("in recordAudio")
        recordingInProgress.hidden = false
        
        // TODO: record the user's voice
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let currentDateTime = NSDate()
        
        var formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        var recordingName = formatter.stringFromDate(currentDateTime) + ".wav"
        var pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        println(filePath)
        
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
    
    
    @IBAction func stopAudio (sender: AnyObject) {
        
        recordingInProgress.hidden = true
        // TODO: stop recording and save it
        audioRecorder.stop()
        // deact AV session
        var audiosession = AVAudioSession.sharedInstance()
        audiosession.setActive(false, error:nil)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "goToNextView") {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            
            // sender if the object that initiated the segue (i.e. recordedAudio in our case)
            let recordedDataToPlay = sender as RecordedAudio
            // pass it on to our next ViewController
            playSoundsVC.receivedAudio = recordedDataToPlay
            
        }
        
    }
    
    // * MARK *   Delegate method
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        
        if(flag) {
            //  1. Save the recorded audio
            recordedAudio = RecordedAudio()
            recordedAudio.filePathUrl = recorder.url
            recordedAudio.title = recorder.url.lastPathComponent
        
        
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


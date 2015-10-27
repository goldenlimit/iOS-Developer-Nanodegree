//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Yue Wu on 10/15/15.
//  Copyright © 2015 Yue Wu. All rights reserved.
//
import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
        //MARK:Reset the record Button label and button back when click "record" back button to root view
        recordButton.hidden = false
        tabRecordLabel.hidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var tabRecordLabel: UILabel!
    @IBAction func recordAudio(sender: UIButton) {
        stopButton.hidden = false
        recordLabel.hidden = false
        recordButton.hidden = true
        tabRecordLabel.hidden = true
        
        //Record user's audio
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        //Setup audio session
        let session = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        }catch let error as NSError {
            print(error.description)
        }

        //Initialize and prepare the recorder
        do{
            audioRecorder = try AVAudioRecorder(URL: filePath!, settings: [:])
        }catch let error as NSError {
            print(error.description)
        }
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if (flag) {
            //Step 1 - Save the recorded audio
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent)
            //Step 2 - Move to the next scene aka perform segue
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }else {
            print("Recording was not successful")
            recordButton.enabled = true
            stopButton.hidden = true
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording"){
            //if the segue equal to "stopRecording" then create a variable 
            //that can hold some data that can pass to the destionation of segue
            let playSoundsVC: PlaySoundViewController = segue.destinationViewController as! PlaySoundViewController
            
            //create data as a container to send the recoredAudio
            let data = sender as! RecordedAudio
            
            //set the recorded audio in data to PlaySoundsVC.receviedAudio
            playSoundsVC.receviedAudio = data
        }
    }
    
    @IBAction func stopRecord(sender: AnyObject) {
        recordLabel.hidden = true
        //Stop recording the user's voice
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
        } catch let error as NSError {
            print(error.description)
        }
    }
}


//
//  PlaySoundViewController.swift
//  Pitch Perfect
//
//  Created by Yue Wu on 10/17/15.
//  Copyright © 2015 Yue Wu. All rights reserved.
//
import UIKit
import AVFoundation

class PlaySoundViewController: UIViewController, UINavigationControllerDelegate {

    var audioPlayer: AVAudioPlayer!
    var receviedAudio: RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try audioPlayer = AVAudioPlayer(contentsOfURL: receviedAudio.filePathUrl)
            audioPlayer.enableRate = true
        }catch {
            print("AudioPlayer encounters issue")
        }
        
        audioEngine = AVAudioEngine()
        
        do {
        audioFile = try AVAudioFile(forReading: receviedAudio.filePathUrl)
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func slowAudioButton(sender: AnyObject) {
        stopAllAudio()
        audioPlay(rate: 0.4)
    }

    @IBAction func fastAudioButton(sender: AnyObject) {
        stopAllAudio()
        audioPlay(rate: 1.6)
    }
    
    @IBAction func playChipmunkButton(sender: UIButton) {
        playAudioWithVariablePitch(pitch:1000)
    }
    
    @IBAction func playDarthvaderButton(sender: UIButton) {
        playAudioWithVariablePitch(pitch:-800)
    }
    
    @IBAction func stopAudioButton(sender: UIButton) {
        stopAllAudio()
    }
    
    //Use abstract repetitive blocks of code into reusable methods
    func stopAllAudio(){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    func audioPlay(rate rate:Float){
        audioPlayer.currentTime = 0.0
        audioPlayer.volume = 0.7
        audioPlayer.rate = rate
        audioPlayer.play()
    }
    
    func playAudioWithVariablePitch(pitch pitch: Float) {
        
        stopAllAudio()
        //Play the record sound
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        let changePitchEffect = AVAudioUnitTimePitch()
        
        //function playAudioWithVariablePitch make this pitch change and depend on different variables
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        do{
            try audioEngine.start()
        } catch let error as NSError {
            print(error.description)
        }
        audioPlayerNode.play()
    }
}
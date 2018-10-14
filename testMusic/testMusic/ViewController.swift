//
//  ViewController.swift
//  testMusic
//
//  Created by Ryan on 2018-10-14.
//  Copyright © 2018 Ryan. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    // The ! means that we know that this song exsist because we placed it in our folder
    // import the song by drag and dropping the song into the folder and add it to the build phases's
    // copy bundle sources
    private var song = URL.init(fileURLWithPath: Bundle.main.path(forResource: "05 Bambi", ofType: "m4a")!)
    
    // We create a AVAudioPlayer object that plays music from a file
    private var songPlayer = AVAudioPlayer()
    
    
    @IBOutlet weak var volume: UISlider!
    
    
    @IBOutlet weak var currentTime: UILabel!
    
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        prepareSongAndSession()
        
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
        
        // Setting this up to zero because no song is playing
        progressBar.setProgress(Float(songPlayer.currentTime / songPlayer.duration), animated: false)
    }
    
    // Updates the progress bar
    @objc private func updateProgress() {
        if songPlayer.isPlaying {
            progressBar.setProgress(Float(songPlayer.currentTime / songPlayer.duration), animated: true)
        }
    }
    
    // Prepares our song
    private func prepareSongAndSession() {
        do {
            songPlayer = try AVAudioPlayer(contentsOf: song)
            
            // Prepares the audio player for playback by preloading its buffers
            songPlayer.prepareToPlay()
            
            prepareSession()
        } catch let songPlayError {
            print(songPlayError)
        }
    }
    
    // Prepares our audio session
    private func prepareSession() {
        // Creating an object that is an instance of the AVAudioSession
        let audioSession = AVAudioSession.sharedInstance()
        do {
            // This is the one way for it to work in xcode 10
            // first argument is playing back the song
            // we'll leave mode to default
            try audioSession.setCategory(.playback, mode: .default)
            try audioSession.setActive(true)
        } catch let sessionError {
            print(sessionError)
        }
    }
    // Plays the song
    @IBAction func playSong(_ sender: Any) {
        songPlayer.play()
    }
    
    // Pauses the song
    @IBAction func stopSong(_ sender: Any) {
        songPlayer.pause()
    }
    
    // Volume of the song
    @IBAction func volumeSlider(_ sender: Any) {
        songPlayer.volume = volume.value
    }
    
    private func currentSongTime() {
        while(songPlayer.isPlaying) {
            currentTime.text = "\(songPlayer.currentTime)"
        }
    }
}


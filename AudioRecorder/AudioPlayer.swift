//
//  AudioPlayer.swift
//  AudioRecorder
//
//  Created by Carletti on 02/08/23.
//

import Foundation
import AVFoundation

class AudioPlayer: NSObject, ObservableObject, AVAudioPlayerDelegate {
    @Published var isPlaying = false
    
    private var audioPlayer = AVAudioPlayer()
    
    func startPlayback(audio: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audio)
            audioPlayer.delegate = self
            audioPlayer.play()
            
            isPlaying = true
        } catch {
            print("Playback failed.")
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            isPlaying = false
        }
    }
    
    func stopPlayback() {
        audioPlayer.stop()
        isPlaying = false
    }
    
}

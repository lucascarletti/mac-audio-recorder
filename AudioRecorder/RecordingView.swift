//
//  ContentView.swift
//  AudioRecorder
//
//  Created by Carletti on 02/08/23.
//

import SwiftUI
import AVFoundation

struct RecordingView: View {
    @ObservedObject var recorder = AudioRecorder()
    @ObservedObject var player = AudioPlayer()
    
    var body: some View {
        VStack() {
            Button(action: {
                if recorder.recording {
                    recorder.stopRecording()
                    recorder.recording = false
                } else if recorder.playing {
                    // do nothing
                } else if recorder.recorded {
                    recorder.playing = true
                    player.startPlayback(audio: recorder.outputFile!.url)
                }else {
                    recorder.startRecording()
                }
            }) {
                Image(systemName: buttonImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 10)
            }
            Text(buttonText)
        }
//        .padding()
    }
    
    // ... The rest of the code remains the same ...
    
    private var buttonText: String {
        if recorder.recording {
            return "Recording..."
        } else if recorder.playing {
            return "Playing..."
        } else if recorder.recorded {
            return "Play your record"
        } else {
            return "Tap to Record"
        }
    }
    
    private var buttonImageName: String {
        if recorder.recording {
            return "stop.circle"
        } else if recorder.playing {
            return "pause.circle"
        } else if recorder.recorded {
            return "play.circle"
        } else {
            return "mic.circle.fill"
        }
    }
}

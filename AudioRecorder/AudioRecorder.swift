//
//  AudioRecorder.swift
//  AudioRecorder
//
//  Created by Carletti on 02/08/23.
//

import Foundation
import SwiftUI
import AVFoundation

class AudioRecorder: NSObject, ObservableObject, AVAudioPlayerDelegate {
    private var activeRecorder: AVAudioRecorder?
    private let audioEngine = AVAudioEngine()

    @Published var micAccessAllowed = false
    
    @Published var playing = false
    @Published var recording = false
    @Published var recorded = false
    
    var outputFile: AVAudioFile? = nil
    
    override init() {
        print("AudioRecorder init() - Started Recording")
        super.init()
        checkMicrophonePermissions()
    }
    
    public func startRecording() {
        let input = audioEngine.inputNode
        let bus = 0
        let inputFormat = input.inputFormat(forBus: bus)
        
        let outputURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("recorded.caf")
        print("writing to \(outputURL)")
        do {
            outputFile = try AVAudioFile(forWriting: outputURL, settings: inputFormat.settings, commonFormat: inputFormat.commonFormat, interleaved: inputFormat.isInterleaved)
            
            input.installTap(onBus: bus, bufferSize: 512, format: inputFormat) { (buffer, time) in
                try? self.outputFile?.write(from: buffer)
            }
            
            try audioEngine.start()
            recording = true
        } catch {
            print(error)
        }
    }
    
    func stopRecording() {
        audioEngine.stop()
        recording = false
        if outputFile != nil {
            recorded = true
        }
    }
    
    public func openSystemPreferences() {
        guard let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Microphone") else { return }
        NSWorkspace.shared.open(url)
    }
}

extension AudioRecorder {
    public func checkMicrophonePermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .audio) {
        case .authorized:
            // Microphone access is already granted, proceed to set up audio recording
            micAccessAllowed = true
        case .notDetermined:
            // Request microphone access if it's not determined yet
            AVCaptureDevice.requestAccess(for: .audio) { [weak self] granted in
                if granted {
                    self?.micAccessAllowed = true
                } else {
                    // Handle access denial case
                    print("Microphone access denied.")
                }
            }
        case .denied, .restricted:
            // Handle access denial or restrictions
            openSystemPreferences()
            print("Microphone access denied or restricted.")
        @unknown default:
            openSystemPreferences()
            print("Unknown microphone authorization status.")
        }
    }
    
    private func availableMicrophones() -> [AVCaptureDevice] {
        // Discover available audio devices to find microphones
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInMicrophone],
                                                                mediaType: .audio,
                                                                position: .unspecified)
        return discoverySession.devices
    }
}

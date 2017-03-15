//
//  AppDelegate.swift
//  AqTK-Swift
//
//  Created by satoru on 2017/03/14.
//  Copyright © 2017年 SK. All rights reserved.
//

import Cocoa
import AppKit
import AVFoundation

import AquesTalk2

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var window = NSWindow()
    
    // エンジンの生成
    let audioEngine = AVAudioEngine()
    // Playerノードの生成
    let player = AVAudioPlayerNode()

    func say(string:NSString){
        var size = Int32();
        let wav = AquesTalk2_Synthe_Utf8(string.utf8String, 100, &size, nil)
        if ( wav == nil ) {
            print("error!!")
        } else {
            
        }
        
        let data = NSData(bytes: wav!, length: Int(size))
        
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let dirname = "/say-data"
        
        let manager = FileManager()
        do {
            try manager.createDirectory(atPath: path+dirname, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("Error while creating a folder.")
        }
        let filename = "/" + (string as String) + ".wav"
        let fullpath = path+dirname+filename
        
        print(fullpath)
        
        let success = data.write(toFile: fullpath, atomically: true)
        if success {
            print("save OK")
        }else{
            print("save error")
        }
        
        do {
            
            let encodedpath = fullpath.addingPercentEncoding(withAllowedCharacters: .controlCharacters)
            let filepath = URL(string: encodedpath!)
            
            // オーディオファイルの取得
            let audioFile = try AVAudioFile(forReading: filepath!)
            
            let AudioFormat = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: 8000, channels: 1, interleaved: false)

            print(audioFile)
            
            // エンジンにノードをアタッチ
            audioEngine.attach(player)
            // メインミキサの取得
            let mixer = audioEngine.mainMixerNode
            // Playerノードとメインミキサーを接続
            audioEngine.connect(player,
                                to: mixer,
                                format: AudioFormat)
            // プレイヤのスケジュール
            player.scheduleFile(audioFile, at: nil) {
                print("complete")
            }
            // エンジンの開始
            try audioEngine.start()
            // オーディオの再生
            player.play()
        } catch let error {
            print(error)
        }
        
        AquesTalk2_FreeWave(wav);
        
    }
    
    func toPCMBuffer(data: NSData) -> AVAudioPCMBuffer {
        let audioFormat = AVAudioFormat(commonFormat: AVAudioCommonFormat.pcmFormatFloat32, sampleRate: 8000, channels: 1, interleaved: false)  // given NSData audio format
        let PCMBuffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: UInt32(data.length) / audioFormat.streamDescription.pointee.mBytesPerFrame)
        PCMBuffer.frameLength = PCMBuffer.frameCapacity
        let channels = UnsafeBufferPointer(start: PCMBuffer.floatChannelData, count: Int(PCMBuffer.format.channelCount))
        data.getBytes(UnsafeMutableRawPointer(channels[0]) , length: data.length)
        return PCMBuffer
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
//        say(string: "うーん")
        say(string: "わーい")
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}


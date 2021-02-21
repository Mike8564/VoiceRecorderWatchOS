//
//  InterfaceController.swift
//  VoiceRecorder WatchKit Extension
//
//  Created by Mike Sedaghatnia on 2021-02-21.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet weak var image: WKInterfaceImage!
     
    override func awake(withContext context: Any?) {
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }

    @IBAction func dictateTapped() {
        presentTextInputController(withSuggestions: nil, allowedInputMode: .plain) { (result) in
            guard let result = result?.first as? String else {return}
            print(result)
        }
    }
    @IBAction func multiInputTapped() {
        presentTextInputController(withSuggestions: ["Hello, World!", "I'm Mike, who are you?", "What a nice day!"], allowedInputMode: .allowEmoji) { (result) in
            if let result = result?.first as? String {
                print(result)
            } else if let result = result?.first as? Data {
                guard let imageData = UIImage(data: result) else {return}
                self.image.setImage(imageData)
            }
        }
    }
    @IBAction func recodingTapped() {
        
        // set reading and writing path
        let writingURL = getDocumentDictionary().appendingPathComponent("Recording.wav")
        
        if FileManager.default.fileExists(atPath: writingURL.path) {
            
            // if we have a recorded file, play it
            let options = [WKMediaPlayerControllerOptionsAutoplayKey: "true"]
            presentMediaPlayerController(with: writingURL, options: options) { (success, endingTime, error) in
                
            }
        } else {
            // we need to write data
            let options: [String:Any] = [WKAudioRecorderControllerOptionsMaximumDurationKey: 60, WKAudioRecorderControllerOptionsActionTitleKey: "Done"]
            
            presentAudioRecorderController(withOutputURL: writingURL, preset: .narrowBandSpeech, options: options) { (success, error) in
                if success {
                    print("file saved successfully")
                } else {
                    print(error?.localizedDescription ?? "unknown error!")
                }
            }
        }
        
        
    }
    
    func getDocumentDictionary() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return path[0]
    }
}

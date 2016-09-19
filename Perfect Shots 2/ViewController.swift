//
//  ViewController.swift
//  Perfect Shots 2
//
//  Created by Arron Mollet on 9/10/16.
//  Copyright © 2016 Arron Mollet. All rights reserved.
//

import UIKit
import MessageUI
import MobileCoreServices
import AVKit
import AVFoundation

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MFMailComposeViewControllerDelegate {
    
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    
    let saveFileName = "/test.mp4"
    
    @IBOutlet weak var SendToCoach: UIButton!
    
    @IBOutlet weak var Record: UIButton!

    @IBOutlet weak var playVideo: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func sendToCoach(sender: UIButton) {
                if (MFMailComposeViewController.canSendMail() ){
                    print("Can Send e-mail")
                    let mailComposerVC = MFMailComposeViewController()
                    mailComposerVC.mailComposeDelegate = self
                    mailComposerVC.setToRecipients(["arron_mollet22@yahoo.com"])
                    mailComposerVC.setSubject("Perfect Shot Video")
                    mailComposerVC.setMessageBody("Video Example \n", isHTML: false)

                
            if let filePath = NSBundle.mainBundle().pathForResource("/test.mp4", ofType: "mp4") {
                print("File Path Loaded")
                
                if let fileData = NSData(contentsOfFile: filePath) {
                    print("File Data Loaded")
                    mailComposerVC.addAttachmentData(fileData, mimeType: "video/mp4", fileName: "/test.mp4")
                
                    
                }
            }
               
            
            self.presentViewController(mailComposerVC, animated: true, completion: nil)
        }
    
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
    
    //RECORD VIDEO CODE
    
    
    @IBAction func recordVideo(sender: AnyObject) {
        
        if (UIImagePickerController.isSourceTypeAvailable(.Camera)) {
            if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil {
                
                imagePicker.sourceType = .Camera
                imagePicker.mediaTypes = [kUTTypeMovie as String]
                imagePicker.allowsEditing = false
                imagePicker.delegate = self
                
                presentViewController(imagePicker, animated: true, completion: {})
            }
        }
        
    }
    
    //PLAY VIDEO CODE
    
    @IBAction func playVideo(sender: AnyObject) {
        
        print("Play a video")
        
        // Find the video in the app's document directory
        let paths = NSSearchPathForDirectoriesInDomains(
            NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentsDirectory: AnyObject = paths[0]
        let dataPath = documentsDirectory.stringByAppendingPathComponent(saveFileName)
        let videoAsset = (AVAsset(URL: NSURL(fileURLWithPath: dataPath)))
        let playerItem = AVPlayerItem(asset: videoAsset)
        
        // Play the video
        let player = AVPlayer(playerItem: playerItem)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        
        self.presentViewController(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
        
    }
        
    //Video Record/Save Funcs
    
    // Finished recording a video
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        print("Got a video")
        
        if let pickedVideo:NSURL = (info[UIImagePickerControllerMediaURL] as? NSURL) {
            // Save video to the main photo album
            let selectorToCall = #selector(ViewController.videoWasSavedSuccessfully(_:didFinishSavingWithError:context:))
            UISaveVideoAtPathToSavedPhotosAlbum(pickedVideo.relativePath!, self, selectorToCall, nil)
            
            // Save the video to the app directory so we can play it later
            let videoData = NSData(contentsOfURL: pickedVideo)
            let paths = NSSearchPathForDirectoriesInDomains(
                NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
            let documentsDirectory: AnyObject = paths[0]
            let dataPath = documentsDirectory.stringByAppendingPathComponent(saveFileName)
            videoData?.writeToFile(dataPath, atomically: false)
            
        }
        
        imagePicker.dismissViewControllerAnimated(true, completion: {
            // Anything you want to happen when the user saves an video
        })
    }
    
    // Called when the user selects cancel
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        print("User canceled image")
        dismissViewControllerAnimated(true, completion: {
            // Anything you want to happen when the user selects cancel
        })
    }
    
    // Any tasks you want to perform after recording a video
    func videoWasSavedSuccessfully(video: String, didFinishSavingWithError error: NSError!, context: UnsafeMutablePointer<()>){
        print("Video saved")
        if let theError = error {
            print("An error happened while saving the video = \(theError)")
        } else {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                // What you want to happen
            })
        }
    }
    
    
    // MARK: Utility methods for app
    // Utility method to display an alert to the user.
    func postAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message,
                                      preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    //Mail Send Funcs
    
    
    
    
    func showSendMailErrorAlret() {
        let sendMailErrorAlret = UIAlertView(title: "Could Not Send", message: "Your device could not send the e-mail", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlret.show()
        
        
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        
        switch result.rawValue {
        case MFMailComposeResultCancelled.rawValue:
            print("Cancelled mail")
        case MFMailComposeResultSent.rawValue:
            print("Mail Sent")
        default:
            break
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    


}


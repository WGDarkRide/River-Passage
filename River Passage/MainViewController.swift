//
//  MainViewController.swift
//  River Passage
//
//  Created by Manjit Bedi on 2016-10-16.
//  Copyright © 2016 noorg. All rights reserved.
//

import UIKit
import AVFoundation

class MainViewController: UIViewController, AVAudioPlayerDelegate {

    var audioPlayer:AVAudioPlayer?
    var isDisplayingBio = false
    var isDisplayingCredits = false
    
    
    @IBOutlet weak var poemTextView: UITextView!
    
    @IBOutlet weak var playAudio: UIButton!
    
    @IBOutlet weak var pause: UIButton!

    @IBOutlet weak var containerView: UIView!
    
    lazy var bioViewController: BioViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "bioView") as! BioViewController
        self.addViewControllerAsChildViewController(viewController: viewController)
        
        return viewController
    }()
    

    lazy var creditsViewController: CreditsViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "creditsView") as! CreditsViewController
        self.addViewControllerAsChildViewController(viewController: viewController)
        
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // increase the font size for the iPad.
        if UIDevice.current.userInterfaceIdiom == .pad {
            poemTextView.font = UIFont.systemFont(ofSize: 20)
        }
        
        poemTextView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
    }

    override func viewDidLayoutSubviews() {
        poemTextView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func addViewControllerAsChildViewController(viewController: UIViewController) {
        addChildViewController(viewController)
        containerView.addSubview(viewController.view)
        viewController.view.frame = containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParentViewController: self)
    }
    
    private func removeViewControllerAsChildViewController(viewController: UIViewController) {
        viewController.willMove(toParentViewController: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
    }
    
    @IBAction func playAction(_ sender: AnyObject) {
        
        if let audioPlayer = audioPlayer {
            if (!audioPlayer.isPlaying) {
                audioPlayer.play()
            }
        } else {
            if let myAudioUrl = Bundle.main.url(forResource: "RPVoiceMusic", withExtension: "m4a") {
                do {
                    audioPlayer = try AVAudioPlayer(contentsOf: myAudioUrl)
                    audioPlayer?.prepareToPlay()
                    audioPlayer?.play()
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    @IBAction func pauseAction(_ sender: AnyObject) {
        if (audioPlayer?.isPlaying)! {
            audioPlayer?.pause()
        } else {
            audioPlayer?.play()
        }
    }
    
    @IBAction func displayPoem(_ sender: AnyObject) {
        self.containerView.isHidden = true
        
        if (isDisplayingCredits) {
            isDisplayingCredits = false
            removeViewControllerAsChildViewController(viewController: creditsViewController)
        } else if (isDisplayingBio) {
            isDisplayingBio = false
            removeViewControllerAsChildViewController(viewController: bioViewController)
        }
    }
    
    @IBAction func displayBio(_ sender: AnyObject) {
        containerView.isHidden = false;
        if (isDisplayingCredits) {
            isDisplayingCredits = false
            removeViewControllerAsChildViewController(viewController: creditsViewController)
        }
        isDisplayingBio = true
        addViewControllerAsChildViewController(viewController: self.bioViewController)
    }
    
    @IBAction func displayCredits(_ sender: AnyObject) {
        self.containerView.isHidden = false;
        if (isDisplayingBio) {
            isDisplayingBio = false
            removeViewControllerAsChildViewController(viewController: bioViewController)
        }
        isDisplayingCredits = true
        self.addViewControllerAsChildViewController(viewController: self.creditsViewController)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool){
        audioPlayer?.currentTime = 0
    }
}

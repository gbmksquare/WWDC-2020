//
//  GameIntroViewController.swift
//  WWDC 2020
//
//  Created by BumMo Koo on 2020/05/18.
//  Copyright © 2020 BumMo Koo. All rights reserved.
//

import UIKit
import AVFoundation
import PencilKit
#if canImport(PlaygroundSupport)
import PlaygroundSupport
#endif

public class GameIntroViewController: UIViewController {
    @IBOutlet private var label: UILabel!
    private lazy var canvas = PKCanvasView(frame: .zero)
    
    // MARK: - View life cycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Setup
    private func setup() {
        view.insertSubview(canvas, at: 0)
        canvas.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            canvas.topAnchor.constraint(equalTo: label.topAnchor),
            canvas.bottomAnchor.constraint(equalTo: label.bottomAnchor),
            canvas.leadingAnchor.constraint(equalTo: label.leadingAnchor),
            canvas.trailingAnchor.constraint(equalTo: label.trailingAnchor)
        ])
        
        #if (arch(i386) || arch(x86_64))
        #else
        canvas.tool = PKInkingTool(.pencil, color: UIColor.black.withAlphaComponent(0.85), width: 9)
        #endif
    }
    
    // MARK: - User interfaction
    @IBAction
    private func tap(play button: UIButton) {
        let utterance = AVSpeechUtterance(string: "윷")
        utterance.voice = AVSpeechSynthesisVoice(language: "ko-KR")
        utterance.rate = AVSpeechUtteranceMinimumSpeechRate

        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
}

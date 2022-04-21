//
//  VideoViewController.swift
//  MediaPlayer
//
//  Created by Савва Никитин on 26.02.2022.
//

import UIKit
import WebKit

final class VideoViewController: UIViewController {
    
    public var youTubeString: String?
    
    @IBOutlet private var videoWebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showVideo()
        
    }
    
    private func showVideo() {
        guard let youTubeString = youTubeString else {
            return
        }
        let urlOptional = URL(string: youTubeString)
        guard let url = urlOptional else {
            return
        }
        videoWebView.load(URLRequest(url: url))
    }
    
}

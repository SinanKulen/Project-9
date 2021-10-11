//
//  DetailViewController.swift
//  MyTrainerProject
//
//  Created by Sinan Kulen on 25.09.2021.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    
    var webView : WKWebView!
    var detailItem : Petition?
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
            
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let detailItem = detailItem else { return }
        
        let html = """
            <html>
            <head>
            <meta name = "view port", content = "width = device - width, initial-scale = 1">
            </head>
            <body>
            <p style = "font-style : 35-italic;"> \(detailItem.body)</p>
            </html>
            """
            webView.loadHTMLString(html, baseURL: nil)
    }
    

}

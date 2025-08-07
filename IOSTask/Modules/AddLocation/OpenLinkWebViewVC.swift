//
//  OpenLinkWebViewVC.swift
//  IOSTask
//
//  Created by Nasser Lamei on 07/08/2025.
//

import UIKit
import WebKit

class OpenLinkWebViewVC: UIViewController, WKNavigationDelegate  {

    @IBOutlet weak var webView: WKWebView!
    
    
    var header: String?
    var link = "http://8.213.81.130:8087/api/account/login"
    var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
     //   setUpNavBar()
        
        
        webView.navigationDelegate = self
        self.view.addSubview(webView)
        
        // Initialize and configure the activity indicator
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        self.view.addSubview(activityIndicator)
        if let url = URL(string: link) {
            let request = URLRequest(url: url)
            webView.load(request)
        } else {
            // Handle invalid URL string
            print("Invalid URL string")
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        activityIndicator.startAnimating()
        print("the link is \(link)")
    }

//    func setUpNavBar() {
//        lblHeader.text = header
//        if userPreferredLanguage.hasPrefix("ar"){
//            backBtnOutlet.setImage(UIImage(named: "back icon"), for: .normal)//back icon
//        }else{
//            backBtnOutlet.setImage(UIImage(named: "back  eng icon"), for: .normal)
//        }
//        backBtnOutlet.setTitle("", for: .normal)
//        self.navigationController?.isNavigationBarHidden = true
//    }
    
  
  
    
//    // WKNavigationDelegate methods
//    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
//        activityIndicator.startAnimating()
//    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopAnimating()
    }
    
}

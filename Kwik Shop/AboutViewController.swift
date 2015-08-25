//
//  AboutViewController.swift
//  Kwik Shop
//
//  Created by Adrian Kretschmer on 25.08.15.
//  Copyright (c) 2015 FAU-Inf2. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController, UIScrollViewDelegate, UIWebViewDelegate {
    
    @IBOutlet weak var aboutWebView: UIWebView!
    private var initialLinkIntercepted = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        aboutWebView.delegate = self
        aboutWebView.scrollView.delegate = self
        aboutWebView.scrollView.showsHorizontalScrollIndicator = false
        
        let kwikShopHeading = "Kwik Shop"
        let gitHubLink = "https://github.com/FAU-Inf2/kwikshop-ios"
        let gitHubLinkDescription = "View on GitHub"
        
        let version = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as? String
        let versionDescription = "Version"
        
        let acknowledgementsHeading = "Acknowledgements"
        
        let htmlHeader = "<!DOCTYPE html>\n<html>\n<body>\n"
        let htmlFooter = "</body>\n</html>"
        
        var aboutText = htmlHeader
        aboutText += kwikShopHeading.htmlH1
        aboutText += gitHubLink.htmlLinkWithDescription(gitHubLinkDescription).htmlParagraph
        aboutText += versionDescription.htmlH3
        aboutText += version!.htmlParagraph
        aboutText += acknowledgementsHeading.htmlH2
        
        
        aboutText += htmlFooter
        
        aboutWebView.loadHTMLString(aboutText, baseURL: nil)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK UIWebViewDelegate
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if (self.initialLinkIntercepted) {
            UIApplication.sharedApplication().openURL(request.URL!)
            return false
        } else {
            self.initialLinkIntercepted = true;
            return true;
        }
    }
    
    // MARK UIScrollViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (scrollView.contentOffset.x > 0) {
            scrollView.contentOffset = CGPointMake(0, scrollView.contentOffset.y)
        }
    }
    
}

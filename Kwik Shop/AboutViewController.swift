//
//  AboutViewController.swift
//  Kwik Shop
//
//  Created by Adrian Kretschmer on 25.08.15.
//  Copyright (c) 2015 FAU-Inf2. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var aboutWebView: UIWebView!
    private var initialLinkIntercepted = false
    var aboutText : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "navigation_bar_about".localized
        
        aboutWebView.delegate = self
        aboutWebView.scrollView.showsHorizontalScrollIndicator = false
        
        let kwikShopHeading = "Kwik Shop"
        let gitHubLink = "https://github.com/FAU-Inf2/kwikshop-ios"
        let gitHubLinkDescription = "View on GitHub"
        
        let version = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as? String
        let versionDescription = "Version"
        
        let acknowledgementsHeading = "Acknowledgements"
        let acknowledgementsDescriptiveText = "This application uses several third-party libraries:"
        
        let mlpLink = "https://github.com/EddyBorja/MLPAutoCompleteTextField"
        let mlpDescription = "MLPAutoCompleteTextField"
        let mlpLicense = ", licensed under the MIT License"
        let mlpSubLibraryDescription = ". This library uses the NSString+Levenshtein category, which uses the following license:"
        let nsStringPlusLevenshteinLicense = "<blockquote><p>NSString+Levenshtein</p><p>Copyright (c) 2009, Mark Aufflick All rights reserved.</p><p>Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:</p><ul><li>Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.</li><li>Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.</li> <li>Neither the name of the Mark Aufflick nor the names of contributors may be used to endorse or promote products derived from this software without specific prior written permission.</li></ul><p>THIS SOFTWARE IS PROVIDED BY MARK AUFFLICK ''AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL MARK AUFFLICK BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.</p></blockquote>"
        
        let somePortionsBeginning = "Some portions of the "
        let kwikShopAndroidDescription = "Kwik Shop Android App"
        let kwikShopAndroidLink = "https://github.com/FAU-Inf2/kwikshop-android"
        let kwikShopAndroidLicense = ", licensed under the MIT License, "
        let somePortionsEnd = "were adopted to Swift and used in this application"
        
        let tabBarIconsDescription = "The tab bar icons were licensed by "
        let tabBarIconsLink = "https://icons8.com"
        let tabBarIconsLinkDescription = "Icons8"
        let tabBarIconsLicenseDescriptionBegining = " under the "
        let tabBarIconsLicenseLink = "https://creativecommons.org/licenses/by-nd/3.0/"
        let tabBarIconsLicenseLinkDescription = "CC BY-ND 3.0"
        let tabBarIconsLicenseDescriptionEnd = " license."
        
        let defaultFont = UIFont.systemFontOfSize(CGFloat(14))
        //let meta = "<meta name=\"viewport\" content=\"width=device-width\"/>"
        let htmlHeader = "<!DOCTYPE html>\n<html><head><style>p,h1,h2,h3,blockquote{font-family: \"\(defaultFont.familyName)\"}</style></head>\n<body>\n"
        let htmlFooter = "</body>\n</html>"
        
        var aboutText = htmlHeader
        aboutText += kwikShopHeading.htmlH1
        aboutText += gitHubLink.htmlLinkWithDescription(gitHubLinkDescription).htmlParagraph
        aboutText += versionDescription.htmlH3
        aboutText += version!.htmlParagraph
        aboutText += acknowledgementsHeading.htmlH2
        aboutText += acknowledgementsDescriptiveText.htmlParagraph
        aboutText += (mlpLink.htmlLinkWithDescription(mlpDescription).htmlBold + mlpLicense + mlpSubLibraryDescription).htmlParagraph
        aboutText += nsStringPlusLevenshteinLicense
        aboutText += (tabBarIconsDescription + tabBarIconsLink.htmlLinkWithDescription(tabBarIconsLinkDescription).htmlBold + tabBarIconsLicenseDescriptionBegining + tabBarIconsLicenseLink.htmlLinkWithDescription(tabBarIconsLicenseLinkDescription) + tabBarIconsLicenseDescriptionEnd).htmlParagraph
        
        aboutText += (somePortionsBeginning + kwikShopAndroidLink.htmlLinkWithDescription(kwikShopAndroidDescription).htmlBold + kwikShopAndroidLicense + somePortionsEnd).htmlParagraph
        
        aboutText += htmlFooter
        self.aboutText = aboutText
        
        aboutWebView.loadHTMLString(aboutText, baseURL: nil)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        coordinator.animateAlongsideTransition(
            { [unowned self] (context) -> () in
                let orientation = UIApplication.sharedApplication().statusBarOrientation
                if orientation.isLandscape {
                    self.initialLinkIntercepted = false
                    self.aboutWebView?.loadHTMLString(self.aboutText!, baseURL: nil)
                }
            },
            completion: nil)

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
    
}

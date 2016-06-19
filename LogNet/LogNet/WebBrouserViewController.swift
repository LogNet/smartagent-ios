//
//  WebBrouserViewController.swift
//  LogNet
//
//  Created by Anton Tikhonov on 6/19/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import UIKit
import AMScrollingNavbar

class WebBrouserViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    
    var viewModel:WebBrowserViewModel?
    
    var refreshControl:UIRefreshControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.loadRequestFromString("http://www.lognet-travel.com/")
        self.addRefreshControl()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.viewModel?.checkUserLoggedIn()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let navigationController = self.navigationController as? ScrollingNavigationController {
            navigationController.followScrollView(self.webView, delay: 50.0)
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        if let navigationController = self.navigationController as? ScrollingNavigationController {
            navigationController.stopFollowingScrollView()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func addRefreshControl() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.addTarget(self, action: #selector(self.refresh(_:)), forControlEvents: .ValueChanged)
        self.webView.scrollView.addSubview(refreshControl!)
    }
    
    func refresh(refreshControl:UIRefreshControl) {
        self.webView.reload()
    }
    
    func loadRequestFromString(urlString:String) {
        let url = NSURL(string: urlString)
        let urlRequest = NSURLRequest(URL: url!)
        self.webView.loadRequest(urlRequest)
    }
    
    
    // MARK: Web view delegate
    func webViewDidStartLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        if self.refreshControl!.refreshing {
            self.refreshControl!.endRefreshing()
        }
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        let title = webView.stringByEvaluatingJavaScriptFromString("document.title")
        self.title = title
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    }
}

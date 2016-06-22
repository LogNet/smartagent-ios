//
//  WebBrouserViewController.swift
//  LogNet
//
//  Created by Anton Tikhonov on 6/19/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import UIKit
import AMScrollingNavbar
import ReactiveCocoa

class WebBrouserViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    
    var viewModel:WebBrowserViewModel?
    
    var refreshControl:UIRefreshControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weak var weakSelf = self
        self.viewModel?.rac_valuesForKeyPath("urlString", observer: self).subscribeNext({ (string:AnyObject!) in
            if let urlString = string as? String {
                weakSelf!.loadRequestFromString(urlString)
            }
            
        })
        self.addRefreshControl()
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

    
    // MARK: Public
    
    func showNotificationAlert(alertViewModel:AlertNotificationViewModel)  {
        let alert =
            UIAlertController(title: alertViewModel.title,
                              message: alertViewModel.text,
                              preferredStyle: .Alert)
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil);
        let open = UIAlertAction(title: "Open", style: .Default) { (action:UIAlertAction) in
            self.viewModel?.urlString = alertViewModel.urlString
        }
        
        alert.addAction(open)
        alert.addAction(cancel)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK: Private
    
    private func addRefreshControl() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.addTarget(self, action: #selector(self.refresh(_:)), forControlEvents: .ValueChanged)
        self.webView.scrollView.addSubview(refreshControl!)
    }
    
    func refresh(refreshControl:UIRefreshControl) {
        self.webView.reload()
//        self.viewModel?.urlString = "http://stackoverflow.com"
    }
    
    private func loadRequestFromString(urlString:String) {
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

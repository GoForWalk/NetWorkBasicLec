//
//  WebViewController.swift
//  NetWorkBasicLec
//
//  Created by sae hun chung on 2022/07/28.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var xmarkBarButton: UIBarButtonItem!
    @IBOutlet weak var goBackBarButton: UIBarButtonItem!
    @IBOutlet weak var reloadBarButton: UIBarButtonItem!
    @IBOutlet weak var goForwardBarButton: UIBarButtonItem!
    
    
    var destinationURL: String = "https://www.apple.com"
    // App Transport Security Settings
    // http X
    
    override func viewDidLoad() {
        super.viewDidLoad()

        openWebPage(url: destinationURL)
        searchBar.delegate = self
        webView.navigationDelegate = self
        
        setUI()
    }
    
    func setUI() {
        xmarkBarButton.image = UIImage(systemName: "xmark")
        goBackBarButton.image = UIImage(systemName: "arrow.left")
        reloadBarButton.image = UIImage(systemName: "arrow.clockwise")
        goForwardBarButton.image = UIImage(systemName: "arrow.right")
    }
    
    func openWebPage(url: String) {
        guard let url = URL(string: url) else {
            print("Invalid URL")
            return
        }
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    @IBAction func xmarkButtonTapped(_ sender: UIBarButtonItem) {
//        dismiss(animated: true)
    }
    
    @IBAction func goBackButtonTapped(_ sender: UIBarButtonItem) {
        if webView.canGoBack {
            webView.goBack()
        }
    }
    
    @IBAction func reloadButtonTapped(_ sender: UIBarButtonItem) {
        webView.reload()
    }
    
    @IBAction func goForwardButtonTapped(_ sender: UIBarButtonItem) {
        if webView.canGoForward {
            webView.goForward()
        }
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print(#function)
        self.searchBar.text = webView.url?.description
    }
}

extension WebViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        openWebPage(url: searchBar.text!)
    }
    
    
}

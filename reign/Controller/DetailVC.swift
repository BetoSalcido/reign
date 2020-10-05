//
//  DetailVC.swift
//  reign
//
//  Created by Beto Salcido on 04/10/20.
//  Copyright © 2020 BetoSalcido. All rights reserved.
//

import UIKit
import WebKit

class DetailVC: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    var url: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        configWebView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if let stringUrl = url, let url = URL(string: stringUrl) {
            webView.load(URLRequest(url: url))
            webView.allowsBackForwardNavigationGestures = true
        } else {
            AlertManager.showSimpleAlertView(on: self, with: "Lo sentimos", message: "URL invalida") { [weak self] (UIAlertAction) in
                guard let strongSelf = self else { return }
                strongSelf.navigationController?.popViewController(animated: true)
            }
        }
    }

    private func configWebView() {
        webView.navigationDelegate = self
    }
    
    private func showErrorView() {
        AlertManager.showOverallMessage(on: self) {[weak self] (UIAlertAction) in
                   guard let strongSelf = self else { return }
                   strongSelf.navigationController?.popViewController(animated: true)
               }
    }

}

extension DetailVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        showLoadingView(transparent: true)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        removeLoadingView()
    }
    
    private func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
      if error.code == -1001 { // TIMED OUT:
        showErrorView()
      } else if error.code == -1003 { // SERVER CANNOT BE FOUND
        showErrorView()
      } else if error.code == -1100 { // URL NOT FOUND ON SERVER
        showErrorView()
      }
    }
}

//
//  ViewController.swift
//  Ionkepler
//
//  Created by User on 3/30/16.
//  Copyright © 2016 Coreveillance. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, UIWebViewDelegate, WKScriptMessageHandler {
    var webView: WKWebView!
    @IBOutlet var containerView: UIView!
    
    let url = "http://192.168.1.79/test/scanbarcode/"
    var barcode = bar_codes()
    let contentController = WKUserContentController();
    let config = WKWebViewConfiguration()
    var sentData: NSDictionary = [:]
    override func loadView() {
        super.loadView()
        let userScript = WKUserScript(
            source: "redHeader()",
            injectionTime: WKUserScriptInjectionTime.AtDocumentEnd,
            forMainFrameOnly: true
        )
        contentController.addUserScript(userScript)
        contentController.addScriptMessageHandler(
            self,
            name: "callbackHandler"
        )
        config.userContentController = contentController
        self.webView = WKWebView(
            frame: self.containerView.bounds,
            configuration: config
        )
        self.view = self.webView!
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let requestURL = NSURL(string:url)
        let request = NSURLRequest(URL: requestURL!)
        self.webView!.loadRequest(request)
    }
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        sentData = message.body as! NSDictionary
        let function:String = String(sentData["function"] as! NSString)
        if(function == "activate_scanner") {
            self.activate_scanner()
        }
    }
    func activate_scanner() {
        print("Activating Scanner")
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ScannerViewController") as UIViewController
        // .instantiatViewControllerWithIdentifier() returns AnyObject! this must be downcast to utilize it
        self.presentViewController(viewController, animated: false, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToScanner(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? ScannerViewController, barcode_send = sourceViewController.barcode_send {
            // Add a new meal.
            barcode = barcode_send
        }
        print("Entro")
        for serial in (self.barcode?.serials)! {
            print("Enviado "+serial.number)
            webView!.evaluateJavaScript("load_serial(String( \(serial.number) ))") { (result, error) in
                if error != nil {
                    print(result)
                }
            }
        }
    }
}


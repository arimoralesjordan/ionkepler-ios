//
//  ViewController.swift
//  Ionkepler
//
//  Created by Ari Morales on 3/30/16.
//  Copyright © 2016 Coreveillance. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, UIWebViewDelegate, WKScriptMessageHandler {
    var webView: WKWebView!
    @IBOutlet var containerView: UIView!
    
    let url = "http://192.168.1.79/coreveillance/main/mobile.php"
    var barcode = bar_codes()
    let contentController = WKUserContentController();
    let config = WKWebViewConfiguration()
    var sentData: NSDictionary = [:]
    var input_serial:String = ""
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
        let function:String = String(sentData["fnc"] as! NSString)
        if(function == "activate_scanner") {
            input_serial = String(sentData["input_serial"] as! NSString)
            self.activate_scanner()
        }
		if(function == "ShowStatusBar") {
			self.ShowStatusBar()
		}
		if(function == "hide_statusbar") {
			self.HideStatusBar()
		}
		if(function == "ShowRouteMap") {
			let daddress:String = String(sentData["daddress"] as! NSString)
			self.ShowRouteMap(daddress)
		}
    }
	func ShowStatusBar()  {
		UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .Fade)
	}
	func HideStatusBar()  {
		UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: .Fade)
	}
	func ShowRouteMap(daddress:String){
		print("Opening: comgooglemaps://?saddr=&daddr=\(daddress)&directionsmode=driving")
		if (UIApplication.sharedApplication().canOpenURL(NSURL(string:"comgooglemaps://")!)) {
			UIApplication.sharedApplication().openURL(NSURL(string:
				"comgooglemaps://?saddr=&daddr=\(daddress)&directionsmode=driving")!)
		} else {
			print("Can't use comgooglemaps://");
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
            print("Sending load_serial({serial:'\(serial.number)',product_number:'\(serial.product)',input_serial:'\(input_serial)'})")
            webView!.evaluateJavaScript("load_serial({serial:'\(serial.number)',product_number:'\(serial.product)',input_serial:'\(input_serial)'})") { (result, error) in
                if error != nil {
                    print(result)
                }
            }
        }
    }
}


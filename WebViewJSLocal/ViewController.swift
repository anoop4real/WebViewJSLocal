//
//  ViewController.swift
//  WebViewJSLocal
//
//  Created by anoopm on 04/03/17.
//  Copyright © 2017 anoopm. All rights reserved.
//

import UIKit
import JavaScriptCore
class ViewController: UIViewController {

    @IBOutlet weak var myWebView:UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadWebView()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // Get the path for index.html, where in which index.html has reference to the js files, since we are loading from the proper resource path, the JS files also gets picked up properly from the resource path.
    func loadWebView(){
        
        if let resourceUrl = Bundle.main.url(forResource: "index", withExtension: "html", subdirectory: "WebDocs2"){
            let urlRequest = URLRequest.init(url: resourceUrl)
            myWebView.loadRequest(urlRequest)
        }
    }
    // Load the JS from resources
    func jsScriptText() -> String? {
        
        guard let jsPath = Bundle.main.path(forResource: "hello", ofType: "js", inDirectory: "WebDocs2/scripts") else {
            
            return nil
        }
        do
        {
            let jsScript = try String(contentsOfFile: jsPath, encoding: String.Encoding.utf8)
            return jsScript
        }catch{
            
            print("Error")
            return nil
        }
        
    }
    // Run the java script
    func runJS(){
        
        if let jsScript = jsScriptText(){
            
            let jsContext = JSContext()
            _ = jsContext?.evaluateScript(jsScript)
            let helloJSCore = jsContext?.objectForKeyedSubscript("helloJSCore")
            let result = helloJSCore?.call(withArguments: [])
            print(result?.toString() ?? "Error")

        }
    }
    
    // MARK: Webview delegates: just to track
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool{
        
        return true
    }
    func webViewDidStartLoad(_ webView: UIWebView){
        
        print("Started Loading")
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView){
        print("Finished Loading")
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error){
        
        print("Error Loading")
    }

    // MARK: Invoke JS methods from iOS    
    @IBAction func leftClicked(){
        
        myWebView.stringByEvaluatingJavaScript(from: "leftTapped()")
        
    }
    
    @IBAction func rightClicked(){
        
        myWebView.stringByEvaluatingJavaScript(from: "rightTapped()")
    }
    
    @IBAction func callJSCore(){
        
        runJS()
    }

}


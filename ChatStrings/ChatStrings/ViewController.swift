//
//  ViewController.swift
//  ChatStrings
//
//  Created by Kiran Kumar on 20/12/16.
//  Copyright © 2016 Kiran Kumar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
// Comment following messages to check the result. Also send a string in the variable "message" for testing.
    
    
    let message = "Hi Lee, can  you call me at +60175570098"
//    let message = "You can find the listing at https://www.carlist.my/used-cars/3300445/2011-toyota-vios-1-5-trd-sportivo-33-000km-full-toyota-serviced-record-like-new-11/"
//    let message = "I have another car at  http://www.example.com/listing10.htm"
    
    
    var messageString = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.

        let isNumberExists = isPhoneNumberExists(message)
        let isUrlExists = isURLExists(message)
        
        if isNumberExists == true
        {
            getMaskedStringForNumber(message, beginningWith: "+", endingWith: " ")
        }
        else if isUrlExists == true
        {
            if message.containsString("https")
            {
                getMaskedStringForURL(message, beginningWith: "https", endingWith: " ")
            }
            else
            {
                getMaskedStringForURL(message, beginningWith: "http", endingWith: " ")
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getMaskedStringForNumber(inputString : NSString, beginningWith beginString : String, endingWith endString : String)
    {
        let scanner = NSScanner(string: inputString as String)
        var text : NSString? = nil
        var resultString = inputString
        while scanner.atEnd == false
        {
            scanner.scanUpToString(beginString, intoString: nil)
            scanner.scanUpToString(endString, intoString: &text)
            if text?.length == 0
            {
                scanner.scanUpToString("", intoString: &text)
            }
            text = text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            var range = inputString.rangeOfString(text as! String) as NSRange
            let count = range.location + range.length
            
            while range.location < count {
                let tempRange = NSMakeRange(range.location, 1)
                resultString = resultString.stringByReplacingCharactersInRange(tempRange, withString: "*") as NSString
                range.location = range.location + 1
            }
            print(resultString)
            if resultString.length != 0
            {
                let arrMessages = NSMutableArray()
                arrMessages.addObject(resultString)
                let dictMessage = NSMutableDictionary()
                dictMessage.setObject(arrMessages, forKey: "message")
                print(dictMessage.description)
            }
        }
    }

    func getMaskedStringForURL(inputString : NSString, beginningWith beginString : String, endingWith endString : String)
    {
        let scanner = NSScanner(string: inputString as String)
        var text : NSString? = nil
        var resultString = inputString
        while scanner.atEnd == false
        {
            scanner.scanUpToString(beginString, intoString: nil)
            scanner.scanUpToString(endString, intoString: &text)
            if text?.length == 0
            {
                scanner.scanUpToString("", intoString: &text)
            }
            text = text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            text = text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())

            let urlString = text as! String
            let url = NSURL(string: urlString)
            let domain = url?.host
            if ((domain?.containsString("carlist.my")) == true)
            {
                messageString = message.stringByReplacingOccurrencesOfString((url?.absoluteString)!, withString: "")
                messageString = messageString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                webView.loadRequest(NSURLRequest(URL: url!))
            }
            else
            {
                var range = inputString.rangeOfString(text as! String) as NSRange
                let count = range.location + range.length
                while range.location < count {
                    let tempRange = NSMakeRange(range.location, 1)
                    resultString = resultString.stringByReplacingCharactersInRange(tempRange, withString: "*") as NSString
                    range.location = range.location + 1
                }
                print(resultString)
                if resultString.length != 0
                {
                    let arrMessages = NSMutableArray()
                    arrMessages.addObject(resultString)
                    let dictMessage = NSMutableDictionary()
                    dictMessage.setObject(arrMessages, forKey: "message")
                    print(dictMessage.description)
                }
            }
        }
    }

    func convertMessage(message : String)
    {
        let characterSet = message.rangeOfCharacterFromSet(NSCharacterSet.decimalDigitCharacterSet())
        print(characterSet?.startIndex)
        print(characterSet?.endIndex)
    }
    
    func isURLExists(message : String) -> Bool
    {
        let emailRegEx = ".*(http|https).*"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(message)
    }
    
    func isPhoneNumberExists(message:String) -> Bool
    {
        let emailRegEx = ".*\\+[0-9].*"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(message)
    }

}

extension ViewController : UIWebViewDelegate
{
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
        let dictUrl = NSMutableDictionary()
        dictUrl.setObject((webView.request?.URL?.absoluteString)!, forKey: "url")
        let dictTitle = NSMutableDictionary()
        dictTitle.setObject(webView.stringByEvaluatingJavaScriptFromString("document.title")!, forKey: "title")
        let arrLinks = NSMutableArray()
        arrLinks.addObject(dictUrl)
        arrLinks.addObject(dictTitle)

        let arrMessages = NSMutableArray()
        arrMessages.addObject(messageString)
        let dictFinalString = NSMutableDictionary()
        dictFinalString.setObject(arrMessages, forKey: "message")
        dictFinalString.setObject(arrLinks, forKey: "Links")
        print(dictFinalString.description)
    }
}


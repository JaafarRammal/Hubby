//
//  ViewController.swift
//  Hubby
//
//  Created by Jaafar Rammal on 05/02/2022.
//

import UIKit
import SwiftUI
import WebKit
import TerraSwift

//["#1F4B99", "#6B9FA1", "#FFE39F", "#D78742", "#9E2B0E"]

var progress = 100

func setFromURL(url: String){
    print("Setting from URL")
    let params = url.components(separatedBy: "?")[1]
    let paramsArr = params.components(separatedBy: "&")
    var paramsDict = ["":""]
    paramsArr.forEach { s in
        let ss = s.components(separatedBy: "=")
        paramsDict[ss[0]] = ss[1]
    }
    print(paramsDict)
    UserDefaults.standard.set(paramsDict["user_id"], forKey: "user_id")
    UserDefaults.standard.set(paramsDict["resource"], forKey: "resource")
    print(paramsDict)
    
}

func getUserID() -> String? {
    return UserDefaults.standard.string(forKey: "user_id")
}

func getResource() -> String? {
    return UserDefaults.standard.string(forKey: "resource")
}

func getTarget() -> Int {
    if(UserDefaults.standard.integer(forKey: "target") == 0){
        setTarget(target: 300)
    }
    return UserDefaults.standard.integer(forKey: "target")
}

func setTarget(target: Int) {
    UserDefaults.standard.set(target, forKey: "target")
}

class ViewController: UIViewController {

    @IBOutlet weak var fitnessScore: UILabel!
    
    // Metrics
    @IBOutlet weak var distanceView: UIView!
    @IBOutlet weak var stepView: UIView!
    @IBOutlet weak var caloriesView: UIView!
    
    // Values
    @IBOutlet weak var steps: UILabel!
    @IBOutlet weak var calories: UILabel!
    @IBOutlet weak var distance: UILabel!
    
    @IBOutlet weak var circle: ProgressCircleView!
    @IBOutlet weak var score: UILabel!
    //  Connect
    @IBOutlet weak var connectButton: UIBarButtonItem!
    @IBAction func connectTerra(_ sender: Any) {
        if(getResource() != nil){
            print("resource not NIL")
            let alert = UIAlertController(title: "New Connection", message: "You are currently connected to \(getResource()!). Would you like to disconnect and connect a new device?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Proceed", style: .destructive, handler: {_ in
                    self.performSegue(withIdentifier: "PresentWebView", sender: nil)
                }
            ))
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            print("resource NIL")
            performSegue(withIdentifier: "PresentWebView", sender: nil)
        }
    }
    
    @IBAction func changeTarget(_ sender: Any) {
        let alert = UIAlertController(title: "Daily Target", message: "Set your goal for today!", preferredStyle: .alert)

        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.text = "\(getTarget())"
        }

        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            setTarget(target:  Int(textField!.text!) ?? getTarget())
            self.circle.animateCircle()
        }))

        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        distanceView.layer.cornerRadius = 10
        stepView.layer.cornerRadius = 10
        caloriesView.layer.cornerRadius = 10
        
        distance.text = "-"
        calories.text = "-"
        steps.text = "-"
        score.text = "-"
        
        syncTerra()
        
        if(getUserID() == nil){
            performSegue(withIdentifier: "PresentWebView", sender: nil)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        syncTerra()
    }

    func syncTerra(){
        var d = 0
        var c = 0
        var s = 0
        if(getUserID() != nil){
            // Get Data
            let userid: String = getUserID()!
            let terraConnection = TerraClient(user_id: userid, dev_id: DEVID, xAPIKey: APIKEY)
            let dailyData = terraConnection.getDaily(startDate: Date().timeIntervalSince1970, endDate: Date().timeIntervalSince1970, toWebhook: false)?.data![0]
            if(dailyData?.distance_data?.steps != nil){
                s = Int(dailyData!.distance_data!.steps!)
                steps.text = "\(Int(dailyData!.distance_data!.steps!))"
            }
            if(dailyData?.distance_data?.distance_metres != nil){
                d = Int(dailyData!.distance_data!.distance_metres!)
                distance.text = "\(Int(dailyData!.distance_data!.distance_metres!)/1000) km"
            }
            if(dailyData?.calories_data?.total_burned_calories != nil){
                c = Int(dailyData!.calories_data!.total_burned_calories!)
                calories.text = "\(Int(dailyData!.calories_data!.total_burned_calories!))"
            }
            progress = s/100 + d/100 + c/10
            score.text = "\(progress)"
        }
    }

}

struct TerraWidgetSessionCreateResponse:Decodable{
    var status: String = String()
    var url: String = String()
    var session_id: String = String()
}

extension Date {
    static func todayAt12AM(date: Date) -> Date{
        return Calendar(identifier: .iso8601).startOfDay(for: date)
    }
}

func getSessionId() -> String{
    let session_url = URL(string: "https://api.tryterra.co/v2/auth/generateWidgetSession")
    var url = ""
    var request = URLRequest(url: session_url!)
    let requestData = ["reference_id": "testing", "providers" : "APPLE,GARMIN,GOOGLE,FITBIT,EIGHT,PELOTON,POLAR,ZWIFT", "language": "EN"]
    let group = DispatchGroup()
    let queue = DispatchQueue(label: "widget.Terra")
    let jsonData = try? JSONSerialization.data(withJSONObject: requestData)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue(DEVID, forHTTPHeaderField: "dev-id")
    request.setValue(APIKEY, forHTTPHeaderField: "X-API-Key")
    request.httpBody = jsonData
    let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
        if let data = data{
            let decoder = JSONDecoder()
            do{
                let result = try decoder.decode(TerraWidgetSessionCreateResponse.self, from: data)
                url = result.url
                group.leave()
            }
            catch{
                print(error)
            }
        }
    }
    group.enter()
    queue.async(group:group) {
        task.resume()
    }
    group.wait()
    return url
}

var terraClient: Terra? = nil
var userId: String = ""

class WebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    var webView: WKWebView!
    
    override func loadView() {
        super.loadView()
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: CGRect(x: 0, y: 0, width: 400, height: 400), configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view = webView
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        var myURL: URL!
        myURL = URL(string: getSessionId())
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let urlStr = navigationAction.request.url?.absoluteString {
            if(urlStr.contains("success")){
                setFromURL(url: urlStr)
            }
        }
        decisionHandler(.allow)
    }

}

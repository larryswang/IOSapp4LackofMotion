//
//  NORUARTViewController.swift
//  nRF Toolbox
//
//  Created by Mostafa Berg on 11/05/16.
//  Copyright © 2016 Nordic Semiconductor. All rights reserved.
//

import UIKit
import CoreBluetooth
import SigmaSwiftStatistics
class NORUARTViewController: UIViewController, NORBluetoothManagerDelegate, NORScannerDelegate,UITextFieldDelegate, UIPopoverPresentationControllerDelegate,NORLogger,UIWebViewDelegate{
    @IBOutlet weak var backview3: UIView!
    @IBOutlet weak var backview2: UIView!
    @IBOutlet weak var backview1: UIView!
    @IBOutlet weak var backview4: UIView!
    @IBOutlet weak var backview5: UIView!
    @IBOutlet weak var backview6: UIView!
    @IBOutlet weak var sensor3: UILabel!
    @IBOutlet weak var sensor2: UILabel!
    @IBOutlet weak var sensor1: UILabel!
    @IBOutlet weak var sensor6: UILabel!
    @IBOutlet weak var sensor5: UILabel!
    @IBOutlet weak var sensor4: UILabel!
    @IBOutlet weak var stillTime1: UILabel!
    @IBOutlet weak var stillTime2: UILabel!
    @IBOutlet weak var stillTime3: UILabel!
    @IBOutlet weak var record: UIButton!
    @IBOutlet weak var posotion: UILabel!
    @IBOutlet weak var allmotion: UILabel!
    @IBOutlet weak var K1: UITextField!
    @IBOutlet weak var K2: UITextField!
    @IBOutlet weak var K3: UITextField!
    @IBOutlet weak var K4: UITextField!
    @IBOutlet weak var K5: UITextField!
    @IBOutlet weak var K6: UITextField!
    @IBOutlet weak var SetDefaultKValue: UIButton!
    @IBOutlet weak var UpdateWeight : UIButton!
    var starrecord : Bool = false;
    var selectPeripheral: CBPeripheral!
    var motion =  Array<Float>(repeating:0.0, count: 3)
    var stillTime =  Array<Float>(repeating:0.0, count: 3)
    var getOff : Bool = false
    var HOUR :Float = 0.1
    var GET_OFF :Float = 90000
    var TURN_AROUND :Float = 10000
    var datastring :NSString!
    
    var kk1 : Float = 1
    var kk2 : Float = 1
    var kk3 : Float = 1
    var kk4 : Float = 1
    var kk5 : Float = 1
    var kk6 : Float = 1
    
    //MARK: - View Properties
    var bluetoothManager    : NORBluetoothManager?
    var uartPeripheralName  : String?
    var selectedButton      : UIButton?


    var logger              : NORLogViewController?
    var timer:Timer!
    var recoredtimer:Timer!
    var samplenumber:Int=0
    var filePath:String!
    var webViewForSelectDate111: UIWebView!
    var webViewForSelectDate222: UIWebView!
    var webViewForSelectDate333: UIWebView!
    var webViewForSelectDate444: UIWebView!
    var webViewForSelectDate555: UIWebView!
    var webViewForSelectDate666: UIWebView!
    //MARK: - View Actions
    @IBAction func setDefaultKValue(_ sender: UIButton) {
        K1.text = "1"
        K2.text = "1"
        K3.text = "1"
        K4.text = "1"
        K5.text = "1"
        K6.text = "1"
        self.kk1 = 1
        self.kk2 = 1
        self.kk3 = 1
        self.kk4 = 1
        self.kk5 = 1
        self.kk6 = 1
    }
    
    @IBAction func UpdateWeight(_ sender: UIButton){
        let temp1 = (K1.text! as NSString).floatValue
        let temp2 = (K2.text! as NSString).floatValue
        let temp3 = (K3.text! as NSString).floatValue
        let temp4 = (K4.text! as NSString).floatValue
        let temp5 = (K5.text! as NSString).floatValue
        let temp6 = (K6.text! as NSString).floatValue
        self.kk1 = temp1
        self.kk2 = temp2
        self.kk3 = temp3
        self.kk4 = temp4
        self.kk5 = temp5
        self.kk6 = temp6
    }
    
    @IBAction func connectionButtonTapped(_ sender: AnyObject) {
        bluetoothManager?.cancelPeripheralConnection()
    }

 
    @IBAction func showLogButtonTapped(_ sender: AnyObject) {
        self.revealViewController().revealToggle(animated: true)
        
        
    }

    @IBAction func resetbutton(_ sender: Any) {
        self.bluetoothManager?.cancelPeripheralConnection()
        print(self.record.isSelected)
        
        if self.record.isSelected {
            //stop record
            self.record.isSelected = !self.record.isSelected
            self.record.setTitle("RECORD", for:UIControlState.normal)
        }
        self.motion =  Array<Float>(repeating:0.0, count: 3)
        self.stillTime =  Array<Float>(repeating:0.0, count: 3)
        self.getOff  = false
        self.HOUR  = 0.1
        self.GET_OFF  = 90000
        self.TURN_AROUND  = 10000
        self.starrecord = false
        let still1 = Int(self.stillTime[0])
        let still2 = Int(self.stillTime[1])
        let still3 = Int(self.stillTime[2])
        self.stillTime1.text = "\(still1)"
        self.stillTime2.text = "\(still2)"
        self.stillTime3.text = "\(still3)"
        self.sensor1.text="0"
        self.sensor2.text="0"
        self.sensor3.text="0"
        self.sensor4.text="0"
        self.sensor5.text="0"
        self.sensor6.text="0"
    }
    func reset() {
        self.bluetoothManager?.cancelPeripheralConnection()
        if self.record.isSelected {
            //stop record
            self.record.isSelected = !self.record.isSelected
            self.record.setTitle("RECORD", for:UIControlState.normal)
        }
        self.motion =  Array<Float>(repeating:0.0, count: 3)
        self.stillTime =  Array<Float>(repeating:0.0, count: 3)
        self.getOff  = false
        self.HOUR  = 0.1
        self.GET_OFF  = 90000
        self.TURN_AROUND  = 10000
        self.starrecord = false
        let still1 = Int(self.stillTime[0])
        let still2 = Int(self.stillTime[1])
        let still3 = Int(self.stillTime[2])
        self.stillTime1.text = "\(still1)"
        self.stillTime2.text = "\(still2)"
        self.stillTime3.text = "\(still3)"
        self.sensor1.text="0"
        self.sensor2.text="0"
        self.sensor3.text="0"
        self.sensor4.text="0"
        self.sensor5.text="0"
        self.sensor6.text="0"
    }
    
   
    //MARK: - View Outlets

    @IBOutlet weak var deviceName: UILabel!
   
    @IBOutlet weak var connectionButton: UIButton!
    //MARK: -NORLogger Protocol
    func log(level aLevel: NORLOGLevel, message aMessage: String) {
        print("test\(aMessage)")
        if(aMessage.contains("#")){
            var strArray = [" ", " ", " ", " ", " ", " "]
            let start1 = aMessage.index(aMessage.startIndex, offsetBy: 1)
            let end1 = aMessage.index(aMessage.startIndex, offsetBy: 4)
            let range1 = start1..<end1
            let mySubstring1 = aMessage[range1]  // play
            strArray[0] = mySubstring1
            
            let start2 = aMessage.index(aMessage.startIndex, offsetBy: 4)
            let end2 = aMessage.index(aMessage.startIndex, offsetBy: 7)
            let range2 = start2..<end2
            let mySubstring2 = aMessage[range2]  // play
            strArray[1] = mySubstring2
            
            let start3 = aMessage.index(aMessage.startIndex, offsetBy: 7)
            let end3 = aMessage.index(aMessage.startIndex, offsetBy: 10)
            let range3 = start3..<end3
            let mySubstring3 = aMessage[range3]  // play
            strArray[2] = mySubstring3
            
            let start4 = aMessage.index(aMessage.startIndex, offsetBy: 10)
            let end4 = aMessage.index(aMessage.startIndex, offsetBy: 13)
            let range4 = start4..<end4
            let mySubstring4 = aMessage[range4]  // play
            strArray[3] = mySubstring4
            
            let start5 = aMessage.index(aMessage.startIndex, offsetBy: 13)
            let end5 = aMessage.index(aMessage.startIndex, offsetBy: 16)
            let range5 = start5..<end5
            let mySubstring5 = aMessage[range5]  // play
            strArray[4] = mySubstring5
            
            let start6 = aMessage.index(aMessage.startIndex, offsetBy: 16)
            let end6 = aMessage.index(aMessage.startIndex, offsetBy: 19)
            let range6 = start6..<end6
            let mySubstring6 = aMessage[range6]  // play
            strArray[5] = mySubstring6

            print("\(strArray)")
      

                self.updateData(float: strArray)
 
         
        }
    }


    //MARK: - UIViewControllerDelegate
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
 
    
  
    @IBAction func detectMotion(_ sender: Any) {
        weak var weakSelf = self
        if (bluetoothManager == nil){
            if(bluetoothManager == nil){
                let alertController = UIAlertController(title: nil,
                                                        message: "Bluetooth not connected", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: {
                    action in
                    
                })
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }else{
            
            let alertController = UIAlertController(title: nil,
                                                    message: "Please calibrate first!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: {
                action in
            
            })
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            }
        }else{
            if(sender as! UIButton).isSelected{
                //stop record
                self.starrecord = false
            (sender as! UIButton).isSelected = !(sender as! UIButton).isSelected
            (sender as! UIButton).setTitle("RECORD", for:UIControlState.normal)
            }else{
            //点击ok之后开始记录 点取消没反应
                
            let alertController = UIAlertController(title: "Create document name",
                                                    message: nil, preferredStyle: .alert)
            alertController.addTextField {
                (textField: UITextField!) -> Void in
                textField.placeholder = "document name"
                let now = Date()
                let outputFormatter = DateFormatter()
                outputFormatter.dateFormat = "yyyyMMdd:HH:mm:ss.SSS"
                let timeString = outputFormatter.string(from: now)
                textField.text=timeString
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: {
                action in
                //也可以用下标的形式获取textField let login = alertController.textFields![0]
                
                (sender as! UIButton).setTitle("STOP", for:UIControlState.normal)
                let login:NSString = alertController.textFields!.first!.text! as NSString
                print("用户名：\( login) ")
                self.filePath="\( login).txt"
                

                
                print(self.filePath)
                weakSelf?.starrecord = true

            })
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            (sender as! UIButton).isSelected = !(sender as! UIButton).isSelected
            self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    func ceshidemo() {
        let fileManager = FileManager.default
        let filePath1:String = NSHomeDirectory() + "/Documents/\(self.filePath as String)"
        var exist = fileManager.fileExists(atPath: filePath1)
        let ceshistring="record\n"
        exist = !exist
        
        if exist{
            try! ceshistring.write(toFile: filePath1, atomically: true, encoding: String.Encoding.utf8)
            print(filePath1)
            
        }
        let now = Date()
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "HH:mm:ss.SSS"
        let timeString = outputFormatter.string(from: now)
        let info  = "\(timeString)bluetoothdata \(String(describing: self.sensor1.text)) \(String(describing: self.sensor2.text)) \(String(describing: self.sensor3.text)) \(String(describing: self.sensor4.text)) \(String(describing: self.sensor5.text)) \(String(describing: self.sensor6.text))\n "
        let manager = FileManager.default
        let urlsForDocDirectory = manager.urls(for:.documentDirectory, in:.userDomainMask)
        let docPath = urlsForDocDirectory[0]
        let file = docPath.appendingPathComponent(self.filePath)
        print(file)
        
        let appendedData = info.data(using: String.Encoding.utf8, allowLossyConversion: true)
        let fileHandle :FileHandle = FileHandle(forWritingAtPath: filePath1)!
        fileHandle.seekToEndOfFile()
        fileHandle.write(appendedData!)
        fileHandle.closeFile()
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        K1.delegate = self
        K2.delegate = self
        K3.delegate = self
        K4.delegate = self
        K5.delegate = self
        K6.delegate = self
        let revealViewController = self.revealViewController()
        if revealViewController != nil {
            self.view.addGestureRecognizer((revealViewController?.panGestureRecognizer())!)
            logger = revealViewController?.rearViewController as? NORLogViewController
        }
        
        webViewForSelectDate111=UIWebView.init(frame:CGRect(x:0, y: 0, width: self.backview1.frame.size.width , height: self.backview1.frame.size.height) )
           webViewForSelectDate111!.backgroundColor=UIColor.red
        self.backview1.addSubview(webViewForSelectDate111)
        let htmlPath:NSString = Bundle.main.path(forResource: "source.bundle/index", ofType: "html")! as NSString
        let urlStr = URL(fileURLWithPath: htmlPath as String)
        webViewForSelectDate111.loadRequest(URLRequest(url:urlStr))
        webViewForSelectDate111!.scalesPageToFit = true;
        webViewForSelectDate111!.autoresizingMask = [.flexibleHeight ,.flexibleWidth]
        
        webViewForSelectDate222=UIWebView.init(frame:CGRect(x:0, y:0, width: self.backview2.frame.size.width , height: self.backview2.frame.size.height) )
        webViewForSelectDate222!.backgroundColor=UIColor.red
        self.backview2.addSubview(webViewForSelectDate222)
        let htmlPath222:NSString = Bundle.main.path(forResource: "source.bundle/index", ofType: "html")! as NSString
        let urlStr222 = URL(fileURLWithPath: htmlPath222 as String)
        webViewForSelectDate222.loadRequest(URLRequest(url:urlStr222))
        webViewForSelectDate222!.scalesPageToFit = true;
        webViewForSelectDate222!.autoresizingMask = [.flexibleHeight ,.flexibleWidth]
        
        webViewForSelectDate333=UIWebView.init(frame:CGRect(x:0, y:0, width: self.backview3.frame.size.width , height: self.backview3.frame.size.height) )
        webViewForSelectDate333!.backgroundColor=UIColor.red
        self.backview3.addSubview(webViewForSelectDate333)
        let htmlPath333:NSString = Bundle.main.path(forResource: "source.bundle/index", ofType: "html")! as NSString
        let urlStr333 = URL(fileURLWithPath: htmlPath333 as String)
        webViewForSelectDate333.loadRequest(URLRequest(url:urlStr333))
        webViewForSelectDate333!.scalesPageToFit = true;
        webViewForSelectDate333!.autoresizingMask = [.flexibleHeight ,.flexibleWidth]
        
        webViewForSelectDate444=UIWebView.init(frame:CGRect(x:0, y:0, width: self.backview4.frame.size.width , height: self.backview4.frame.size.height) )
        webViewForSelectDate444!.backgroundColor=UIColor.red
        self.backview4.addSubview(webViewForSelectDate444)
        let htmlPath444:NSString = Bundle.main.path(forResource: "source.bundle/index", ofType: "html")! as NSString
        let urlStr444 = URL(fileURLWithPath: htmlPath444 as String)
        webViewForSelectDate444.loadRequest(URLRequest(url:urlStr444))
        webViewForSelectDate444!.scalesPageToFit = true;
        webViewForSelectDate444!.autoresizingMask = [.flexibleHeight ,.flexibleWidth]
        
        webViewForSelectDate555=UIWebView.init(frame:CGRect(x:0, y:0, width: self.backview5.frame.size.width , height: self.backview5.frame.size.height) )
        webViewForSelectDate555!.backgroundColor=UIColor.red
        self.backview5.addSubview(webViewForSelectDate555)
        let htmlPath555:NSString = Bundle.main.path(forResource: "source.bundle/index", ofType: "html")! as NSString
        let urlStr555 = URL(fileURLWithPath: htmlPath555 as String)
        webViewForSelectDate555.loadRequest(URLRequest(url:urlStr555))
        webViewForSelectDate555!.scalesPageToFit = true;
        webViewForSelectDate555!.autoresizingMask = [.flexibleHeight ,.flexibleWidth]
        
        webViewForSelectDate666=UIWebView.init(frame:CGRect(x:0, y:0, width: self.backview6.frame.size.width , height: self.backview6.frame.size.height) )
        webViewForSelectDate666!.backgroundColor=UIColor.red
        self.backview6.addSubview(webViewForSelectDate666)
        let htmlPath666:NSString = Bundle.main.path(forResource: "source.bundle/index", ofType: "html")! as NSString
        let urlStr666 = URL(fileURLWithPath: htmlPath666 as String)
        webViewForSelectDate666.loadRequest(URLRequest(url:urlStr666))
        webViewForSelectDate666!.scalesPageToFit = true;
        webViewForSelectDate666!.autoresizingMask = [.flexibleHeight ,.flexibleWidth]
        
        let still1 = Int(self.stillTime[0])
        let still2 = Int(self.stillTime[1])
        let still3 = Int(self.stillTime[2])
        self.stillTime1.text = "\(still1)"
        self.stillTime2.text = "\(still2)"
        self.stillTime3.text = "\(still3)"

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    
    //MARK: - Segue methods
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        // The 'scan' seque will be performed only if bluetoothManager == nil (if we are not connected already).
        return identifier != "scan" || self.bluetoothManager == nil
    }
    func updateData(float:Array<String>)
    {
    //取得当前时间，x轴
        let now = Date()
        let timeInterval:TimeInterval = now.timeIntervalSince1970
        let timeStamp = timeInterval * 1000
        var jsstr1  = (float[0] as NSString).floatValue
        jsstr1 = jsstr1 * kk1
        var jsstr2 = (float[1] as NSString).floatValue
        jsstr2 = jsstr2 * kk2
        var jsstr3  = (float[2] as NSString).floatValue
        jsstr3 = jsstr3 * kk3
        var jsstr4  = (float[3] as NSString).floatValue
        jsstr4 = jsstr4 * kk4
        var jsstr5 = (float[4] as NSString).floatValue
        jsstr5 = jsstr5 * kk5
        var jsstr6  = (float[5] as NSString).floatValue
        jsstr6 = jsstr6 * kk6
        
        let jsStr111:NSMutableString = ""
        jsStr111.append("updateData(\(timeStamp),\(jsstr1))")
        print(jsStr111)
        let jsStr222:NSMutableString = ""
        jsStr222.append("updateData(\(timeStamp),\(jsstr2))")
        print(jsStr222)
        let jsStr333:NSMutableString = ""
        jsStr333.append("updateData(\(timeStamp),\(jsstr3))")
        print(jsStr333)
        let jsStr444:NSMutableString = ""
        jsStr444.append("updateData(\(timeStamp),\(jsstr4))")
        print(jsStr444)
        let jsStr555:NSMutableString = ""
        jsStr555.append("updateData(\(timeStamp),\(jsstr5))")
        print(jsStr555)
        let jsStr666:NSMutableString = ""
        jsStr666.append("updateData(\(timeStamp),\(jsstr6))")
        print(jsStr666)
        
       
        for i in 0...2
        {
            if (self.motion[i] > self.GET_OFF)
            {
                self.getOff = true
                // self.reset()
                
            }
            else if (self.motion[i] > self.TURN_AROUND)
            {
                self.stillTime[i] = 0;
            }
            else if (self.motion[i] > 1000)
            {
                self.stillTime[i] = self.stillTime[i] * pow((self.TURN_AROUND - self.motion[i])/self.TURN_AROUND,0.5);
            }
            else
            {
                self.stillTime[i] += 1
            }
            
/*            if (self.stillTime[i] > 3600*self.HOUR)
            {
                self.callAlert[i] = true;
            }
            else
            {
                self.alert [i] = self.stillTime[i]/(3600*self.HOUR);
            }
 */
        }
        if self.starrecord {
            self.ceshidemo()
        }
        DispatchQueue.main.async(execute: {
            self.webViewForSelectDate222.stringByEvaluatingJavaScript(from: jsStr222 as String)
            self.webViewForSelectDate333.stringByEvaluatingJavaScript(from: jsStr333 as String)
            self.webViewForSelectDate111.stringByEvaluatingJavaScript(from: jsStr111 as String)
            self.webViewForSelectDate444.stringByEvaluatingJavaScript(from: jsStr444 as String)
            self.webViewForSelectDate555.stringByEvaluatingJavaScript(from: jsStr555 as String)
            self.webViewForSelectDate666.stringByEvaluatingJavaScript(from: jsStr666 as String)
            let still1 = Int(self.stillTime[0])
            let still2 = Int(self.stillTime[1])
            let still3 = Int(self.stillTime[2])
            self.stillTime1.text = "\(still1)"
            self.stillTime2.text = "\(still2)"
            self.stillTime3.text = "\(still3)"
            var tt1 = (float[0] as NSString).floatValue
            tt1 = tt1 * self.kk1
            self.sensor1.text = "\(tt1)"
            
            var tt2 = (float[1] as NSString).floatValue
            tt2 = tt2 * self.kk2
            self.sensor2.text = "\(tt2)"
            
            var tt3 = (float[2] as NSString).floatValue
            tt3 = tt3 * self.kk3
            self.sensor3.text = "\(tt3)"
            
            var tt4 = (float[3] as NSString).floatValue
            tt4 = tt4 * self.kk4
            self.sensor4.text = "\(tt4)"
            
            var tt5 = (float[4] as NSString).floatValue
            tt5 = tt5 * self.kk5
            self.sensor5.text = "\(tt5)"
            
            var tt6 = (float[5] as NSString).floatValue
            tt6 = tt6 * self.kk6
            self.sensor6.text = "\(tt6)"
            

            self.motion[0]=(float[1] as NSString).floatValue
            self.motion[1]=(float[2] as NSString).floatValue
            self.motion[2]=(float[3] as NSString).floatValue
        })

    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        let height : NSInteger = NSInteger((webView.stringByEvaluatingJavaScript(from: "document.body.offsetHeight;")! as NSString).intValue)
        
        let javascript : NSString  = "window.scrollBy(0,\(height))" as NSString
        webView.stringByEvaluatingJavaScript(from: "\(javascript)")
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "scan" else {
            return
        }
        
        // Set this contoller as scanner delegate
        let nc = segue.destination as! UINavigationController
        let controller = nc.childViewControllerForStatusBarHidden as! NORScannerViewController
        // controller.filterUUID = CBUUID.init(string: NORServiceIdentifiers.uartServiceUUIDString)
        controller.delegate = self
    }
    
    //MARK: - UIPopoverPresentationCtonrollerDelegate
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    //MARK: - NORScannerViewDelegate
    func centralManagerDidSelectPeripheral(withManager aManager: CBCentralManager, andPeripheral aPeripheral: CBPeripheral) {
        // We may not use more than one Central Manager instance. Let's just take the one returned from Scanner View Controller
        bluetoothManager = NORBluetoothManager(withManager: aManager)
        bluetoothManager!.delegate = self
        bluetoothManager!.logger = self
        bluetoothManager!.logger1 = logger
        logger!.clearLog()
        self.selectPeripheral = aPeripheral
        if let name = aPeripheral.name {
            self.uartPeripheralName = name
            self.deviceName.text = name
        } else {
            self.uartPeripheralName = "device"
            self.deviceName.text = "No name"
        }
        self.connectionButton.setTitle("CANCEL", for: UIControlState())
        bluetoothManager!.connectPeripheral(peripheral: aPeripheral)
    }
    
    //MARK: - BluetoothManagerDelegate
    func peripheralReady() {
        print("Peripheral is ready")
    }
    
    func peripheralNotSupported() {
        print("Peripheral is not supported")
    }
    
    func didConnectPeripheral(deviceName aName: String?) {
        // Scanner uses other queue to send events. We must edit UI in the main queue
        DispatchQueue.main.async(execute: {
            self.logger!.bluetoothManager = self.bluetoothManager
            self.connectionButton.setTitle("DISCONNECT", for: UIControlState())
        })
        
        //Following if condition display user permission alert for background notification
        if UIApplication.instancesRespond(to: #selector(UIApplication.registerUserNotificationSettings(_:))){
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert], categories: nil))
        }

        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationDidEnterBackgroundCallback), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationDidBecomeActiveCallback), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }

    func didDisconnectPeripheral() {
            // Scanner uses other queue to send events. We must edit UI in the main queue
            DispatchQueue.main.async(execute: {
                self.logger!.bluetoothManager = nil
                self.connectionButton.setTitle("CONNECT", for: UIControlState())
                self.deviceName.text = "DEFAULT UART"
                
                if NORAppUtilities.isApplicationInactive() {
                    NORAppUtilities.showBackgroundNotification(message: "Peripheral \(self.uartPeripheralName!) is disconnected")
                }

                self.uartPeripheralName = nil
            })
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        bluetoothManager = nil
    }

   
    
   

    func applicationDidEnterBackgroundCallback(){
        NORAppUtilities.showBackgroundNotification(message: "You are still connected to \(self.uartPeripheralName!)")
    }
    
    func applicationDidBecomeActiveCallback(){
        UIApplication.shared.cancelAllLocalNotifications()
    }
    
    //MARK: - UART API
    func send(value aValue : String) {
        if self.bluetoothManager != nil {
            bluetoothManager?.send(text: aValue)
        }
    }
}

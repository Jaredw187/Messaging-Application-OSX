//
//  ViewController.swift
//  Messaging Application OSX
//
//  Created by Jared Walton on 6/5/16.
//  Copyright © 2016 Jared Walton. All rights reserved.
//

import Cocoa

var chatRoom: String = "r"
var userName: String = "Jared"

class ViewController: NSViewController {
    
    // data
    var input: String = " "
    var newView: String = " "
    var message: String = " "

    let socket = SocketIOClient(socketURL: NSURL(string: "http://127.0.0.1:5000")!, options: [.Log(true), .ForcePolling(true)])
    
    func addHandlers() {
        
        socket.on("connect") {data, ack in
            print("connected")
            self.socket.emit("join", ["room":chatRoom])
        }
        socket.on("newMessage") { data, ack in
            print("got it")
            self.recieveMessage(String(data[0]))
        }
        socket.connect()
    }
    
    @IBAction func getMessage(sender: AnyObject) {
        message = userName + ": " + textInput.stringValue
        textInput.stringValue = ""
        socket.emit("newMessage", ["message":message, "room":chatRoom])
        
    }
    
    func recieveMessage(msg: String) {
        print("appending")
        messageField?.stringValue = (messageField?.stringValue)! + msg + "\n"
        //messageField?.textStorage?.appendAttributedString(NSAttributedString(string: msg + "\n"))
        //messageField?.moveTextUp()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addHandlers()
        chatLabel?.stringValue = "Chat Room: " + chatRoom
        nameLabel?.stringValue = "User Name: " + userName
        // Do any additional setup after loading the view.
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBOutlet var messageField: NSTextField!
    @IBOutlet var nameLabel: NSTextField!
    @IBOutlet var chatLabel: NSTextField!
    @IBOutlet var textInput: NSTextField!
    

}


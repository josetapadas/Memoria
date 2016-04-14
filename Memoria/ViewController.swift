//
//  ViewController.swift
//  Memoria
//
//  Created by José Alves on 13/04/16.
//  Copyright © 2016 José Alves. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
        setupButtons()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupButtons() {
        view.backgroundColor = UIColor.whiteColor()
        
        buildBUttonWithCenter(CGPoint(x: view.center.x, y: view.center.y / 2.0), title: "Apprentice", color: UIColor.greenColor(), action: #selector(ViewController.onApprenticeClick))
        
        buildBUttonWithCenter(CGPoint(x: view.center.x, y: view.center.y), title: "Regular", color: UIColor.yellowColor(), action: #selector(ViewController.onRegularClick))
        
        buildBUttonWithCenter(CGPoint(x: view.center.x, y: view.center.y + view.center.y / 2.0), title: "Master", color: UIColor.redColor(), action: #selector(ViewController.onMasterClick))
        
    }
}


// Creating Buttons
private extension ViewController {
    func buildBUttonWithCenter(center: CGPoint, title: String, color: UIColor, action: Selector) {
        let button = UIButton()
        
        button.setTitle(title, forState: .Normal)
        button.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 200, height: 50))
        button.center = center
        button.backgroundColor = color
        button.addTarget(self, action: action, forControlEvents: UIControlEvents.TouchUpInside)
        
        view.addSubview(button)
    }
    
    @objc func onApprenticeClick(sender: UIButton) {
        setNewGameLevel(.Apprentice)
    }
    
    @objc func onRegularClick(sender: UIButton) {
        setNewGameLevel(.Regular);
    }
    
    @objc func onMasterClick(sender: UIButton) {
        setNewGameLevel(.Master);
    }
}

private extension ViewController {
    enum Level {
        case Apprentice, Regular, Master
    }
    
    func setNewGameLevel(level: Level) {
        switch level {
        case .Apprentice:
            NSLog("Apprentice");
        case .Regular:
            NSLog("Regular!")
        case .Master:
            NSLog("Master!")
        }
    }
}

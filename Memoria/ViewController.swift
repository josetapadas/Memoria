//
//  ViewController.swift
//  Memoria
//
//  Created by José Alves on 13/04/16.
//  Copyright © 2016 José Alves. All rights reserved.
//

import UIKit

enum Level {
    case Apprentice, Regular, Master
}

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
        view.backgroundColor = UIColor.darkBlue()
        
        buildBUttonWithCenter(CGPoint(x: view.center.x, y: view.center.y / 2.0), title: "Apprentice", color: UIColor.darkWhite(), action: #selector(ViewController.onApprenticeClick))
        
        buildBUttonWithCenter(CGPoint(x: view.center.x, y: view.center.y), title: "Regular", color: UIColor.darkGray(), action: #selector(ViewController.onRegularClick))
        
        buildBUttonWithCenter(CGPoint(x: view.center.x, y: view.center.y + view.center.y / 2.0), title: "Master", color: UIColor.blackColor(), action: #selector(ViewController.onMasterClick))
        
    }
}


// Creating Buttons
extension ViewController {
    func buildBUttonWithCenter(center: CGPoint, title: String, color: UIColor, action: Selector) {
        let button = UIButton()
        
        button.setTitle(title, forState: .Normal)
        button.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 200, height: 50))
        button.center = center
        button.backgroundColor = color
        button.addTarget(self, action: action, forControlEvents: UIControlEvents.TouchUpInside)
        
        view.addSubview(button)
    }
    
    func onApprenticeClick(sender: UIButton) {
        setNewGameLevel(.Apprentice)
    }
    
    func onRegularClick(sender: UIButton) {
        setNewGameLevel(.Regular);
    }
    
    func onMasterClick(sender: UIButton) {
        setNewGameLevel(.Master);
    }
}

private extension ViewController {
    func setNewGameLevel(level: Level) {
        let mainGameViewController = MemoriaViewController(level: level)
        
        presentViewController(mainGameViewController, animated: true, completion: nil)
    }
}

private extension UIColor {
    class func getColorFromRGBComponents(components: (CGFloat, CGFloat, CGFloat)) -> UIColor {
        return UIColor(red: components.0/255, green: components.1/255, blue: components.2/255, alpha: 1)
    }
}

extension UIColor {
    class func darkBlue() -> UIColor {
        return UIColor.getColorFromRGBComponents((44, 62, 80))
    }
    class func darkGray() -> UIColor {
        return UIColor.getColorFromRGBComponents((127, 140, 141))
    }
    class func darkWhite() -> UIColor {
        return UIColor.getColorFromRGBComponents((189, 195, 199))
    }
    class func darkGold() -> UIColor {
        return UIColor.getColorFromRGBComponents((241, 196, 15))
    }
}


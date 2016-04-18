//
//  MemoriaViewController.swift
//  Memoria
//
//  Created by José Tapadas Alves on 16/04/16.
//  Copyright © 2016 José Alves. All rights reserved.
//

import Foundation
import UIKit

class MemoriaViewController : UIViewController {
    private let level : Level
    private var collectionView : UICollectionView!
    private var deck : Array<Int>!
    
    init(level: Level) {
        self.level = level
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        NSLog("init?(aDecoder) not implemented")
        fatalError()
    }
    
    deinit {
        NSLog("destroying MemoriaViewController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        start()
    }
    
    func start() {
        deck = Array<Int>(count: numberOfCarsByLevel(level), repeatedValue: 1)
        collectionView.reloadData()
    }
}

// MARK: Setup View
private extension MemoriaViewController {
    func setup() {
        var color = UIColor.blackColor()
        
        switch level {
        case .Apprentice:
            color = UIColor.darkWhite()
        case .Regular:
            color = UIColor.darkGray()
        case .Master:
            color = UIColor.blackColor()
        }
        
        view.backgroundColor = color
        
        let space: CGFloat = 10
        
        let (covWidth, covHeight) = collectionViewSizeByLevel(level, space: space)
        
        let layout = cardsLayoutSize(cardSizeByLevel(level, space: space), space: space)
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: covWidth, height: covHeight), collectionViewLayout: layout)
        
        collectionView.center = view.center
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.scrollEnabled = false
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "cardCell")
        collectionView.backgroundColor = UIColor.clearColor()
        
        self.view.addSubview(collectionView)
    }
    
    func collectionViewSizeByLevel(level: Level, space: CGFloat) -> (CGFloat, CGFloat) {
        let (columns, rows) = sizeByLevel(level)
        let (cardWidth, cardHeight) = cardSizeByLevel(level, space: space)
        
        let covWidth = CGFloat(columns) * (cardWidth + 2 * space)
        let covHeight = CGFloat(rows) * (cardHeight + space)
        
        return (covWidth, covHeight)
    }
    
    func cardsLayoutSize(cardSize: (cardWidth: CGFloat, cardHeight: CGFloat), space: CGFloat) -> UICollectionViewLayout {
        let layout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        layout.sectionInset = UIEdgeInsets(top: space, left: space, bottom: space, right: space)
        layout.itemSize = CGSize(width: cardSize.cardWidth, height: cardSize.cardHeight)
        layout.minimumLineSpacing = space
        
        return layout
    }
    
    func cardSizeByLevel(level: Level, space: CGFloat) -> (CGFloat, CGFloat) {
        let (columns, rows) = sizeByLevel(level)
        
        let cardHeight: CGFloat = view.frame.height / CGFloat(rows) - 2 * space
        let cardWidth: CGFloat = view.frame.width / CGFloat(columns) - 2 * space
        
        return (cardWidth, cardHeight)
    }
    
    func sizeByLevel(level: Level)  -> (Int, Int) {
        switch level {
        case .Apprentice:
            return (4, 3)
        case .Regular:
            return (6, 4)
        case .Master:
            return (8, 4)
        }
    }
    
    func numberOfCarsByLevel(level: Level) -> Int {
        let (columns, rows) = sizeByLevel(level)
        
        return columns * rows
    }
}

// MARK: UICollectionViewDataSource

extension MemoriaViewController : UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection: Int) -> Int {
        return deck.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath : NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cardCell", forIndexPath: indexPath)
        
        cell.backgroundColor = UIColor.darkGold()
        return cell
    }
}

extension MemoriaViewController : UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectRowAtIndexPath indexPath : NSIndexPath) {
        NSLog("Clicked a card!")
    }
}



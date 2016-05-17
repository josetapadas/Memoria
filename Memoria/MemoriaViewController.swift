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
    private var deck : Deck!
    
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
        deck = createDeck(numberOfCarsByLevel(level))
        
        for i in 0..<deck.count {
            NSLog("The card at index \(i) is \(deck[i].description)")
        }
        
        collectionView.reloadData()
    }
}

// MARK: Deck setup
func createDeck(numCards: Int) -> Deck {
    let fullDeck = Deck.full().shuffled()
    let halfDeck = fullDeck.deckOfNUmberOfCards(numCards/2)
    return (halfDeck + halfDeck).shuffled()
}

enum Suit: CustomStringConvertible {
    case Spades, Hearts, Diamonds, Clubs
    var description: String {
        switch self {
        case .Spades:
            return "spades"
        case .Hearts:
            return "hearts"
        case .Diamonds:
            return "diamonds"
        case .Clubs:
            return "clubs"
        }
    }
}

// we'll use the Int protocol so we can use the rawValue
enum Rank: Int, CustomStringConvertible {
    case Ace = 1
    case Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten
    case Jack, Queen, King
    
    var description: String {
        switch self {
        case .Ace:
            return "ace"
        case .Jack:
            return "jack"
        case .Queen:
            return "queen"
        case .King:
            return "king"
        default:
            return String(self.rawValue)
        }
    }
}

struct Card: CustomStringConvertible, Equatable {
    private let rank: Rank
    private let suit: Suit
    
    var description: String {
        return "\(rank.description)_of_\(suit.description)"
    }
}

func ==(card1: Card, card2: Card) -> Bool {
    return card1.rank == card2.rank && card1.suit == card2.suit
}

func +(deck1: Deck, deck2: Deck) -> Deck {
    return Deck(cards: deck1.cards + deck2.cards)
}

struct Deck {
    private var cards = [Card]()
    
    var count : Int {
        get {
            return cards.count
        }
    }
    
    subscript(index: Int) -> Card {
        get {
            return cards[index]
        }
    }
    
    static func full() -> Deck {
        var deck = Deck()
        
        for i in Rank.Ace.rawValue...Rank.King.rawValue {
            for suit in [Suit.Spades, Suit.Hearts, Suit.Clubs, Suit.Diamonds] {
                let card = Card(rank: Rank(rawValue: i)!, suit: suit)
                
                deck.cards.append(card)
            }
        }
        
        return deck
    }
    
    // http://en.wikipedia.org/wiki/Fisher–Yates_shuffle.
    func shuffled() -> Deck {
        var list = cards
        
        for i in 0..<(list.count - 1) {
            let j = Int(arc4random_uniform(UInt32(list.count - i))) + i
            
            if(j != i) {
                swap(&list[i], &list[j])
            }
        }
        
        return Deck(cards: list)
    }
    
    func deckOfNUmberOfCards(num: Int) -> Deck {
        return Deck(cards: Array(cards[0..<num]))
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



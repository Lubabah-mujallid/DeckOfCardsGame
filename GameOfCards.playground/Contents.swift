import UIKit

struct Card {
   var color: String
   var roll: Int
    init(roll: Int){
        self.roll = roll
        switch self.roll {
        case 1...2: color = "Blue"
        case 3...4: color = "Red"
        case 5...6: color = "Green"
        default: color = "undefined"
        }
    }
}

class Deck {
    var cards: [Card] = []
    init() {
        for _ in 1...10{
            cards.append(Card(roll: Int.random(in: 1...2)))
            cards.append(Card(roll: Int.random(in: 3...4)))
            cards.append(Card(roll: Int.random(in: 5...6)))
        }
    }
    func deal() -> Card {
        return cards.removeLast()
    }
    func isEmpty() -> Bool {
        return cards.isEmpty
    }
    func shuffle() {
        cards.shuffle()
    }
}

class Player {
    var name: String
    var coins = 0 //todo
    var hand: [Card] = []
    init(name: String) {
        self.name = name
    }
    func draw(deck: Deck) -> Card{
        let card = deck.deal()
        hand.append(card)
        return card
    }
    func rollDice() -> Int {
        return Int.random(in: 1...6)
    }
    func matchingCards(color: String, roll: Int) -> Int {
        var count = 0
        for card in hand {
            if card.color == color && card.roll == roll {
                count += 1
            }
        }
        return count
    }
}

class Game {
    var players: [Player] = []
    var deck: Deck = Deck()
    var turnIdx: Int = 0
    init() {
        players.append(Player(name: "Mike"))
        players.append(Player(name: "Sydney"))
        players.append(Player(name: "Blake"))
        players.append(Player(name: "Tiffany"))
        deck.shuffle()
    }
    func playGame() {
        while !deck.isEmpty() {
            takeTurn(player: players[turnIdx])
            turnIdx += 1
            if turnIdx == 4 {
                turnIdx = 0
            }
        }
        announceWinner()
    }
    func takeTurn(player: Player) {
        let roll = player.rollDice()
        player.coins += 2 * player.matchingCards(color: "Green", roll: roll)
        for p in players {
            p.coins += p.matchingCards(color: "Blue", roll: roll)
            let redMatches = p.matchingCards(color: "Red", roll: roll)
            if redMatches>0 && p.name != player.name && player.coins>0 {
                if player.coins >= redMatches {
                    p.coins += redMatches
                    player.coins -= redMatches
                }
                else {
                    player.coins -= redMatches
                    let temp = player.coins
                    player.coins = 0
                    p.coins += (redMatches+temp)
                }
            }
        }
        player.draw(deck: deck)
    }
    func announceWinner(){
        var winner:Player = Player(name: "")
        for p in players {
            if winner.coins < p.coins {
                winner = p
            }
        }
        print("The Winner is: \(winner.name)")
    }
}

let game = Game()
game.playGame()

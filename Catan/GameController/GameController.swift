//
//  GameController.swift
//  Catan
//
//  Created by Ion Plamadeala on 15/06/2023.
//

import Foundation
import SpriteKit


class Player {
    var color: SKColor
    
    init(_ color: SKColor) {
        self.color = color
    }
}

enum GameState {
    case gameSetup(player: Player)
    case playerTurn(player: Player)
}

class GameController {
    var map: Map
    var state: GameState
    var playerList: [Player]
    var setupIterator : any IteratorProtocol<Player>
    
    
    init(map: Map) {
        self.map = map
        self.map.showGuides()
        self.playerList = [
            Player(ColorScheme.color1),
            Player(ColorScheme.color2),
            Player(ColorScheme.color3),
            Player(ColorScheme.color4)
        ]
        self.setupIterator = [
            playerList[0],
            playerList[1],
            playerList[2],
            playerList[3],
            playerList[3],
            playerList[2],
            playerList[1],
            playerList[0],
        ].makeIterator()
        self.state = .gameSetup(player: setupIterator.next()!)
    }
    
    func handleCornerClick(corner: HexCorner) {
        switch state {
        case .gameSetup(let player):
            if corner.guide {
                corner.building = Building(color: player.color, size: map.radius)
                map.hideGuides()
                corner.neighbourRoads.forEach {$0.guide = true}
            }
            
        case .playerTurn(let player):
            return
        }
    }
    
    func handleEdgeClick(edge: HexEdge) {
        switch state {
        case .gameSetup(let player):
            if edge.guide {
                edge.road = Road(color: player.color, size: map.radius)
                if let nextPlayer = self.setupIterator.next(){
                    state = .gameSetup(player: nextPlayer)
                    map.showGuides()
                } else {
                    state = .playerTurn(player: playerList[0])
                }
                map.hideRoadGuides()
            }
        case .playerTurn(player: let player):
            return
        }
    }
    
}

//Zack's playground for Episode 2 - Protocols.


import UIKit

var fighting = true

//Top level design.  Most abstract, these traits are for everybody.
protocol Character {
    
    var health: Int { get set }
    var name: String { get }
    var strength: Int { get set }
    var intelligence: Int { get set }
    
    mutating func attack<T: Character>(_ opponent: inout T)
    mutating func die()
    
}

//Only enemies carry loot and can be bosses.  Enemy-specific terms.
protocol Enemy: Character {
    
    var boss: Bool { get }
    var loot: [Loot]! { get }
    
    func dropLoot()
    
}

protocol Loot {
    
    var type: LootType { get }
}

enum LootType {
    
    case weapon
    case armor
    case jewelry
    case gold
    case none
    
}


//Stub in case I want to add some hero-specific functionality later.
protocol Hero: Character {
    
}

//Enemy specializations:
protocol Zombie: Enemy {
    
    func bite<T: Character>(_ opponent: inout T)
    
}

protocol Orc: Enemy {
    
    mutating func growl()
}

//Hero specializations:

protocol Ranger: Hero {
    
    func trackEnemy()
    func shootBow()
    
}

protocol Druid: Hero {
    
    mutating func heal()
    func shapeshift()
    
}

protocol Mage: Hero {
    
    func shootFireballAt<T: Enemy>(opponent: inout T)
    func teleport()
    
}

//An enemy type that conforms to the Zombie and Orc protocols.
struct ZombieOrc: Zombie, Orc {

    var health: Int
    var name: String
    var boss: Bool
    var loot: [Loot]!
    var strength: Int
    var intelligence: Int
    

    //Character funcitonality.
    mutating func attack<T: Character>(_ opponent: inout T) {
        print("Steve: SMACK, how's that feel \(opponent.name)")
        let chance = arc4random() % 2
        
        //50% chance for the ZombieOrc to both bite the opponent and growl.
        if chance == 0 {
            bite(&opponent)
            growl()
        }
        
        opponent.health -= strength
        
        if opponent.health <= 0 {
            opponent.die()
        }
    }
    
    mutating func die() {
        print("Steve: Aaaarrrrgggg \(self.name) has died!!!")
        
        if loot != nil {
            dropLoot()
        }
        
        regenerate(me: &self)
    }
    
    //Enemy functionality
    func dropLoot() {
        
        for item in loot {
            print("Steve: The player recieves \(item)")
        }
        
    }
    
    //Zombie functionality
    func bite<T: Character>(_ opponent: inout T) {
        print("Steve: MMmmm \(opponent.name) tastes delicious!")
        
        opponent.health -= 1
    }
    
    //Orc functionality
    mutating func growl() {
        self.health += 10
    }
    
}

//A hero class conforming to the Druid and Mage protocols.
struct DruidMage: Druid, Mage {
    
    var health: Int
    var name: String
    var strength: Int
    var intelligence: Int
    
    //Character functionality
    func attack<T: Character>(_ opponent: inout T) {
        print("ZACK: Take that!")
        
        opponent.health -= strength
        
        if opponent.health <= 0 {
            opponent.die()
            teleport()
        }
    }
    
    func die() {
        print("ZACK: Wait until I respawn....")
        endFight()
    }
    
    //Druid functionality
    mutating func heal() {
        
        health += 10
        print("ZACK: I feel much better...my health is \(health)")
    }
    
    func shapeshift() {
        print("ZACK: RRRROOOOOAAAAARRRRR")
    }
    
    //Mage functionality
    func shootFireballAt<T: Enemy>(opponent: inout T) {
        opponent.health -= 5
        print("ZACK: PEW PEW PEW PEW")
    }
    
    func teleport() {
        print("ZACK: I'm outta here!")
        endFight()
    }
    
}

struct RangerDruidMage: Ranger, Druid, Mage {
    
    var health: Int
    var name: String
    var strength: Int
    var intelligence: Int
    
    init(health: Int, name: String, strength: Int, intelligence: Int) {
        self.health = health
        self.name = name
        self.strength = strength
        self.intelligence = intelligence
    }
    
    func attack<T: Character>(_ opponent: inout T) {
        print("Bonk")
    }
    
    func die() {
        print("Impossible")
    }
    
    func shootBow() {
        print("Thwang")
    }
    
    func trackEnemy() {
        print("The path is clear")
    }
    
    func shapeshift() {
        print("One with nature...")
    }
    
    func heal() {
        print("Much better")
    }
    
    func shootFireballAt<T: Enemy>(opponent: inout T) {
        print("IMMOLATE")
    }
    
    func teleport() {
        print("I must be somewhere quickly")
    }
    
    
    
}

func endFight() {
    fighting = false
}

//Protocol composition:
//First the ZombieOrcs
func regenerate<T: Zombie & Orc>(me: inout T){
    print("STEVE: I'm baaaaaacccccckkkkk")
    me.health = 30
}

//Next the DruidMages
func growFireClaws<T: Druid & Mage>(_ hero: inout T) {
    print("ZACK: It burns, but in a good way.")
    hero.strength += 3
}

//Now for the RangerDruidMage
func trackWithMagicSenses(_ hero: Ranger & Druid & Mage) {
    print("\(hero.name): I know exactly what happened here!")
}


//Has a higher than average intelligence for both orc and zombie due to the brains eaten....
var steve = ZombieOrc(health: 30, name: "Steve the ZombieOrc", boss: false, loot: nil, strength: 4, intelligence: 10)

steve.name
steve.health

var zack = DruidMage(health: 20, name: "Zack the DruidMage", strength: 6, intelligence: 7)

zack.name
zack.health

let raghav = RangerDruidMage(health: 4000, name: "Raghav the Magnificent", strength: 5000, intelligence: 9999)

var round = 1

while fighting {
    
    print("Round \(round)...FIGHT!")
    
    steve.attack(&zack)
    print("Zack's health is \(zack.health)")
    
    if zack.health > 0 {
        if round % 3 == 0 {
            growFireClaws(&zack)
            zack.shapeshift()
        } else if round % 2 == 0 {
            zack.shootFireballAt(opponent: &steve)
        }
        
        zack.attack(&steve)
        print("Steve's health is \(steve.health)")
        
        if zack.health < 15 {
            zack.heal()
        }
    }
    round += 1
}

trackWithMagicSenses(raghav)

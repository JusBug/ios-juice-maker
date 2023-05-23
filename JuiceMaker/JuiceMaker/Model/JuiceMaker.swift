//
//  JuiceMaker - JuiceMaker.swift
//  Created by yagom. 
//  Copyright © yagom academy. All rights reserved.
//

import Foundation

// 쥬스 메이커 타입
struct JuiceMaker {
    private var fruitStore = FruitStore()
    
    mutating func makeJuice(_ juice: Juice) throws {
        let ingredient = juice.ingredients
        
        for (fruit, amount) in ingredient {
            try fruitStore.useFruits(amount, to: fruit)
        }
    }
    
    func bringStock(_ fruit: Fruit) -> Int {
        return fruitStore.bringStock(fruit)
    }
    
    func bringFruitStore() -> FruitStore {
        return fruitStore
    }
    
    mutating func update(_ fruitStore: FruitStore) {
        self.fruitStore = fruitStore
    }
}

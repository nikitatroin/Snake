//
//  Created by Никита Троян on 28.12.2021.
//  Copyright © 2021 Pinspb. All rights reserved.
//

import UIKit

final class SnakeHead: SnakeBodyPart {
    
    // MARK: - Init
    
    override init(atPoint point: CGPoint){
        super.init(atPoint:point)
        self.configurePhysicsBody()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    
    private func configurePhysicsBody() {
        //категория - голова
        self.physicsBody?.categoryBitMask = CollisionCategories.SnakeHead
        //пересекается с телом, яблоком и границей экрана
        self.physicsBody?.contactTestBitMask = CollisionCategories.EdgeBody | CollisionCategories.Apple | CollisionCategories.Snake
    }
}

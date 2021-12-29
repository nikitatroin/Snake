//
//  Created by Никита Троян on 28.12.2021.
//  Copyright © 2021 Pinspb. All rights reserved.
//

import Foundation

/// Категория пересчения объектов
struct CollisionCategories {
    //Тело змеи
    static let Snake: UInt32     = 0x1 << 0
    //Голова змеи
    static let SnakeHead: UInt32 = 0x1 << 1
    //Яблоко
    static let Apple: UInt32     = 0x1 << 2
    //Край сцены (экрана)
    static let EdgeBody: UInt32  = 0x1 << 3
}

//
//  Created by Никита Троян on 28.12.2021.
//  Copyright © 2021 Pinspb. All rights reserved.
//

import Foundation

final class Game {
    static let shared = Game()
    
    private let caretaker = RecordsCaretaker()
    
    private(set) var records: [Records] {
        didSet {
            self.caretaker.save(self.records)
        }
    }
    
    private init() {
        self.records = self.caretaker.load()
    }
    
    func add(_ record: Records) {
        self.records.append(record)
    }
    
    func clearRecord() {
        self.records = []
    }
}

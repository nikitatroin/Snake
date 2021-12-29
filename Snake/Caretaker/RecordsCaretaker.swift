//
//  Created by Никита Троян on 29.12.2021.
//  Copyright © 2021 Pinspb. All rights reserved.
//

import Foundation

final class RecordsCaretaker {
    
    let encode = JSONEncoder()
    let decode = JSONDecoder()
    let key = "records"
    
    func save(_ records: [Records]) {
        do {
            let data = try encode.encode(records)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func load() -> [Records] {
        guard let data = UserDefaults.standard.data(forKey: key) else {return []}
        do {
            return try decode.decode([Records].self, from: data)
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
}

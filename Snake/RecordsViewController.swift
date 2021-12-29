//
//  Created by Никита Троян on 28.12.2021.
//  Copyright © 2021 Pinspb. All rights reserved.
//

import UIKit

class RecordsViewController: UIViewController {
    
    let dateForemater: DateFormatter = {
        var dateForemater = DateFormatter()
        dateForemater.dateStyle = .short
        return dateForemater
    }()
    
    @IBOutlet private weak var tableView: UITableView!
    @IBAction private func back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension RecordsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Game.shared.records.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recordsCell", for: indexPath)
        let record = Game.shared.records[indexPath.row]
        cell.textLabel?.text = "\(record.score)"
        cell.detailTextLabel?.text = self.dateForemater.string(from: record.date)
        return cell
    }
}

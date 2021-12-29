//
//  Created by Никита Троян on 28.12.2021.
//  Copyright © 2021 Pinspb. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {
    
    @IBOutlet weak var score: UILabel! {
        didSet {
            let records = RecordsCaretaker().load()
            guard let last = records.last?.score else { return }
            self.score.text = "\(last)"
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           switch segue.identifier {
           case "startGameSegue":
               guard let destination = segue.destination as? GameViewController else { return }
               //destination.gameViewControllerDelegate = self
               destination.onGameEnd = { [weak self] result in
                   self?.score.text = "\(result)"
               }
           default:
               break
           }
       }
   }


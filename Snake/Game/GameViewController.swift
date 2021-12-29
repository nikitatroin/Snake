//
//  Created by Никита Троян on 28.12.2021.
//  Copyright © 2021 Pinspb. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

protocol GameViewControllerDelegate: AnyObject {
    func didEndGame(withScore score: Int)
}

final class GameViewController: UIViewController {
    
    var onGameEnd: ((Int) -> Void)?
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = GameScene(size: view.bounds.size)
        scene.scaleMode = .resizeFill
        scene.onGameEnd = { [weak self] result in
            self?.onGameEnd?(result)
            self?.dismiss(animated: true, completion: nil)
        }

        guard let skView = view as? SKView else { return }
        skView.showsFPS = true //включаем отображение fps (количество кадров в секунду)
        skView.showsNodeCount = true //показывать количество объектов на экране
        skView.ignoresSiblingOrder = true //включаем произволный порядок рендеринга объектов в узле
        skView.presentScene(scene)
    }
    
    // MARK: - UIViewController
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}


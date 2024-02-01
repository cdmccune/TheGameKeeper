//
//  ScoreboardPlayerEditScorePopoverViewController.swift
//  Whats The Score
//
//  Created by Curt McCune on 2/1/24.
//

import UIKit

protocol ScoreboardplayerEditScorePopoverDelegate: NSObject {
    func edit(player: Player, scoreBy change: Int)
}

class ScoreboardPlayerEditScorePopoverViewController: UIViewController {
    
    var player: Player?
    weak var delegate: ScoreboardplayerEditScorePopoverDelegate?

//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

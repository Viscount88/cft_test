//
//  ProcessingProgressCell.swift
//  CFTTest
//
//  Created by Денис Лебедько on 05/12/2018.
//  Copyright © 2018 Денис Лебедько. All rights reserved.
//

import UIKit

class ProgressTVC: UITableViewCell {

    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    @objc dynamic var loadingItem: LoadingItem = LoadingItem()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addObserver(self, forKeyPath: #keyPath(loadingItem.currentProgress), options: [.old, .new], context: nil)
    }
    
    func updateProgress(_ value: Float) {
        self.progressView.progress = value
        self.progressLabel.text = "\(Int(loadingItem.currentProgress*100))%"
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(loadingItem.currentProgress) {
            DispatchQueue.main.async { [weak self] in
                guard let `self` = self else { return }
                
                self.updateProgress(self.loadingItem.currentProgress)
            }
        }
    }
    
    deinit {
        removeObserver(self, forKeyPath: #keyPath(loadingItem.currentProgress))
    }
}

//
//  ImageProcessingTVAdapter.swift
//  CFTTest
//
//  Created by Денис Лебедько on 06/12/2018.
//  Copyright © 2018 Денис Лебедько. All rights reserved.
//

import UIKit

enum ImageProcessingTableSection: Int, CaseIterable {
    case loading = 0
    case images = 1
}

class ImageProcessingTVAdapter: NSObject, UITableViewDelegate, UITableViewDataSource {
    var tableView: UITableView!
    let defaults = UserDefaults.standard
    var showActionsBlock: (TransformedImage) -> Void = { _ in }
    
    var transformedImages: [TransformedImage] = [] {
        didSet {
            tableView.reloadData()
            let names = transformedImages.map { $0.uuid }
            defaults.set(names, forKey: Constants.transformedImageNamesKey)
        }
    }
    var loadingItems: [LoadingItem] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    init(_ tv: UITableView) {
        super.init()
        
        tableView = tv
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCell(.progressCell)
        tableView.registerCell(.resultImageCell)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 208
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return ImageProcessingTableSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let imageProcessingTableSection = ImageProcessingTableSection(rawValue: section) else { return 0 }
        
        switch imageProcessingTableSection {
        case .loading:
            return loadingItems.count
        case .images:
            return transformedImages.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let imageProcessingTableSection = ImageProcessingTableSection(rawValue: indexPath.section) else { return UITableViewCell() }

        switch imageProcessingTableSection {
        case .loading:
            let cell = tableView.dequeueReusableCell(of: .progressCell, for: indexPath) as! ProgressTVC
            cell.selectionStyle = .none
            cell.loadingItem = loadingItems[indexPath.row]
            return cell
        case .images:
            let cell = tableView.dequeueReusableCell(of: .resultImageCell, for: indexPath) as! ResultImageTVC
            cell.selectionStyle = .none
            cell.resultImageView.image = transformedImages[indexPath.row].image
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let imageProcessingTableSection = ImageProcessingTableSection(rawValue: indexPath.section) else { return }
        switch imageProcessingTableSection {
        case .images:
            showActionsBlock(transformedImages[indexPath.row])
        default:
            return
        }
    }
}

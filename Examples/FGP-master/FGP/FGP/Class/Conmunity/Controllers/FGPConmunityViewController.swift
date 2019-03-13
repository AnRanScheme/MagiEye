//
//  FGPConmunityViewController.swift
//  FGP
//
//  Created by briceZhao on 2018/8/26.
//  Copyright © 2018年 BriceZhao. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import MagiRefresh
import MagiPhotoBrowser

class FGPConmunityViewController: UIViewController {
    
    lazy var tableNode: ASTableNode = {
        let tableNode = ASTableNode(style: .plain)
        tableNode.delegate = self
        tableNode.dataSource = self
        tableNode.frame = self.view.bounds
        tableNode.view.magiRefresh.bindStyleForHeaderRefresh(themeColor: UIColor.orange,
                                                             refreshStyle: MagiRefreshStyle.replicatorAllen,
                                                             completion: {
                                                                _ = delay(1, task: {
                                                                    tableNode.view.magiRefresh.header?.endRefreshing()
                                                                })
        })
        
        return tableNode
    }()
    
    var dataArray: [FGPCommunotyModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        dataArray = setData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        print(self.debugDescription+"------销毁了")
    }

}

// MARK: - 自定义方法
extension FGPConmunityViewController {
    
    fileprivate func setupUI() {
         let fps1 = TestMagiFPSLabel(frame: CGRect(x: 100, y: 130, width: 55, height: 20))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonItem.SystemItem.add,
            target: self,
            action: #selector(pushToPublishVC))
        view.addSubnode(tableNode)
        view.addSubview(fps1)
    }
    
    fileprivate func addNotification() {
        
    }
    
    func setData()->[FGPCommunotyModel] {
        
        let title = "测试辩题"
        let subTitle = "1990.04.05 "
        let content = "为了保持用户界面的流畅，你的 App 应该应"
        let imageString = "http://texturegroup.org/static/images/layout-examples-photo-with-outset-icon-overlay-photo.png"
        let array = ["就撒客户端不会骄傲说不定就爱上别的",
                     "就撒客户端不会骄傲说户端不会骄傲说不定就爱上户端不会骄傲说不定就爱上户端不会骄傲说不定就爱上不定就爱上别的",
                     "就撒客户端不会骄傲说不定就爱上别的",
                     "就撒客户端不会骄傲户端不会骄傲说不定就爱上户端不会骄傲说不定就爱上说不定就爱上别的",
                     "就撒客户端不会骄傲说不定就爱上别的",
                     "就撒客户端不会骄户端不会骄傲说不定就爱上户端不会骄傲说不定就爱上傲说不定就爱上别的",
                     "就撒客户端不会骄傲说不定就爱上别的",
                     "就撒客户端不会骄傲说不定就爱上别的"]
        var dataArray: [FGPCommunotyModel] = [FGPCommunotyModel]()
        
        for index in 1...90 {
            let model = FGPCommunotyModel()
            model.title = title + String(index)
            var contentData = ""
            
            if index % 3 == 0 {
                contentData = content + content
            }
                
            else if index % 3 == 1 {
                contentData = content+content+content+content
            }
                
            else {
                contentData = content
            }
            
            model.content = contentData
            model.time = subTitle + String(index)
            model.photoImageString = imageString
            model.userComment = array
            dataArray.append(model)
        }
        return dataArray
    }
    
}

// MARK: - 数据加载
extension FGPConmunityViewController {
    
    fileprivate func loadNewData() {
        
    }
    
}

// MARK: - Action
extension FGPConmunityViewController {
    
    @objc
    fileprivate func pushToPublishVC() {
        let vc = FGPPublishViewController()
        navigationController?.pushViewController(vc,
                                                 animated: true)
    }

}

// MARK: - ASTableDataSource
extension FGPConmunityViewController: ASTableDataSource {
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        
        return 1
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        
        return dataArray.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        let cell = FGPConmunityCell()
        cell.model = dataArray[indexPath.row]
        cell.delegate = self
        cell.indexPaths = indexPath
        
        return cell
    }
    
}

// MARK: - ASTableDelegate
extension FGPConmunityViewController: ASTableDelegate {
    
    
    
}

// MARK: - ASTableDelegate
extension FGPConmunityViewController: FGPConmunityCellDelegate {

    
    func conmunityCell(_ cell: FGPConmunityCell,
                       photoNote: ASNetworkImageNode,
                       selectImage: String,
                       nodeAt indexPath: IndexPath) {
   
    }
    
    
    func conmunityCell(_ cell: FGPConmunityCell,
                       model: FGPCommunotyModel,
                       type: FGPConmunityCell.FGPConmunityCellDelegateType,
                       nodeAt indexPath: IndexPath) {
        switch type {
        case .comment:
            break
        case .best:
            break
        case .shared:
            break
        }

    }

}

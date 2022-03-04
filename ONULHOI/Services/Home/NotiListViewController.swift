//
//  NotiListViewController.swift
//  ONULHOI
//
//  Created by 김영민 on 2022/01/03.
//

import UIKit
import Imaginary

extension NotiListViewController: StoryboardLoadable {
    static var ownerStoryboard = UIStoryboard(name: "Home", bundle: nil)
}

class NotiListViewController: UMViewController {

    struct Section {
        var name: String!
        var contents: String!
        var height: CGFloat!
        var collapsed: Bool!
        
        init(name: String, contents: String, height: CGFloat = 0, collapsed: Bool = false) {
            self.name = name
            self.contents = contents
            self.height = height
            self.collapsed = collapsed
        }
    }

    @IBOutlet weak var tbv_Noti: UITableView!
    
    var sections = [Section]()

    override func viewDidLoad() {
        super.viewDidLoad()

        sections = [
            Section(name: "[필수] 배송시 마스크 착용 및 비대면배송", contents: "안녕하세요.\n\n서비스에서 일부 라이브 영상 재생 오류 현상이 발생하였고, 긴급점검을 진행하여 현재는 정상적으로 서비스를 이용하실 수 있습니다. 보다 안정적인 서비스를 위해 최선을 다하는 오늘회가 되겠습니다.\n\n감사합니다."),
            Section(name: "금·토는 배정 확률 및 배정 건수 ↑↑", contents: "1"),
            Section(name: "[배정확률↑] 서초구/강남구/관악구/서초구...", contents: "2"),

        ]

    }
        

    
    
    func getSectionIndex(_ row: NSInteger) -> Int {
        let indices = getHeaderIndices()
        
        for i in 0..<indices.count {
            if i == indices.count - 1 || row < indices[i + 1] {
                return i
            }
        }
        
        return -1
    }
    
    func getRowIndex(_ row: NSInteger) -> Int {
        var index = row
        let indices = getHeaderIndices()
        
        for i in 0..<indices.count {
            if i == indices.count - 1 || row < indices[i + 1] {
                index -= indices[i]
                break
            }
        }
        
        return index
    }
    
    func getHeaderIndices() -> [Int] {
        var index = 0
        var indices: [Int] = []
        
        for _ in sections {
            indices.append(index)
            index += 2
        }
        
        return indices
    }
}

extension NotiListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count * 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = getSectionIndex(indexPath.row)
        let row = getRowIndex(indexPath.row)

        if row == 0 {
            return 70.0
        }

        return sections[section].collapsed ? sections[section].height : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = getSectionIndex(indexPath.row)
        let row = getRowIndex(indexPath.row)
        
        if row == 0 {
            let cell: NotiHeaderCell = tableView.dequeueReusableCell(for: indexPath)
            cell.lb_Title.text = sections[section].name
            cell.btn.tag = section
            cell.btn.onTap {
                self.sections[section].collapsed = !self.sections[section].collapsed
                self.tbv_Noti.beginUpdates()
                self.tbv_Noti.reloadRows(at: [IndexPath(row: section, section: 1)], with: .automatic)
                self.tbv_Noti.endUpdates()
                
                UIView.animate(withDuration: 0.3) {
                    if self.sections[section].collapsed {
                        cell.iv_Arrow.transform = CGAffineTransform(rotationAngle: .pi)
                    } else {
                        cell.iv_Arrow.transform = .identity
                    }
                }
            }
            return cell
        } else {
            let cell: NotiContentsCell = tableView.dequeueReusableCell(for: indexPath)
            cell.lb_Contents.text = sections[section].contents
            sections[section].height = cell.lb_Contents.height() + cell.lc_Top.constant + cell.lc_Bottom.constant
            return cell
        }
    }

}

//
//  CalendarViewController.swift
//  ONULHOI
//
//  Created by 김영민 on 2022/01/06.
//

import UIKit
import FSCalendar

extension CalendarViewController: StoryboardLoadable {
    static var ownerStoryboard = UIStoryboard(name: "Main", bundle: nil)
}

extension CalendarViewController {
    enum Mode {
        case single
        case multi
        case change(oldDate: Date, ids: [Int]?)
    }
}

class CalendarViewController: UMViewController {

    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var btn_Select: UIBButton!
    @IBOutlet weak var v_BtnBg: UIView!
    
    var completeHandler: ((Date?, Date?) -> Void)? = { _,_  in }
    var mode: Mode = .single
    
    private var firstDate: Date?
    private var lastDate: Date?
    private var datesRange: [Date]?

    override func viewDidLoad() {
        super.viewDidLoad()

        calendar.placeholderType = .none
        calendar.scrollDirection = .vertical
        calendar.pagingEnabled = false
        switch mode {
        case .single:
            calendar.allowsMultipleSelection = false
        case .multi:
            calendar.allowsMultipleSelection = true
        case .change(_: _, _: _):
            calendar.allowsMultipleSelection = false
        }
//        calendar.allowsMultipleSelection = true
//        calendar.swipeToChooseGesture.isEnabled = true
        
        calendar.appearance.weekdayTextColor = UIColor(hex: 0x848484)
        calendar.appearance.headerTitleColor = UIColor.black
        calendar.appearance.selectionColor = UIColor.black
//        calendar.appearance.todayColor = UIColor.lightGray
        calendar.appearance.todayColor = UIColor.clear
        calendar.appearance.todaySelectionColor = UIColor.black
        calendar.appearance.titleDefaultColor = UIColor(hex: 0x424242)
        calendar.appearance.subtitleTodayColor = UIColor(hex: 0x424242)
        calendar.headerHeight = 44
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.appearance.headerDateFormat = "YYYY년 M월"
        calendar.appearance.headerTitleColor = .black
        calendar.appearance.headerTitleFont = UIFont.systemFont(ofSize: 15, weight: .bold)
        calendar.appearance.titleTodayColor = UIColor.black
    }
    
    func datesRange(from: Date, to: Date) -> [Date] {
        // in case of the "from" date is more than "to" date,
        // it should returns an empty array:
        if from > to { return [Date]() }

        var tempDate = from
        var array = [tempDate]

        while tempDate < to {
            tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
            array.append(tempDate)
        }

        return array
    }

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if firstDate != nil && lastDate != nil && datesRange?.count ?? 0 > 0 {
            calendar.appearance.todaySelectionColor = UIColor.black
            calendar.reloadData()
            v_BtnBg.isHidden = true
        }
        
        if firstDate == nil {
            firstDate = date
            datesRange = [firstDate!]

            btn_Select.text = firstDate?.string(fmt: "MM월 dd일 선택하기")
            v_BtnBg.isHidden = false

            return
        }

        if firstDate != nil && lastDate == nil {
            if date <= firstDate! {
                calendar.deselect(firstDate!)
                firstDate = date
                datesRange = [firstDate!]
                btn_Select.text = firstDate?.string(fmt: "MM월 dd일 선택하기")
                v_BtnBg.isHidden = false
                return
            }

            let range = datesRange(from: firstDate!, to: date)

            lastDate = range.last

            for d in range {
                calendar.select(d)
            }

            datesRange = range
            calendar.reloadData()
            btn_Select.text = (firstDate?.string(fmt: "MM월 dd일"))! + " ~ " + (lastDate?.string(fmt: "MM월 dd일 선택하기"))!

            return
        }

        if firstDate != nil && lastDate != nil {
            for d in calendar.selectedDates {
                calendar.deselect(d)
            }

            lastDate = nil
            firstDate = nil

            datesRange = []

            print("datesRange contains: \(datesRange!)")
        }
    }

    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if firstDate != nil || lastDate != nil {
            for d in calendar.selectedDates {
                calendar.deselect(d)
            }

            lastDate = nil
            firstDate = nil

            datesRange = []
            calendar.appearance.todaySelectionColor = UIColor.black
            v_BtnBg.isHidden = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.calendar.reloadData()
            }
        }
    }
    
    @IBAction func goConfirm(_ sender: Any) {
        switch mode {
        case .change(oldDate: let oldDate, ids: let ids):
            if let start = firstDate {
                let new = start.string(fmt: "yyyy-MM-dd")
                let old = oldDate.string(fmt: "yyyy-MM-dd")
                if new == old {
                    PPAlert.present(title: "선택일과 기존일이 같습니다.")
                } else {
                    let vc = ChangeDateViewController.instantiate()
                    vc.newDate = start
                    vc.ids = ids
                    navigationController?.pushViewController(vc, animated: true)
                }
            }
            return
        default:()
        }

        completeHandler?(firstDate, lastDate)
        dismiss(animated: true, completion: nil)
    }
}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        
        if df.string(from: date) == df.string(from: Date()) {
            return "오늘"
        }
        
        switch mode {
        case .change(oldDate: let oldDate, ids: _):
            if df.string(from: date) == df.string(from: oldDate) {
                return "기존일"
            }
        default:()
        }

        return nil
    }

    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        
        if let firstDate = firstDate, let lastDate = lastDate {
            if df.string(from: date) != df.string(from: firstDate) && df.string(from: date) != df.string(from: lastDate) {
                return UIColor.hexColor(0x000000, alpha: 0.3)
            }
        }

        return .black
    }
}

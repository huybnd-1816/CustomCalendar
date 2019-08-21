//
//  CalendarVer2ViewModel.swift
//  SwiftCalendar
//
//  Created by nguyen.duc.huyb on 8/21/19.
//  Copyright © 2019 Sameer Poudel. All rights reserved.
//

import Foundation
import UIKit

protocol CalendarVer2ProtocolOutput {
    var didChanged: ((Date) -> Void)? { get }
    var didReloadData: (() -> Void)? { get }
}

final class CalendarVer2ViewModel: NSObject, CalendarVer2ProtocolOutput {
    private let numberOfCellsPerRow: CGFloat = 7
    private var selectedIndex: IndexPath?
    private var firstDayOfWeek = Date().startOfMonthFC().getDayOfWeekFC()!
    private let today = Date().getDayFC(day: 0)
    private var currentDate: Date!
    private var offset: Int = 0
    
    var selectedDate = Date()
    var didChanged: ((Date) -> Void)?
    var didReloadData: (() -> Void)?
    
    override init() {
        super.init()
        currentDate = Calendar.current.date(byAdding: .month, value: offset, to: today)?.startOfMonthFC()
    }
    
    private func getDayName(_ index: Int) -> String? {
        switch (index) {
        case 0:
            return "S"
        case 1:
            return "M"
        case 2:
            return "T"
        case 3:
            return "W"
        case 4:
            return "T"
        case 5:
            return "F"
        case 6:
            return "S"
        default:
            return nil
        }
    }
}

extension CalendarVer2ViewModel: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        let calendarDay = cell?.viewWithTag(1) as! UILabel // label tag = 1
        if Int(calendarDay.text!) != nil {
            let sDate = (self.currentDate?.getDayFC(day: Int(calendarDay.text!)! - 1))!
            didChanged?(sDate)
            selectedDate = sDate
            selectedIndex = indexPath
            didReloadData?()
        }
    }
}

extension CalendarVer2ViewModel: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderView", for: indexPath) as? HeaderView else { return UICollectionReusableView() }
        headerView.configHeaderView(currentDate.getHeaderTitleFC())
        
        headerView.didTapLeftButton = { [weak self] in
            guard let self = self else { return }
            self.selectedIndex = nil
            self.offset -= 1
            self.currentDate = Calendar.current.date(byAdding: .month, value: self.offset, to: self.today)?.startOfMonthFC()
            self.firstDayOfWeek = (self.currentDate?.startOfMonthFC().getDayOfWeekFC())!
            self.didReloadData?()
        }
        
        headerView.didTapRightButton = { [weak self] in
            guard let self = self else { return }
            self.selectedIndex = nil
            self.offset += 1
            self.currentDate = Calendar.current.date(byAdding: .month, value: self.offset, to: self.today)?.startOfMonthFC()
            self.firstDayOfWeek = (self.currentDate?.startOfMonthFC().getDayOfWeekFC())!
            self.didReloadData?()
        }
        
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numberOfDaysInMonth = currentDate.getDaysInMonthFC()
        let firstDayOfWeek = currentDate.startOfMonthFC().getDayOfWeekFC()!
        return numberOfDaysInMonth + firstDayOfWeek + 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let calendarDay = cell.viewWithTag(1) as! UILabel
        calendarDay.textColor = UIColor.darkGray
        
        if indexPath.row + 1 >= firstDayOfWeek + 7 {
            calendarDay.text = "\((indexPath.row + 1) - (firstDayOfWeek + 6))"
        } else {
            if indexPath.row < 7 {
                let dayname = getDayName(indexPath.row)
                calendarDay.text = dayname
                calendarDay.textColor = UIColor.lightGray
            } else {
                calendarDay.text = ""
            }
        }
        
        cell.viewWithTag(2)?.isHidden = true
        cell.viewWithTag(2)?.layer.cornerRadius = (cell.viewWithTag(2)?.frame.size.width)! / 2
        
        if selectedIndex != nil {
            if selectedIndex == indexPath {
                cell.viewWithTag(2)?.isHidden = false
                cell.viewWithTag(2)?.backgroundColor = UIColor(red: 63.0/255.0, green: 61.0/255.0, blue: 141.0/255.0, alpha: 1.0)
                calendarDay.textColor = UIColor.white
            }
        } else if Int(calendarDay.text!) != nil { // selected default day is today
            if currentDate.startOfMonthFC().getDayFC(day: Int(calendarDay.text!)! - 1) == today {
                cell.viewWithTag(2)?.isHidden = false
                cell.viewWithTag(2)?.backgroundColor = UIColor(red: 255.0/255.0, green: 75.0/255.0, blue: 110.0/255.0, alpha: 1.0)
                calendarDay.textColor = UIColor.white
                didChanged?(selectedDate)
                selectedDate = Date()
                selectedIndex = indexPath
            }
        }
        
        return cell
    }
}

extension CalendarVer2ViewModel: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (collectionView.frame.width - 16) / numberOfCellsPerRow
        return CGSize(width: cellWidth, height: cellWidth)
    }
}

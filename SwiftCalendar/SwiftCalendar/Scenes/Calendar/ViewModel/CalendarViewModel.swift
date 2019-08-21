//
//  CalendarViewModel.swift
//  SwiftCalendar
//
//  Created by nguyen.duc.huyb on 8/19/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//

import Foundation
import UIKit

protocol CalendarProtocolOutput {
    var didScrollToItem: ((IndexPath?) -> Void)? { get }
    var didChanged: ((Date) -> Void)? { get }
    var didReloadData: (() -> Void)? { get }
}

final class CalendarViewModel: NSObject, CalendarProtocolOutput {
    private let numberOfCellsPerRow: CGFloat = 7
    private var numberOfSections: Int = 12
    private var selectedIndex: IndexPath?
    
    var selectedDate = Date()
    var didScrollToItem: ((IndexPath?) -> Void)?
    var didChanged: ((Date) -> Void)?
    var didReloadData: (() -> Void)?
    
    override init() {
        super.init()
    }
    
    private func scrollToIndex() {
        didScrollToItem?(selectedIndex)
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

extension CalendarViewModel: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        let calendarDay = cell?.viewWithTag(1) as! UILabel // label tag = 1
        if Int(calendarDay.text!) != nil {
            cell?.viewWithTag(2)?.isHidden = false // selected view tag = 2
            calendarDay.textColor = UIColor.white
            let sDate = Date().addMonthFC(month: indexPath.section).startOfMonthFC().getDayFC(day: Int(calendarDay.text!)! - 1)
            
            didChanged?(sDate)
            selectedDate = sDate
            selectedIndex = indexPath
            collectionView.reloadData()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) { // Infinity Scrolling
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.size.height {
            numberOfSections += 12
            didReloadData?()
        }
    }
}

extension CalendarViewModel: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
        let title = headerView.viewWithTag(1) as! UILabel
        title.text = Date().addMonthFC(month: indexPath.section).getHeaderTitleFC()
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numberOfDaysInMonth = Date().addMonthFC(month: section).getDaysInMonthFC()
        let firstDayOfWeek = Date().addMonthFC(month: section).startOfMonthFC().getDayOfWeekFC()!
        return numberOfDaysInMonth + firstDayOfWeek + 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let calendarDay = cell.viewWithTag(1) as! UILabel
        calendarDay.textColor = UIColor.darkGray
        
        let firstDayOfWeek = Date().addMonthFC(month: indexPath.section).startOfMonthFC().getDayOfWeekFC()!
        
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
                calendarDay.textColor = UIColor.white
                self.scrollToIndex()
            }
        } else if Int(calendarDay.text!) != nil { // selected default day is today
            let today = Date().getDayFC(day: 0)
            if Date().addMonthFC(month: indexPath.section).startOfMonthFC().getDayFC(day: Int(calendarDay.text!)! - 1) == today {
                cell.viewWithTag(2)?.isHidden = false
                calendarDay.textColor = UIColor.white
                didChanged?(selectedDate)
                selectedDate = Date()
                selectedIndex = indexPath
            }
        }
        
        return cell
    }
}

extension CalendarViewModel: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (collectionView.frame.width - 16) / numberOfCellsPerRow
        return CGSize(width: cellWidth, height: cellWidth)
    }
}

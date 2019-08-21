//
//  ViewController.swift
//  SwiftCalendar
//
//  Created by nguyen.duc.huyb on 8/19/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//

import UIKit

final class MainViewController: UIViewController {
    
    @IBOutlet private weak var dateLabel: UILabel!
    
    private var selectedDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func showCalendar(_ sender: UIButton) {
        let calendarViewController = storyboard?.instantiateViewController(withIdentifier: "CalendarViewController") as! CalendarViewController
        calendarViewController.modalTransitionStyle = .crossDissolve
        calendarViewController.modalPresentationStyle = .overCurrentContext
        calendarViewController.delegate = self
        calendarViewController.selectedDate = selectedDate
        present(calendarViewController, animated: true)
    }
}

extension MainViewController: CalendarCallback {
    func didSelectDate(date: Date) {
        selectedDate = date
        dateLabel.text = date.getTitleDateFC()
    }
}

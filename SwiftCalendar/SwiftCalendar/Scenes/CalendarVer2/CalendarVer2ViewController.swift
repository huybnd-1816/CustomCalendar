//
//  CalendarVer2ViewController.swift
//  SwiftCalendar
//
//  Created by nguyen.duc.huyb on 8/21/19.
//  Copyright © 2019 Sameer Poudel. All rights reserved.
//

import UIKit

protocol CalendarVer2Callback {
    func didSelectDateVer2(date: Date)
}

final class CalendarVer2ViewController: UIViewController {

    @IBOutlet private weak var calendarCollectionView: UICollectionView!
    @IBOutlet private weak var yearLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var wrapper: UIView!
    
    var delegate: CalendarVer2Callback?
    
    var selectedDate = Date()
    private var verticalConstraint: NSLayoutConstraint?
    private var heightConstraint: NSLayoutConstraint?
    private var viewModel: CalendarVer2ViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        calendarCollectionView.reloadData()
    }
    
    private func config() {
        setupConstraints()
        
        calendarCollectionView.register(UINib(nibName: "HeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "HeaderView")
        viewModel = CalendarVer2ViewModel()
        calendarCollectionView.delegate = viewModel
        calendarCollectionView.dataSource = viewModel
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            UIView.animate(withDuration: 0.25, animations: {
                self.verticalConstraint!.constant = 60
                self.heightConstraint = self.wrapper.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
                self.view.addConstraints([self.heightConstraint!])
                self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
                self.view.layoutIfNeeded()
            })
        }
        
        yearLabel.text = selectedDate.getYearOnlyFC()
        dateLabel.text = selectedDate.getTitleDateFC()
        
        viewModel.didChanged = { [weak self] selectedDate in
            guard let self = self else { return }
            self.selectedDate = selectedDate
            self.yearLabel.text = self.selectedDate.getYearOnlyFC()
            self.dateLabel.text = self.selectedDate.getTitleDateFC()
        }
        
        viewModel.didReloadData = { [weak self] in
            guard let self = self else { return }
            self.calendarCollectionView.reloadData()
        }
    }
    
    private func setupConstraints() {
        wrapper.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraint = wrapper.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0)
        let widthConstraint = wrapper.widthAnchor.constraint(equalToConstant: view.frame.size.width)
        verticalConstraint = wrapper.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: view.frame.size.height)
        
        view.addConstraints([horizontalConstraint, widthConstraint, verticalConstraint!])
    }
    
    @IBAction func close(_ sender: UIButton) {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.removeConstraint(self.heightConstraint!)
            self.verticalConstraint!.constant = self.view.frame.size.height
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0)
            self.view.layoutIfNeeded()
        }) { (done) in
            self.dismiss(animated: false)
        }
    }
    
    @IBAction func handleSelectDateButtonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.removeConstraint(self.heightConstraint!)
            self.verticalConstraint!.constant = self.view.frame.size.height
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0)
            self.view.layoutIfNeeded()
        }) { (done) in
            self.dismiss(animated: false)
            self.delegate?.didSelectDateVer2(date: self.selectedDate)
        }
    }
}

//
//  DaySummarySelector.swift
//  WeatherApp
//
//  Created by Дмитрий Никишов on 06.01.2022.
//

import UIKit

class DaySummarySelectorView : UIView
{
    private var modelData : [UiDayItem] = []
    
    var selectedDayChanged : UiSelectedDayChangedHandler?
    
    func applyModelData(calendarDays : [UiDayItem])
    {
        modelData = calendarDays
        dayItemsCollection.reloadData()
        
        let indexPath = IndexPath(item: 0, section: 0)
        DispatchQueue.main.async { [weak self] in
            guard let this = self else {return}
            this.dayItemsCollection.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
            this.collectionView(this.dayItemsCollection, didSelectItemAt: indexPath)
        }
    }
        
    private lazy var dayItemsCollection : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(DaySummarySelectorCell.self,
                      forCellWithReuseIdentifier: String(describing: DaySummarySelectorCell.self))
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private func setupViews()
    {
        self.backgroundColor = .white

        LayoutAssembler.fillAreaWithView(area: self, filler: dayItemsCollection)
    }
    
    init(viewFrame : CGRect) {
        super.init(frame: viewFrame)
        setupViews()
    }
     
    required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented for DaySummarySelectorView")
    }
}

extension DaySummarySelectorView : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return modelData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = dayItemsCollection.cellForItem(at: indexPath) as? DaySummarySelectorCell {
            cell.isCellSelected = true
            selectedDayChanged?(indexPath.row)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = dayItemsCollection.cellForItem(at: indexPath) as? DaySummarySelectorCell {
            cell.isCellSelected = false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =
        dayItemsCollection.dequeueReusableCell(withReuseIdentifier:
                                                String(describing: DaySummarySelectorCell.self),
                                              for: indexPath) as! DaySummarySelectorCell

        cell.dateLabelValue = modelData[indexPath.row].calendarDate

        return cell
    }
}

extension DaySummarySelectorView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 36)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 18
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}


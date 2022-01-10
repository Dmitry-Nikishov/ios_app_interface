//
//  DaySummarySelectorCell.swift
//  WeatherApp
//
//  Created by Дмитрий Никишов on 06.01.2022.
//

import UIKit

class DaySummarySelectorCell: UICollectionViewCell {
    private var isViewSelected : Bool = false
    
    var isCellSelected : Bool? {
        didSet {
            if let isSelected = isCellSelected {
                if isSelected && isViewSelected == false {
                    dateLabel.textColor = .white
                    cellArea.layer.backgroundColor = UIColor(red: 0.125, green: 0.306, blue: 0.78, alpha: 1).cgColor
                    isViewSelected = true
                } else if isSelected == false && isViewSelected == true {
                    dateLabel.textColor = .black
                    cellArea.backgroundColor = .white
                    isViewSelected = false
                }
            }
        }
    }
                        
    private let cellArea : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        return view
    }()

    private let dateLabel : UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 18)
        view.text = "16/04 ПТ"
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private func setupViews() {
        LayoutAssembler.fillAreaWithView(area: contentView, filler: cellArea)
    }
        
    private func setItems()
    {
        LayoutAssembler.fillAreaWithView(area: cellArea, filler: dateLabel)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setItems()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        self.backgroundColor = .white
    }
}



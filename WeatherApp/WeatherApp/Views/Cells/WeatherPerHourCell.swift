//
//  WeatherPerHourCell.swift
//  WeatherApp
//
//  Created by Дмитрий Никишов on 23.12.2021.
//

import UIKit

class WeatherPerHourCell: UICollectionViewCell {
    private let shadowViewTag : Int = 111
    private var isViewSelected : Bool = false
    
    public var temperature : String {
        get {
            return temperatureLabel.text ?? ""
        }
        
        set(newValue) {
            temperatureLabel.text = newValue
        }
    }
    
    public var time : String {
        get {
            return timeLabel.text ?? ""
        }
        
        set(newValue) {
            timeLabel.text = newValue
        }
    }
    
    var isCellSelected : Bool? {
        didSet {
            if let isSelected = isCellSelected {
                if isSelected && isViewSelected == false {
                    addShadows()
                    timeLabel.textColor = .white
                    temperatureLabel.textColor = .white
                    isViewSelected = true
                } else if isSelected == false && isViewSelected == true {
                    removeShadows()
                    timeLabel.textColor = .black
                    temperatureLabel.textColor = .black
                    isViewSelected = false
                }
            }
        }
    }
    
    private func removeShadows()
    {
        cellArea.subviews.filter({$0.tag == shadowViewTag}).forEach({$0.removeFromSuperview()})
    }
    
    private func addShadows() {
        let shadows = UIView()
        shadows.frame = cellArea.frame
        shadows.clipsToBounds = false
        shadows.tag = shadowViewTag
        
        cellArea.insertSubview(shadows, at: 0)
        
        let shadowPath0 = UIBezierPath(roundedRect: shadows.bounds, cornerRadius: 22)
        let layer0 = CALayer()
        layer0.shadowPath = shadowPath0.cgPath
        layer0.shadowColor = UIColor(red: 0.4,
                                     green: 0.546,
                                     blue: 0.942,
                                     alpha: 0.68).cgColor
        layer0.shadowOpacity = 1
        layer0.shadowRadius = 45
        layer0.shadowOffset = CGSize(width: -5, height: 5)
        layer0.bounds = shadows.bounds
        layer0.position = shadows.center
        shadows.layer.addSublayer(layer0)
        
        let shapes = UIView()
        shapes.frame = cellArea.frame
        shapes.clipsToBounds = true
        shapes.tag = shadowViewTag
        cellArea.insertSubview(shapes, at: 0)
        
        let layer1 = CAGradientLayer()
        layer1.colors = [
            UIColor(red : 0.246, green: 0.398, blue: 0.808, alpha: 0.58).cgColor,
            UIColor(red: 0.125, green: 0.306, blue: 0.78, alpha: 1).cgColor
        ]
        layer1.locations = [0, 0.73]
        layer1.startPoint = CGPoint(x: 0.25, y: 0.5)
        layer1.endPoint = CGPoint(x: 0.75, y: 0.5)
        layer1.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 0, b: 1, c: -1, d: 0, tx: 1, ty: 1))
        layer1.bounds = shapes.bounds.insetBy(dx: -0.5*shapes.bounds.size.width,
                                              dy: -0.5*shapes.bounds.size.height)
        layer1.position = shapes.center
        shapes.layer.addSublayer(layer1)
        shapes.layer.cornerRadius = 22
    }
        
    private let itemsStack : UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fillEqually
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
        
    private let cellArea : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 22
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        return view
    }()

    private let timeLabel : UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 11)
        view.text = "12:00"
        view.textAlignment = .center
        return view
    }()

    private let imageLabel : UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(systemName: "cloud.sun")
        return view
    }()
    
    private let temperatureLabel : UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 11)
        view.text = "13°"
        view.textAlignment = .center
        return view
    }()

    private func setupViews() {
        contentView.addSubview(cellArea)
        
        let constraints = [
            cellArea.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellArea.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellArea.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cellArea.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupItems()
    {
        cellArea.addSubview(itemsStack)

        let constraints = [
            itemsStack.topAnchor.constraint(equalTo: cellArea.topAnchor),
            itemsStack.leadingAnchor.constraint(equalTo: cellArea.leadingAnchor),
            itemsStack.trailingAnchor.constraint(equalTo: cellArea.trailingAnchor),
            itemsStack.bottomAnchor.constraint(equalTo: cellArea.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setItems()
    {
        itemsStack.addArrangedSubview(timeLabel)
        itemsStack.addArrangedSubview(imageLabel)
        itemsStack.addArrangedSubview(temperatureLabel)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupItems()
        setItems()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        self.backgroundColor = .white
    }
}


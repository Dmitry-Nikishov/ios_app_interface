//
//  WeatherDetailsRowView.swift
//  WeatherApp
//
//  Created by Дмитрий Никишов on 09.01.2022.
//

import UIKit

class WeatherDetailRowView : UIView
{
    public var RowImage : UIImage? {
        didSet {
            rowImageView.image = RowImage
        }
    }
    
    public var RowLabel : String? {
        didSet {
            rowLabel.text = RowLabel ?? ""
        }
    }

    public var RowData : String? {
        didSet {
            rowDataLabel.text = RowData ?? ""
        }
    }

    private let rowImageView : UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let rowLabel : UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 14)
        return view
    }()

    private let rowDataLabel : UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 18)
        return view
    }()

    private func setupView()
    {
        addSubview(rowImageView)
        addSubview(rowLabel)
        addSubview(rowDataLabel)
        
        let constraints = [
            rowImageView.heightAnchor.constraint(equalToConstant: 30),
            rowImageView.widthAnchor.constraint(equalToConstant: 24),
            rowImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            rowImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            rowLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            rowLabel.leadingAnchor.constraint(equalTo: rowImageView.trailingAnchor, constant: 16),
            rowLabel.heightAnchor.constraint(equalToConstant: 20),
            
            rowDataLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            rowDataLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            rowDataLabel.heightAnchor.constraint(equalToConstant: 22)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    init(viewFrame : CGRect)
    {
        super.init(frame: viewFrame)
        setupView()
    }

    required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented for WeatherDetailRowView")
    }
}

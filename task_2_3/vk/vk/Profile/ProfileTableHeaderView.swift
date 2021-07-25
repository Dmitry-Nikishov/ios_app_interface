//
//  ProfileTableHeaderView.swift
//  vk
//
//  Created by Дмитрий Никишов on 09.07.2021.
//

import UIKit

class ProfileTableHeaderView: UITableViewHeaderFooterView {
    private var statusText : String = ""
    
    public weak var profileControllerView : UIView?
    
    public weak var profileController : ProfileTableHeaderViewDelegate?
    
    private var viewConstraints : [NSLayoutConstraint] = []
    
    private let fullNameLabel: UILabel = {
        let view = UILabel()
        view.text = "Hipster Pinguin"
        view.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        view.textColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var avatarImage: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.borderWidth = 3
        view.layer.borderColor = UIColor.white.cgColor
        view.image = UIImage(named: "avatar")
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = ProfileTableHeaderViewLayoutConstants.avatarSize/2
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let tapGesture = UITapGestureRecognizer(target : self, action : #selector(avatarImagePressHandler))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
        
        return view
    }()
    
    
    let statusLabel: UILabel = {
        let view = UILabel()
        view.text = "Waiting for something"
        view.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        view.textColor = .gray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let statusTextField: UITextField = {
        let view = TextFieldWithPadding()
        view.placeholder = "add smth to show as status"
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        view.backgroundColor = .white
        view.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        view.textColor = .black
        view.backgroundColor = .white.withAlphaComponent(0)
        view.addTarget(self, action: #selector(statusTextChanged), for : .editingChanged)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let setStatusButton: UIButton = {
        let view = UIButton()
        view.setTitle("Show status", for: .normal)
        view.setTitleColor(.white, for : .normal)
        view.backgroundColor = UIColor(named: "myColor")
        view.layer.cornerRadius = 14
        view.layer.shadowRadius = 4
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.7
        view.layer.shadowOffset = CGSize(width: 4, height: 4)
        view.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var closeAvatarWindowButton : UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        view.setBackgroundImage(UIImage(named : "close_btn"), for: .normal)
        view.addTarget(self, action: #selector(closeAvatarWindowHandler), for: .touchUpInside)
        view.layer.opacity = 0
        return view
    }()
    
    private lazy var blackoutView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.alpha = 0
        return view
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    private func modifyHiddenStateForViews( isHidden : Bool )
    {
        fullNameLabel.isHidden = isHidden
        statusLabel.isHidden = isHidden
        statusTextField.isHidden = isHidden
        setStatusButton.isHidden = isHidden
    }
    
    @objc func closeAvatarWindowHandler()
    {
        modifyHiddenStateForViews(isHidden: false)
        
        NSLayoutConstraint.deactivate(viewConstraints)
        setupInitialConstraints()
        
        let animator = UIViewPropertyAnimator(duration: 0.2, curve: .linear) {
            self.contentView.layoutIfNeeded()
            self.closeAvatarWindowButton.alpha = 0
            self.blackoutView.alpha = 0
            self.avatarImage.layer.cornerRadius = ProfileTableHeaderViewLayoutConstants.avatarSize/2
        }
        
        animator.startAnimation()
        
        profileController?.closeBlackoutView()
        
        contentView.sendSubviewToBack(avatarImage)
        contentView.sendSubviewToBack(closeAvatarWindowButton)
    }
    
    @objc func avatarImagePressHandler()
    {
        guard let controllerView = profileControllerView else {
            return
        }
        
        blackoutView.frame = controllerView.bounds
        
        profileController?.showBlackoutView()
        
        modifyHiddenStateForViews(isHidden: true)
        
        let minOfWidthHeight = min(controllerView.bounds.height, controllerView.bounds.width)
        
        NSLayoutConstraint.deactivate(viewConstraints)
        
        let constraints = [
            closeAvatarWindowButton.topAnchor.constraint(equalTo: controllerView.topAnchor, constant: ProfileTableHeaderViewLayoutConstants.edgeOffsets + controllerView.safeAreaInsets.top),
            
            closeAvatarWindowButton.trailingAnchor.constraint(equalTo: controllerView.trailingAnchor, constant: -ProfileTableHeaderViewLayoutConstants.edgeOffsets - contentView.safeAreaInsets.right),
            
            avatarImage.centerXAnchor.constraint(equalTo: controllerView.centerXAnchor),
            avatarImage.centerYAnchor.constraint(equalTo: controllerView.centerYAnchor),
            avatarImage.widthAnchor.constraint(equalToConstant: minOfWidthHeight - ProfileTableHeaderViewLayoutConstants.edgeOffsets*2),
            avatarImage.heightAnchor.constraint(equalToConstant: minOfWidthHeight - ProfileTableHeaderViewLayoutConstants.edgeOffsets*2)
        ]
        
        NSLayoutConstraint.activate(constraints)
        viewConstraints = constraints
        
        let animator = UIViewPropertyAnimator(duration: 0.5, curve: .linear) {
            self.contentView.layoutIfNeeded()
            self.avatarImage.layer.cornerRadius = 0
            self.blackoutView.alpha = 0.5
        }
        
        animator.addCompletion { _ in
            let animator = UIViewPropertyAnimator(duration: 0.3, curve: .linear) {
                self.closeAvatarWindowButton.alpha = 1
            }
            
            animator.startAnimation()
        }
        animator.startAnimation()
        
        contentView.bringSubviewToFront(avatarImage)
        contentView.bringSubviewToFront(closeAvatarWindowButton)
    }
    
    @objc func buttonPressed()
    {
        statusLabel.text = statusText
    }
    
    @objc func statusTextChanged(_ textField: UITextField)
    {
        statusText = textField.text ?? ""
    }
    
    required init?(coder: NSCoder) {
        fatalError("should not be called")
    }
    
    private func setupViews()
    {
        contentView.addSubview(avatarImage)
        contentView.addSubview(fullNameLabel)
        contentView.addSubview(statusLabel)
        contentView.addSubview(statusTextField)
        contentView.addSubview(setStatusButton)
        contentView.addSubview(closeAvatarWindowButton)
        contentView.addSubview(blackoutView)
        
        setupInitialConstraints()
    }
    
    private func setupInitialConstraints()
    {
        let constraints = [
            closeAvatarWindowButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: ProfileTableHeaderViewLayoutConstants.edgeOffsets),
            closeAvatarWindowButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -ProfileTableHeaderViewLayoutConstants.edgeOffsets),
            
            avatarImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: ProfileTableHeaderViewLayoutConstants.edgeOffsets),
            avatarImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: ProfileTableHeaderViewLayoutConstants.edgeOffsets),
            avatarImage.widthAnchor.constraint(equalToConstant: ProfileTableHeaderViewLayoutConstants.avatarSize),
            avatarImage.heightAnchor.constraint(equalToConstant: ProfileTableHeaderViewLayoutConstants.avatarSize),
            
            fullNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 27),
            fullNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: ProfileTableHeaderViewLayoutConstants.edgeOffsets*2 + ProfileTableHeaderViewLayoutConstants.avatarSize),
            fullNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -ProfileTableHeaderViewLayoutConstants.edgeOffsets),
            
            statusLabel.topAnchor.constraint(equalTo: fullNameLabel.bottomAnchor, constant: 10),
            statusLabel.leadingAnchor.constraint(equalTo: fullNameLabel.leadingAnchor),
            statusLabel.trailingAnchor.constraint(equalTo: fullNameLabel.trailingAnchor),
            
            statusTextField.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 10),
            statusTextField.heightAnchor.constraint(equalToConstant: 40),
            statusTextField.leadingAnchor.constraint(equalTo: statusLabel.leadingAnchor),
            statusTextField.trailingAnchor.constraint(equalTo: statusLabel.trailingAnchor),
            
            setStatusButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: ProfileTableHeaderViewLayoutConstants.edgeOffsets*2 + ProfileTableHeaderViewLayoutConstants.avatarSize),
            setStatusButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: ProfileTableHeaderViewLayoutConstants.edgeOffsets),
            setStatusButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -ProfileTableHeaderViewLayoutConstants.edgeOffsets),
            setStatusButton.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        viewConstraints = constraints
    }
    
}

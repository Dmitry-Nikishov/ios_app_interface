//
//  ProfileTableHeaderView.swift
//  vk
//
//  Created by Дмитрий Никишов on 09.07.2021.
//

import UIKit
import SnapKit

class ProfileTableHeaderView: UITableViewHeaderFooterView {
    private var statusText : String = ""
    
    public weak var profileControllerView : UIView?
    
    public weak var profileController : ProfileTableHeaderViewDelegate?
    
    public weak var statusModel : UserStatusModel?
    
    public var user : User? {
        didSet {
            guard let usr = user else {
                return
            }
            
            fullNameLabel.text = usr.getFullName()
            statusLabel.text = usr.getStatus()
            avatarImage.image = UIImage(named: usr.getAvatarPath())
        }
    }
    
    private let fullNameLabel: UILabel = {
        let view = UILabel()
        view.text = "Hipster Pinguin"
        view.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        view.textColor = .label
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
        view.textColor = .label
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let statusTextField: UITextField = {
        let view = TextFieldWithPadding()
        view.placeholder = "add smth to show as status"
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        view.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        view.textColor = UIColor.createColor(lightMode: .black, darkMode: .white)
        view.backgroundColor = UIColor.createColor(lightMode: .white.withAlphaComponent(0), darkMode: .black)
        view.addTarget(self, action: #selector(statusTextChanged), for : .editingChanged)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var setStatusButton: CustomButton = {
        let button = CustomButton(frame : self.frame, title: "Show status", titleColor: .white)
        button.backgroundColor = UIColor(named: "myColor")
        
        button.layer.cornerRadius = 14
        button.layer.shadowRadius = 4
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.7
        button.layer.shadowOffset = CGSize(width: 4, height: 4)

        return button
    }()
    
    private lazy var closeAvatarWindowButton : CustomButton = {
        let button = CustomButton(frame : self.frame)
        button.setBackgroundImage(UIImage(named : "close_btn"), for: .normal)
        button.isUserInteractionEnabled = true
        button.layer.opacity = 0
        return button
    }()
    
    private lazy var blackoutView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.createColor(lightMode: .black, darkMode: .white)
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
        
    @objc func avatarImagePressHandler()
    {
        guard let controllerView = profileControllerView else {
            return
        }
        
        blackoutView.frame = controllerView.bounds
        
        profileController?.showBlackoutView()
        
        modifyHiddenStateForViews(isHidden: true)
        
        let minOfWidthHeight = min(controllerView.bounds.height, controllerView.bounds.width)
    
        removeConstraints()
        
        closeAvatarWindowButton.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(controllerView).offset(ProfileTableHeaderViewLayoutConstants.edgeOffsets + controllerView.safeAreaInsets.top)
            
            make.trailing.equalTo(controllerView).offset(-ProfileTableHeaderViewLayoutConstants.edgeOffsets - contentView.safeAreaInsets.right)
        }
        
        avatarImage.snp.makeConstraints{ (make) -> Void in
            make.centerX.equalTo(controllerView)
            make.centerY.equalTo(controllerView)
            make.width.equalTo(minOfWidthHeight - ProfileTableHeaderViewLayoutConstants.edgeOffsets*2)
            make.height.equalTo(minOfWidthHeight - ProfileTableHeaderViewLayoutConstants.edgeOffsets*2)
        }
                
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
        
    @objc func statusTextChanged(_ textField: UITextField)
    {
        statusText = textField.text ?? ""
    }
    
    required init?(coder: NSCoder) {
        fatalError("should not be called")
    }
    
    private func setupClickHandlers()
    {
        setStatusButton.clickHandler = { [weak self] in
            guard let self = self else {
                return
            }

            self.statusModel?.checkStatus(status: self.statusText) { result in
                self.statusLabel.textColor = result ? .green : .red
            }

            self.statusLabel.text = self.statusText
        }
        
        closeAvatarWindowButton.clickHandler = { [weak self] in
            guard let self = self else {
                return
            }
            
            self.modifyHiddenStateForViews(isHidden: false)
            
            self.removeConstraints()
            self.setupInitialConstraints()
            
            let animator = UIViewPropertyAnimator(duration: 0.2, curve: .linear) {
                self.contentView.layoutIfNeeded()
                self.closeAvatarWindowButton.alpha = 0
                self.blackoutView.alpha = 0
                self.avatarImage.layer.cornerRadius = ProfileTableHeaderViewLayoutConstants.avatarSize/2
            }
            
            animator.startAnimation()
            
            self.profileController?.closeBlackoutView()
            
            self.contentView.sendSubviewToBack(self.avatarImage)
            self.contentView.sendSubviewToBack(self.closeAvatarWindowButton)
        }
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
     
        setupClickHandlers()
    }
    
    private func removeConstraints()
    {
        closeAvatarWindowButton.snp.removeConstraints()
        avatarImage.snp.removeConstraints()
        fullNameLabel.snp.removeConstraints()
        statusLabel.snp.removeConstraints()
        statusTextField.snp.removeConstraints()
        setStatusButton.snp.removeConstraints()
    }
    
    private func setupInitialConstraints()
    {
        closeAvatarWindowButton.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(contentView).offset(ProfileTableHeaderViewLayoutConstants.edgeOffsets)
            make.trailing.equalTo(contentView).offset(-ProfileTableHeaderViewLayoutConstants.edgeOffsets)
        }
        
        avatarImage.snp.makeConstraints{ (make) -> Void  in
            make.top.equalTo(contentView).offset(ProfileTableHeaderViewLayoutConstants.edgeOffsets)
            make.leading.equalTo(contentView).offset(ProfileTableHeaderViewLayoutConstants.edgeOffsets)
            make.width.equalTo(ProfileTableHeaderViewLayoutConstants.avatarSize)
            make.height.equalTo(ProfileTableHeaderViewLayoutConstants.avatarSize)
        }
        
        fullNameLabel.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(contentView).offset(27)
            make.leading.equalTo(contentView).offset(ProfileTableHeaderViewLayoutConstants.edgeOffsets*2 + ProfileTableHeaderViewLayoutConstants.avatarSize)
            make.trailing.equalTo(contentView).offset(-ProfileTableHeaderViewLayoutConstants.edgeOffsets)
        }
        
        statusLabel.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(fullNameLabel.snp.bottom).offset(10)
            make.leading.equalTo(fullNameLabel)
            make.trailing.equalTo(fullNameLabel)
        }
        
        statusTextField.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(statusLabel.snp.bottom).offset(10)
            make.height.equalTo(40)
            make.leading.equalTo(statusLabel)
            make.trailing.equalTo(statusLabel)
        }
        
        setStatusButton.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(contentView).offset(ProfileTableHeaderViewLayoutConstants.edgeOffsets*2 + ProfileTableHeaderViewLayoutConstants.avatarSize)
            make.leading.equalTo(contentView).offset(ProfileTableHeaderViewLayoutConstants.edgeOffsets)
            make.trailing.equalTo(contentView).offset(-ProfileTableHeaderViewLayoutConstants.edgeOffsets)
            make.height.equalTo(50)
        }
    }
    
}

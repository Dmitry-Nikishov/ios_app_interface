//
//  AppConstants.swift
//  FolderContentViewer
//
//  Created by Дмитрий Никишов on 24.11.2021.
//

import UIKit

enum AppLayoutSettings {
    static let topBottomLayoutOffsetInPercentage : CGFloat = 0.1
    static let leftMarginLayoutOffsetInPercentage : CGFloat = 0.05
    static let loginLabelFontSize : CGFloat = 40
    static let sortingEnableLabelFontSize : CGFloat = 24
    static let enterNewPasswordLabelFontSize : CGFloat = 24
    static let passwordTextInputCornerRadius : CGFloat = 7
    static let passwordTextInputLeftPadding : CGFloat = 10
    static let passwordButtonCorderRadius : CGFloat = 7
}

enum AppCommonStrings {
    static let appName : String = "Folder Content Viewer"
}

enum AppCommonSettings {
    static let passwordMinLength : Int = 4
    static let keychainServiceName : String = "FolderContentViewerService"
    static let keychainAppPasswordKey : String = "app_password"
}

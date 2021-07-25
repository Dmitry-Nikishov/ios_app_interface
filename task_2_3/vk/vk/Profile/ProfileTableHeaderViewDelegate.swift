//
//  ProfileTableHeaderViewDelegate.swift
//  vk
//
//  Created by Дмитрий Никишов on 21.07.2021.
//

import Foundation

protocol ProfileTableHeaderViewDelegate : AnyObject {
    func showBlackoutView()
    
    func closeBlackoutView()
}

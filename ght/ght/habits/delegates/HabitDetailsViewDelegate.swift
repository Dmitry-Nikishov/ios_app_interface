//
//  HabitDetailsViewDelegate.swift
//  ght
//
//  Created by Дмитрий Никишов on 01.08.2021.
//

import UIKit

protocol HabitDetailsViewDelegate : AnyObject {
    func showHabitDetails(habitTitle : String,
                          habitColor : UIColor,
                          habitDate : Date,
                          trackedDates : [Date])
}

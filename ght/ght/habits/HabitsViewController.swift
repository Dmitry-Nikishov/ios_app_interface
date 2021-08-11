//
//  HabitsViewController.swift
//  ght
//
//  Created by Дмитрий Никишов on 27.07.2021.
//

import UIKit

class HabitsViewController: UIViewController {
    private lazy var collectionItemWidth : CGFloat = 0
    
    private lazy var habitsWithProgressCollection : UICollectionView = {
        var layout = UICollectionViewFlowLayout()

        let item = UICollectionView(frame: .zero, collectionViewLayout: layout)
        item.register(
            ProgressCollectionViewCell.self,
            forCellWithReuseIdentifier: String(describing: ProgressCollectionViewCell.self)
        )
        
        item.register(
            HabitCollectionViewCell.self,
            forCellWithReuseIdentifier: String(describing : HabitCollectionViewCell.self))

        item.dataSource = self
        item.delegate = self
        item.backgroundColor = .systemGray6

        item.translatesAutoresizingMaskIntoConstraints = false
        return item
    }()

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Сегодня"
        setupViews()
    }
    
    @objc private func addHabitHandler()
    {
        let controller = HabitViewController()
        controller.dataRefresher = self
        self.navigationController?.pushViewController(controller, animated: false)
    }
    
    private func setupViews()
    {
        collectionItemWidth = view.bounds.width - HabitsCollectionLayoutSettings.contentViewOffset*2
        
        let addHabitButton = UIBarButtonItem(image: UIImage(systemName: "plus"),
                        style: .plain,
                        target: self,
                        action: #selector(addHabitHandler))

        self.navigationItem.rightBarButtonItem = addHabitButton

        view.addSubview(habitsWithProgressCollection)
        
        let constraints = [
            habitsWithProgressCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            habitsWithProgressCollection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            habitsWithProgressCollection.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            habitsWithProgressCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}

extension HabitsViewController : UICollectionViewDataSource
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var itemsInSection : Int = 0
        switch section {
        case 0:
            itemsInSection = 1
        case 1 :
            itemsInSection = HabitsStore.shared.habits.count
        default:
            itemsInSection = 0
        }
        
        return itemsInSection
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell =
                habitsWithProgressCollection.dequeueReusableCell(
                    withReuseIdentifier: String(describing: ProgressCollectionViewCell.self),
                    for: indexPath) as! ProgressCollectionViewCell

            cell.currentProgress = HabitsStore.shared.todayProgress
            return cell
        } else {
            let cell =
                habitsWithProgressCollection.dequeueReusableCell(
                    withReuseIdentifier: String(describing: HabitCollectionViewCell.self),
                    for: indexPath) as! HabitCollectionViewCell
            
            cell.habitId = HabitsStore.shared.habits[indexPath.row]
            cell.habitDetailsViewReloadableController = self
            return cell
        }
    }
}

extension HabitsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0 {
            return CGSize(width: collectionItemWidth,
                          height: HabitsCollectionLayoutSettings.progressCollectionViewHeight)

        } else {
            return CGSize(width: collectionItemWidth,
                          height: HabitsCollectionLayoutSettings.habitCollectionViewHeight)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: HabitsCollectionLayoutSettings.sectionOffset,
                            left: 0,
                            bottom: 0,
                            right: 0)
    }
}

extension HabitsViewController : HabitDetailsViewReloadDelegate {
    func showHabitDetails(habitTitle : String,
                          habitColor : UIColor,
                          habitDate : Date,
                          trackedDates : [Date]) {        
        let detailsViewController = HabitDetailsViewController()
        detailsViewController.controllerTitle = habitTitle
        detailsViewController.habitColor = habitColor
        detailsViewController.habitDate = habitDate
        detailsViewController.dataRefresher = self
        detailsViewController.trackedDates = trackedDates

        self.navigationController?.pushViewController(detailsViewController, animated: false)
    }
    
    func reloadContent() {
        habitsWithProgressCollection.reloadData()
    }
}


//
//  AudioPlayerView.swift
//  AVFoundation_Audio
//
//  Created by Дмитрий Никишов on 09.10.2021.
//

import UIKit

class AudioPlayerView : UIView {
    
    public var playHandler : VoidHander? = nil
    public var stopHandler : VoidHander? = nil
    public var pauseHandler : VoidHander? = nil
    public var streamPlayHandler : StreamPlayHandler? = nil
    
    public var songName : String = "" {
        didSet {
            songLabel.text = songName
        }
    }
    
    public var selectedSong : String {
        get {
            return songsArray[songsPickerView.selectedRow(inComponent: 0)]
        }
    }
    
    private let songsArray = ["Queen", "gonna far", "nothing else matters", "the kids"]
    
    private lazy var urlDescriptions : [String] =
    ["BipBop Adv Example",
     "Apple Watch",
     "AR",
     "ARC in swift"]
    
    private lazy var streamUrlsWithDescription : Dictionary<String, URL> =
    ["BipBop Adv Example" : URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_adv_example_hevc/master.m3u8")!,
    
     "Apple Watch" : URL(string:
                        "https://devstreaming-cdn.apple.com/videos/wwdc/2021/10308/18/BA664ADF-042F-4084-8565-61FC83578C92/cmaf.m3u8")!,
     "AR" : URL(string:
               "https://devstreaming-cdn.apple.com/videos/wwdc/2021/10078/7/D952E090-6CA8-4748-9B71-385AC16452AF/cmaf.m3u8")!,
     
     "ARC in swift" : URL(string :
                         "https://devstreaming-cdn.apple.com/videos/wwdc/2021/10216/4/884C234F-2424-47DF-A4CF-A9010D869C66/cmaf.m3u8")!
    ]
    


    private lazy var songsPickerView: UIPickerView = {
        let pv = UIPickerView()
        pv.dataSource = self
        pv.backgroundColor = .white
        pv.delegate = self
        pv.translatesAutoresizingMaskIntoConstraints = false
        return pv
    }()

    private let playBtn : UIButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "play"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let pauseBtn : UIButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "pause"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let stopBtn : UIButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "stop"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let songLabel : UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 16)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let tableView : UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
        
    private func setupTableView()
    {
        tableView.register(TableVideoCell.self, forCellReuseIdentifier: String(describing: TableVideoCell.self))
        
        tableView.dataSource = self

        tableView.delegate = self
    }
    
    private func setupConstraints() {
        let constraints = [
            playBtn.widthAnchor.constraint(equalToConstant: AppConstants.playBtnSize),
            playBtn.heightAnchor.constraint(equalToConstant: AppConstants.playBtnSize),
            playBtn.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            playBtn.centerXAnchor.constraint(equalTo: self.centerXAnchor),

            pauseBtn.widthAnchor.constraint(equalToConstant: AppConstants.playBtnSize),
            pauseBtn.heightAnchor.constraint(equalToConstant: AppConstants.playBtnSize),
            pauseBtn.trailingAnchor.constraint(equalTo: playBtn.leadingAnchor, constant: -AppConstants.stopPayseBtnOffset),
            pauseBtn.topAnchor.constraint(equalTo: playBtn.topAnchor),

            stopBtn.widthAnchor.constraint(equalToConstant: AppConstants.playBtnSize),
            stopBtn.heightAnchor.constraint(equalToConstant: AppConstants.playBtnSize),
            stopBtn.topAnchor.constraint(equalTo: playBtn.topAnchor),
            stopBtn.leadingAnchor.constraint(equalTo: playBtn.trailingAnchor, constant: AppConstants.stopPayseBtnOffset),
            
            songLabel.heightAnchor.constraint(equalToConstant: AppConstants.songLabelHeight),
            songLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            songLabel.bottomAnchor.constraint(equalTo: playBtn.topAnchor, constant: -AppConstants.stopPayseBtnOffset),
            
            songsPickerView.bottomAnchor.constraint(equalTo: songLabel.topAnchor, constant: -AppConstants.stopPayseBtnOffset/2),
            songsPickerView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            songsPickerView.heightAnchor.constraint(equalToConstant: AppConstants.songLabelHeight*4),
            
            tableView.leadingAnchor.constraint(equalTo: pauseBtn.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: stopBtn.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: pauseBtn.bottomAnchor, constant: AppConstants.stopPayseBtnOffset),
            tableView.heightAnchor.constraint(equalToConstant: AppConstants.songLabelHeight*5)
            
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupViews()
    {
        addSubview(playBtn)
        addSubview(stopBtn)
        addSubview(pauseBtn)
        addSubview(songLabel)
        addSubview(songsPickerView)
        addSubview(tableView)
        
        setupConstraints()
    }
    
    private func setupHandlers()
    {
        playBtn.addTarget(self, action: #selector(playBtnClickHandler), for: .touchUpInside)
        stopBtn.addTarget(self, action: #selector(stopBtnClickHandler), for: .touchUpInside)
        pauseBtn.addTarget(self, action: #selector(pauseBtnClickHandler), for: .touchUpInside)
    }
        
    @objc
    private func playBtnClickHandler()
    {
        self.playHandler?()
    }
    
    @objc
    private func stopBtnClickHandler()
    {
        self.stopHandler?()
    }
    
    @objc
    private func pauseBtnClickHandler()
    {
        self.pauseHandler?()
    }
    
    init(viewFrame : CGRect) {
        super.init(frame: viewFrame)
        self.backgroundColor = .systemBackground
        
        setupTableView()
        setupViews()
        setupHandlers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented for SettingsView")
    }
}

extension AudioPlayerView: UIPickerViewDataSource, UIPickerViewDelegate {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
        
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       return songsArray.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       return songsArray[row]
    }
}

extension AudioPlayerView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return urlDescriptions.count
    }
}

extension AudioPlayerView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TableVideoCell.self)) as! TableVideoCell
        
        cell.videoDescription = urlDescriptions[indexPath.section]
        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if let indexPathForSelectedRow = tableView.indexPathForSelectedRow,
             indexPathForSelectedRow == indexPath {
             tableView.deselectRow(at: indexPath, animated: false)
             return nil
        }
        
        let urlId  = urlDescriptions[indexPath.section]
        streamPlayHandler?(streamUrlsWithDescription[urlId]!)

        return indexPath
    }
}


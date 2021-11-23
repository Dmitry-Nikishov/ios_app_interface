import UIKit
import AVFoundation
import AVKit

class ViewController: UIViewController {
    private var Player = AVAudioPlayer()

    private func playStream(urlToPlay: URL) {
         let player = AVPlayer(url: urlToPlay)

         let controller = AVPlayerViewController()
         controller.player = player

         present(controller, animated: true) {
             player.play()
         }
     }

    private func setView()
    {
        let playerView = AudioPlayerView(viewFrame: self.view.frame)
        
        playerView.streamPlayHandler = { [weak self] streamId in
            guard let self = self else {
                return
            }

            self.playStream(urlToPlay:streamId)
        }
        
        playerView.pauseHandler = { [weak self] in
            guard let self = self else {
                return
            }
            
            if self.Player.isPlaying {
                self.Player.pause()
            }
        }
        
        playerView.stopHandler = { [weak self] in
            guard let self = self else {
                return
            }
            if self.Player.isPlaying {
                self.Player.stop()
                self.Player.currentTime = 0
            }
        }
        
        playerView.playHandler = { [weak self] in
            guard let self = self else {
                return
            }
            
            self.startRecordPlaying(songName: playerView.selectedSong)
            
            guard let song = self.Player.url else {
                return
            }

            playerView.songName = song.lastPathComponent
        }
        
        self.view = playerView
    }
    
    private func startRecordPlaying(songName : String)
    {
        do {
            if let url = Player.url {
                if url.lastPathComponent == songName + ".mp3" {
                    Player.play()
                    return
                }
            }

            Player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: songName, ofType: "mp3")!))
            Player.prepareToPlay()
            Player.play()
        }
        catch {
            print(error)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
    }
}

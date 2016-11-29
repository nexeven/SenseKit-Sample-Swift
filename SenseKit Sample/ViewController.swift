import UIKit
import AVFoundation
import AVKit
import SenseKit

let videosURL = "http://dev.nexeven.se/AgentValidation/iOS/assetList.plist"

class ViewController : UITableViewController {
    var videos: NSArray = NSArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let release = NSDictionary(contentsOf: URL(string: videosURL)!)!
        videos = release.object(forKey: "Videos") as! NSArray
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        let video = videos.object(at: indexPath.row) as! NSDictionary
        cell.titleLabel.text = video.object(forKey: "Title") as? String
        cell.desciptionLabel.text = video.object(forKey: "Description") as? String
        cell.durationLabel.text = video.object(forKey: "Duration") as? String
        cell.thumbnailImageView.setImage(urlString: video.object(forKey: "ImageUrl") as! String)
        
        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let video = videos.object(at: indexPath.row) as! NSDictionary
        
        loadVideoPlayer(
            url: video.object(forKey: "VideoUrl") as! String,
            assetId: video.object(forKey: "AssetID") as! String,
            assetName: video.object(forKey: "Title") as! String,
            assetType: video.object(forKey: "AssetType") as! String
        )
    }
    
    func loadVideoPlayer(url: String, assetId: String, assetName: String, assetType: String) {
        let playerItem = AVPlayerItem(url: URL(string: url)!)
        
        let player = AVPlayer(playerItem: playerItem)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        playerViewController.allowsPictureInPicturePlayback = true
        playerViewController.showsPlaybackControls = true
        
        let pair1 = CustomMetadata()
        
        pair1.key = "AMK1"
        pair1.values = ["AMV1", "AMV11"]
        
        let pair2 = CustomMetadata()
        
        pair2.key = "CMK1"
        pair2.values = ["CMV1", "CMV11"]
    
        SenseKit.plugin(
            forAVPlayer: player,
            assetId: assetId,
            nxeCID: "BBQCID",
            assetType: assetType,
            assetName: assetName,
            viewerId: "jorgenS",
            assetMetadata: [pair1],
            viewerMetadata: [pair2]
        )
       
        playerViewController.player?.play()
        
        NotificationCenter.default.addObserver(self, selector: #selector(itemDidPlayToEndTime), name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        
        present(playerViewController, animated: true)
    }
    
    func itemDidPlayToEndTime() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { [weak self] _ in
            self?.dismiss(animated: true)
        }
    }
}

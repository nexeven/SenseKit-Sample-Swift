import AVKit
import SenseKit

class PlayerViewController : AVPlayerViewController {
    override func viewWillDisappear(_ animated: Bool) {
        SenseKit.stopPlayback()
        super.viewWillDisappear(animated)
    }
}

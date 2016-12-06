import AVKit
import SenseKit

class PlayerViewController : AVPlayerViewController {

    var senseAgent: SenseAgent?

    override func viewWillDisappear(_ animated: Bool) {
        senseAgent?.endSession()
        super.viewWillDisappear(animated)
    }

    deinit {
        senseAgent = nil
    }
}

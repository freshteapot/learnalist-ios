import Foundation
// http://stackoverflow.com/questions/25951980/do-something-every-x-minutes-in-swift

class LearnalistSync {
    var timer: DispatchSourceTimer?

    func startTimer() {
        let queue = DispatchQueue(label: "net.learnalist.sync.list.timer")
        timer = DispatchSource.makeTimerSource(queue: queue)

        // Every 5 minutes we try
        timer!.scheduleRepeating(deadline: .now(), interval: .seconds(60*5))
        timer!.setEventHandler { [weak self] in
            // Ping learnalist to get a hash to know if we should update the sync.
            print("Trying to check sync.")
        }
        timer!.resume()
    }

    func stopTimer() {
        timer?.cancel()
        timer = nil
    }

    deinit {
        self.stopTimer()
    }
}

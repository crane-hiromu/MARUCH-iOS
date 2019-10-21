
import AVFoundation
import RxSwift
import RxCocoa

extension Reactive where Base: AVPlayerItem {

    var asset: Observable<AVAsset?> {
        return self.observe(
            AVAsset.self, #keyPath(AVPlayerItem.asset)
        )
    }

    var duration: Observable<CMTime> {
        return self.observe(
            CMTime.self, #keyPath(AVPlayerItem.duration)
            ).map { $0 ?? CMTime.zero }
    }

    var error: Observable<NSError?> {
        return self.observe(
            NSError.self, #keyPath(AVPlayerItem.error)
        )
    }

    var loadedTimeRanges: Observable<[NSValue]> {
        return self.observe(
            [NSValue].self, #keyPath(AVPlayerItem.loadedTimeRanges)
            ).map { $0 ?? [] }
    }

    var presentationSize: Observable<CMTime> {
        return self.observe(
            CMTime.self, #keyPath(AVPlayerItem.presentationSize)
            ).map { $0 ?? CMTime.zero }
    }

    var status: Observable<AVPlayerItem.Status> {
        return self.observe(
            AVPlayerItem.Status.self, #keyPath(AVPlayerItem.status)
            ).map { $0 ?? .unknown }
    }

    var timebase: Observable<CMTimebase?> {
        return self.observe(
            CMTimebase.self, #keyPath(AVPlayerItem.timebase)
        )
    }

    var tracks: Observable<[AVPlayerItemTrack]> {
        return self.observe(
            [AVPlayerItemTrack].self, #keyPath(AVPlayerItem.tracks)
            ).map { $0 ?? [] }
    }

    // MARK: - Moving the Playhead

    var seekableTimeRanges: Observable<[NSValue]> {
        return self.observe(
            [NSValue].self, #keyPath(AVPlayerItem.seekableTimeRanges)
            ).map { $0 ?? [] }
    }

    // MARK: - Information About Playback
    var isPlaybackLikelyToKeepUp: Observable<Bool> {
        return self.observe(
            Bool.self, #keyPath(AVPlayerItem.isPlaybackLikelyToKeepUp)
            ).map { $0 ?? false }
    }

    var isPlaybackBufferEmpty: Observable<Bool> {
        return self.observe(
            Bool.self, #keyPath(AVPlayerItem.isPlaybackBufferEmpty)
            ).map { $0 ?? false }
    }

    var isPlaybackBufferFull: Observable<Bool> {
        return self.observe(
            Bool.self, #keyPath(AVPlayerItem.isPlaybackBufferFull)
            ).map { $0 ?? false }
    }

}

// MARK: - Notification

extension Reactive where Base: AVPlayerItem {

    var didPlayToEnd: Observable<Notification> {
        return NotificationCenter
            .default
            .rx
            .notification(.AVPlayerItemDidPlayToEndTime, object: base)
            .filter { notification in
                if let obj = notification.object as? Base, obj == self.base {
                    return true
                } else {
                    return false
                }
        }
    }

    var timeJumped: Observable<Notification> {
        return NotificationCenter
            .default
            .rx
            .notification(.AVPlayerItemTimeJumped, object: base)
            .filter { notification in
                if let obj = notification.object as? Base, obj == self.base {
                    return true
                } else {
                    return false
                }
        }
    }

    var failedToPlayToEndTime: Observable<Notification> {
        return NotificationCenter
            .default
            .rx
            .notification(.AVPlayerItemFailedToPlayToEndTime, object: base)
            .filter { notification in
                if let obj = notification.object as? Base, obj == self.base {
                    return true
                } else {
                    return false
                }
        }
    }

    var playbackStalled: Observable<Notification> {
        return NotificationCenter
            .default
            .rx
            .notification(.AVPlayerItemPlaybackStalled, object: base)
            .filter { notification in
                if let obj = notification.object as? Base, obj == self.base {
                    return true
                } else {
                    return false
                }
        }
    }

    var newAccessLogEntry: Observable<Notification> {
        return NotificationCenter
            .default
            .rx
            .notification(.AVPlayerItemNewAccessLogEntry, object: base)
            .filter { notification in
                if let obj = notification.object as? Base, obj == self.base {
                    return true
                } else {
                    return false
                }
        }
    }

    var newErrorLogEntry: Observable<Notification> {
        return NotificationCenter
            .default
            .rx
            .notification(.AVPlayerItemNewErrorLogEntry, object: base)
            .filter { notification in
                if let obj = notification.object as? Base, obj == self.base {
                    return true
                } else {
                    return false
                }
        }
    }
}

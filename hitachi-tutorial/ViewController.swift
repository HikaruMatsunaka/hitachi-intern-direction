//1曲で音量を調節する
import UIKit
import AVFoundation
import MapKit
import CoreMotion

class ViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var image: UIImageView!
    var player: AVPlayer?
    let motionManager = CMMotionManager()
    var currentVolume: Float = 0.5
    var isPlaying = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sampleImage = UIImage(named: "sample1.jpg")
        image.image = sampleImage
        //音楽のファイルパス
        let url = Bundle.main.bundleURL.appendingPathComponent("sample1.mp3")
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        //再生
//        player?.play()
        //ボリュームの初期値
        player?.volume = currentVolume

        if motionManager.isGyroAvailable {
            motionManager.gyroUpdateInterval = 0.01
            motionManager.startGyroUpdates(to: OperationQueue.current!) { [weak self] (data, error) in
                guard let rotation = data?.rotationRate else { return }

                //軸を指定
                let yaw = rotation.z
                self?.updateVolumeBasedOnYaw(yaw)
            }
        }
    }
    
    func updateVolumeBasedOnYaw(_ yaw: Double) {
        var volume: Float
        if yaw > 0 {
            volume = Float(min(1, currentVolume + (Float(yaw) / 20)))
        } else {
            volume = Float(max(0, currentVolume + (Float(yaw) / 20)))
        }

        currentVolume = volume
        player?.volume = volume
    }
    @IBAction func playButtonTapped(_ sender: Any) {
        if isPlaying {
            // 再生中の場合、一時停止する
            player?.pause()
            isPlaying = false
            playButton.setTitle("再生", for: .normal)
        } else {
            // 一時停止中の場合、再生する
            player?.play()
            isPlaying = true
            playButton.setTitle("一時停止", for: .normal)
        }
    }
}

//
//  ViewController.swift
//  hitachi-tutorial
//
//  Created by 松中光 on 2023/02/15.
//

//import UIKit
//import CoreLocation
//import MapKit
//
//class ViewController: UIViewController, CLLocationManagerDelegate {
//    //位置情報の機能を管理する'CLLocationManagerクラスのインスタンスを宣言する
//    var locationManager: CLLocationManager!
//    @IBOutlet weak var mapView: MKMapView!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupLocationManager()
//    }
//
//    func setupLocationManager(){
//        //locationManagerを初期化する。
//        locationManager=CLLocationManager()
//        //locationManagerオブジェクトが初期化に成功しているか確認
//        guard let locationManager = locationManager else {return}
//        //「アプリ使用中のみ許可」を使う
//        locationManager.requestWhenInUseAuthorization()
//        //ユーザの許可状態
//        let status = CLLocationManager.authorizationStatus()
//        //許可された場合
//        if status == .authorizedWhenInUse {
//            locationManager.distanceFilter = 10
//            locationManager.startUpdatingLocation()
//        }
//    }
//    //デリゲートメソッド
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        //初期位置
//            let location = locations.first
//        //緯度軽度の格納
//            let latitude = location?.coordinate.latitude
//            let longitude = location?.coordinate.longitude
//
//            print("latitude: \(latitude!)\nlongitude: \(longitude!)")
//        }
//}
//

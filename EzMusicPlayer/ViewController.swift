//
//  ViewController.swift
//  EzMusicPlayer
//
//  Created by Tu on 5/15/17.
//  Copyright © 2017 Moza. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class ViewController: UIViewController,AVAudioPlayerDelegate, UIScrollViewDelegate {
    @IBOutlet weak var txtView_lyric: UITextView!
    @IBOutlet weak var lb_songName: UILabel!
    @IBOutlet weak var lb_singer: UILabel!
    @IBOutlet weak var scrollView_img: UIScrollView!
    @IBOutlet weak var lb_currentTime: UILabel!
    @IBOutlet weak var lb_totalTime: UILabel!
    @IBOutlet weak var slider_process: UISlider!
    @IBOutlet weak var btn_shuffle: UIButton!
    @IBOutlet weak var btn_rewind: UIButton!
    @IBOutlet weak var btn_play: UIButton!
    @IBOutlet weak var btn_forward: UIButton!
    @IBOutlet weak var btn_repeat: UIButton!
    @IBOutlet weak var controllBar: UIView!
    @IBOutlet weak var infoBar: UIView!
    var player:AVAudioPlayer!
    var isShuffle = false
    var isRepeat = false
    var songImage = [#imageLiteral(resourceName: "song1"),#imageLiteral(resourceName: "song2"),#imageLiteral(resourceName: "song3")]
    var songList = ["song1","song2","song3"]
    let namesongs = ["Phía Sau Một Cô Gái","Nơi Này Có Anh","Anh Đã Quen Với Cô Đơn"]
    var singers = ["Soobin Hoàng Sơn","Sơn Thùng - Ôm Ti Vi","Soobin Hoàng Sơn"]
    var lyrics = ["Verse I:\nNhiều khi anh mong được một lần nói ra hết tất cả thay vì\nNgồi lặng im nghe em kể về anh ta bằng đôi mắt lấp lánh\nĐôi lúc em tránh ánh mắt của anh\nVì dường như lúc nào em cũng hiểu thấu lòng anh.\nKo thể ngắt lời, càng ko thể để giọt lệ nào đc rơi\nChorus:\nNên anh lùi bước về sau, để thấy em rõ hơn\nĐể có thể ngắm em từ xa âu yếm hơn\nCả nguồn sống bỗng chốc thu bé lại vừa bằng 1 cô gái\nHay anh vẫn sẽ lặng lẽ kế bên\nDù ko nắm tay nhưng đường chung mãi mãi\nVà từ ấy ánh mắt anh hồn nhiên đến lạ\nVerse II:\nChẳng một ai có thể cản được trái tim khi đã lỡ yêu rồi\nĐừng ai can ngăn tôi khuyên tôi buông xuôi vì yêu không có lỗi\nAi cũng ước muốn khao khát được yêu\nĐược chờ mong tới giờ ai nhắc đưa đón buổi chiều\nMỗi sáng thức dậy được ngắm một người nằm cạnh ngủ say.\nChorus:\n[ Nên anh lùi bước về sau, để thấy em rõ hơn\nĐể có thể ngắm em từ xa âu yếm hơn\nCả nguồn sống bỗng chốc thu bé lại vừa bằng 1 cô gái\nHay anh vẫn sẽ lặng lẽ kế bên\nDù ko nắm tay nhưng đường chung mãi mãi\nVà từ ấy ánh mắt anh hồn nhiên đến lạ]x 2\nVì sao anh không thể gặp được em sớm hơn",
                  "Em là ai từ đâu bước đến nơi đây dịu dàng chân phương\nEm là ai tựa như ánh nắng ban mai ngọt ngào trong sương\nNgắm em thật lâu con tim anh yếu mềm\nĐắm say từ phút đó từng giây trôi yêu thêm.\n\nBao ngày qua bình minh đánh thức xua tan bộn bề nơi anh\nBao ngày qua niềm thương nỗi nhớ bay theo bầu trời trong xanh\nLiếc đôi hàng mi mong manh anh thẫn thờ\nMuốn hôn nhẹ mái tóc bờ môi em, anh mơ.\n\n[ĐK:]\nCầm tay anh, dựa vai anh\nKề bên anh nơi này có anh\nGió mang câu tình ca\nNgàn ánh sao vụt qua nhẹ ôm lấy em\n(Yêu em thương em con tim anh chân thành).\n\nCầm tay anh, dựa vai anh\nKề bên anh nơi này có anh\nKhép đôi mi thật lâu\nNguyện mãi bên cạnh nhau\nYêu say đắm như ngày đầu.\n\nMùa xuân đến bình yên cho anh những giấc mơ\nHạ lưu giữ ngày mưa ngọt ngào nên thơ\nMùa thu lá vàng rơi đông sang anh nhớ em\nTình yêu bé nhỏ xin dành tặng riêng em.\n[Rap:]\nCòn đó tiếng nói ấy bên tai vấn vương bao ngày qua\nÁnh mắt bối rối nhớ thương bao ngày qua\nYêu em anh thẫn thờ, con tim bâng khuâng đâu có ngờ\nChẳng bao giờ phải mong chờ\nĐợi ai trong chiều hoàng hôn mờ\nĐắm chìm hoà vào vần thơ\nNgắm nhìn khờ dại mộng mơ\nĐừng bước vội vàng rồi làm ngơ\nLạnh lùng đó làm bộ dạng thờ ơ \nNhìn anh đi em nha \nHướng nụ cười cho riêng anh nha \nĐơn giản là yêu con tim anh lên tiếng thôi. \n\n* Uhhhhhhhh nhớ thương em \nUhhhhhhhh nhớ thương em lắm \nAhhhhhhh phía sau chân trời \nCó ai băng qua lối về cùng em đi trên đoạn đường dài.",
                  "Anh thường hay vẫn nằm mơ\nVề một ngôi nhà, ở một nơi chỉ có đôi ta\n\nNơi đã có anh và em xây từng câu chuyện\nCùng sẻ chia về những ước mơ\n\nTrên trời cao, muôn vì sao, soi từng con đường\nHòa làn mây cùng gió đến đây\n\nEm đã nói sẽ ở bên anh thật lâu\nChẳng thể quên được những vấn vương\n\nCó thể anh mơ\nChỉ là giấc mơ về một hạnh phúc\nNắng phai trên mi ai\nGiờ em nơi đâu có biết chăng nơi này\n\nCó lẽ em đã quên rồi\nTừng chiếc ôm trong tiết sang trời trở đông\nNhững ngón tay ta đan chặt\nNhìn nhau thật lâu và chẳng cần nói điều gì\n\nEverynight Alone\nĐừng để giọt nước mắt vẫn rơi tàn hoa khắp nơi thiếu em babe\n\nEverynight Alone\nLại gọi tên những nổi nhớ đong đầy\n\nBao đam mê cũng đã chóng phai\nYêu em ko biết đúng sai \nChỉ bằng cảm xúc bằng lý trí bằng tất cả những gì anh có \nHay em cho \nKhi hai con tim lệch nhịp \nAnh có cố gắng thế nào, em cũng không hiểu được em \nNhư là bản thân chính em."]
    var timer:Timer!
    var songNumber = 0
    var imageViews = [UIImageView]()
    let kRotationAnimationKey = "com.myapplication.rotationanimationkey"
    var currentDegree = CGFloat(0)
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView_img.delegate = self
        scrollView_img.showsHorizontalScrollIndicator = false
        drawView()
        for i in 0..<songList.count {
            playScroll(index: i)
        }
        playSong(index: 0)
    }
    func drawView(){
        controllBar.layer.shadowOffset = CGSize.zero
        controllBar.layer.shadowColor = UIColor.black.cgColor
        controllBar.layer.shadowOpacity = 1
        controllBar.layer.shadowRadius = 2
        
        infoBar.layer.shadowOffset = CGSize.zero
        infoBar.layer.shadowColor = UIColor.black.cgColor
        infoBar.layer.shadowOpacity = 1
        infoBar.layer.shadowRadius = 2
        
        let designView = UIView()
        designView.frame = CGRect(x: 400, y: 0, width: 40, height: 300)
        designView.backgroundColor = UIColor(red:1.00, green:0.00, blue:0.23, alpha:1.00)
        designView.layer.shadowOffset = CGSize.zero
        designView.layer.shadowColor = UIColor.black.cgColor
        designView.layer.shadowOpacity = 1
        designView.layer.shadowRadius = 2
//        controllBar.bringSubview(toFront: infoBar)
//        designView.bringSubview(toFront: infoBar)
        designView.transform = CGAffineTransform(rotationAngle: CGFloat(-0.785398163))
        
        let designLabel = UILabel()
        designLabel.frame = CGRect(x: 335, y: 105, width: 100, height: 20)
        designLabel.transform = CGAffineTransform(rotationAngle: CGFloat(0.785398163))
        designLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        designLabel.textColor = UIColor.white
        designLabel.textAlignment = .center
        designLabel.text = "HOT"
        designLabel.bringSubview(toFront: designView)
        self.view.insertSubview(designLabel, aboveSubview: infoBar)
        self.view.insertSubview(designView, belowSubview: infoBar)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func playScroll(index: Int) {
        let imgView = UIImageView()
        
        imgView.image = songImage[index]
        let position = Int(self.scrollView_img.frame.width) * index
        imgView.frame = CGRect(x: CGFloat(position), y: 0, width: self.scrollView_img.frame.width, height: self.scrollView_img.frame.height)
        scrollView_img.contentSize.width = scrollView_img.frame.width * CGFloat(index + 1)
        
        imgView.layer.masksToBounds = false
        imgView.layer.cornerRadius = imgView.frame.height/2
        imgView.clipsToBounds = true
        imageViews.append(imgView)
        scrollView_img.addSubview(imgView)
    }
    //Mark: Rotate Animation
    func rotateView(view: UIImageView, duration: Double = 10) {
        if let presentationLayer = view.layer.presentation(), let zValue = presentationLayer.value(forKeyPath: "transform.rotation"){
            currentDegree = zValue as! CGFloat
        }
        
        if view.layer.animation(forKey: kRotationAnimationKey) == nil {
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
            rotationAnimation.fromValue = currentDegree
            rotationAnimation.toValue = Float(M_PI * 2.0)
            rotationAnimation.duration = duration
            rotationAnimation.repeatCount = Float.infinity
            view.layer.add(rotationAnimation, forKey: kRotationAnimationKey)
        }
    }
    
    func stopRotatingView(view: UIView) {
        if view.layer.animation(forKey: kRotationAnimationKey) != nil {
            view.layer.removeAnimation(forKey: kRotationAnimationKey)
            currentDegree = CGFloat(Float(0))
        }
    }
    func pauseRotatingView(view: UIView) {
        if let presentationLayer = view.layer.presentation(), let zValue = presentationLayer.value(forKeyPath: "transform.rotation"){
            currentDegree = zValue as! CGFloat
        }
        
        if view.layer.animation(forKey: kRotationAnimationKey) != nil {
            view.layer.removeAnimation(forKey: kRotationAnimationKey)
        }
        view.layer.transform = CATransform3DMakeRotation(currentDegree, 0, 0, 1)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = scrollView_img.contentOffset.x / self.scrollView_img.frame.size.width
        if Int(index) != songNumber {
            stopRotatingView(view: imageViews[songNumber])
            songNumber = Int(index)
            playSong(index: songNumber)
            updateLabel(index: songNumber)
        }
    }
    
    func playSong(index: Int) {
        do{
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: .defaultToSpeaker)
        } catch {
        }
        if let path = Bundle.main.path(forResource: "\(songList[index])", ofType: "mp3") {
            let url = URL(fileURLWithPath: path)
            do {
                rotateView(view: imageViews[index])
                txtView_lyric.text = lyrics[index]
                btn_play.setImage(#imageLiteral(resourceName: "ic_pause_white"), for: .normal)
                player = try AVAudioPlayer(contentsOf: url)
                player.prepareToPlay()
                player.play()
                player.delegate = self
                let currentTime = Int(player.duration)
                let minutes = currentTime/60
                let second = currentTime - minutes * 60
                lb_totalTime.text = NSString(format: "%02d:%02d", minutes, second) as String
                slider_process.minimumValue = 0.0
                slider_process.maximumValue = Float(player.duration)
                MPNowPlayingInfoCenter.default().nowPlayingInfo = [
                    MPMediaItemPropertyTitle: "\(songList[index])",
                    MPMediaItemPropertyArtist: "\(singers[index])"
                ]
                UIApplication.shared.beginReceivingRemoteControlEvents()
                becomeFirstResponder()
                timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateSlider), userInfo: nil, repeats: true)
            } catch {
                print("fail")
            }
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if isShuffle == false {
            if flag == true && songNumber < (songList.count - 1) {
                scrollView_img.setContentOffset(CGPoint(x: self.scrollView_img.frame.size.width * CGFloat(songNumber + 1), y: 0), animated: true)
                updateLabel(index: songNumber + 1)
                playSong(index: songNumber + 1)
                songNumber += 1
            } else if flag == true && songNumber == songList.count - 1 {
                scrollView_img.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                updateLabel(index: 0)
                playSong(index: 0)
                songNumber = 0
            }
        } else {
            let randomNumber = randomSong()
            print(randomNumber)
            scrollView_img.setContentOffset(CGPoint(x:self.scrollView_img.frame.size.width * CGFloat(randomNumber), y:0), animated: true)
            updateLabel(index: randomNumber)
            playSong(index: randomNumber)
            songNumber = randomNumber
        }
    }
    
    func randomSong() -> Int {
        var randomNumber = arc4random_uniform(UInt32(songList.count))
        while songNumber == Int(randomNumber - 1) {
            randomNumber = arc4random_uniform(UInt32(songList.count))
        }
        return Int(randomNumber)
    }
    
    func updateSlider() {
        let currentTime = Int(player.currentTime)
        let minutes = currentTime/60
        let seconds = currentTime - minutes * 60
        lb_currentTime.text = NSString(format: "%02d:%02d", minutes, seconds) as String
        let currentValue = Float(currentTime)
        slider_process.value = currentValue
    }
    
    func updateLabel(index:Int) {
        stopRotatingView(view: imageViews[songNumber])
        rotateView(view: imageViews[index])
        lb_songName.text = namesongs[index]
        lb_singer.text = singers[index]
        txtView_lyric.text = lyrics[index]
    }
    
    @IBAction func sliderChange(_ sender: UISlider) {
        player.currentTime = TimeInterval(slider_process.value)
    }
    @IBAction func pause(_ sender: UIButton) {
        if player.isPlaying == false {
            player.play()
            rotateView(view: imageViews[songNumber])
            btn_play.setImage(#imageLiteral(resourceName: "ic_pause_white"), for: .normal)
        } else {
            player.pause()
            pauseRotatingView(view: imageViews[songNumber])
            btn_play.setImage(#imageLiteral(resourceName: "ic_play_white"), for: .normal)
        }
    }
    @IBAction func forward (_ sender: UIButton) {
        if songNumber < songList.count - 1{
            scrollView_img.setContentOffset(CGPoint(x:self.scrollView_img.frame.size.width * CGFloat(songNumber + 1), y:0), animated: true)
            updateLabel(index: songNumber + 1)
            playSong(index: songNumber + 1)
            songNumber += 1
        } else if songNumber == songList.count - 1{
            scrollView_img.setContentOffset(CGPoint(x:0,y:0), animated: true)
            updateLabel(index: 0)
            playSong(index: 0)
            songNumber = 0
        }
    }
    @IBAction func rewind (_ sender: UIButton) {
        if songNumber > 0 {
            scrollView_img.setContentOffset(CGPoint(x:self.scrollView_img.frame.size.width * CGFloat(songNumber - 1), y:0), animated: true)
            updateLabel(index: songNumber - 1)
            playSong(index: songNumber - 1)
            songNumber -= 1
        } else if songNumber == 0 {
            scrollView_img.setContentOffset(CGPoint(x:self.scrollView_img.frame.size.width * CGFloat(songList.count - 1), y:0), animated: true)
            updateLabel(index: songList.count - 1)
            playSong(index: songList.count - 1)
            songNumber = songList.count - 1
        }
    }
    
    @IBAction func repeatSong (_ sender: UIButton) {
        if isRepeat == false {
            btn_repeat.setImage(UIImage(named:"ic_loop_white_2x"), for: .normal)
            player.numberOfLoops = -1
            isRepeat = true
        } else {
            btn_repeat.setImage(UIImage(named:"ic_loop_2x"), for: .normal)
            player.numberOfLoops = 0
            isRepeat = false
        }
    }
    
    @IBAction func shuffleSong(_ sender: UIButton) {
        if isShuffle == false {
            btn_shuffle.setImage(UIImage(named: "ic_shuffle_white_x2"), for: .normal)
            isShuffle = true
        } else {
            btn_shuffle.setImage(UIImage(named: "ic_shuffle_x2"), for: .normal)
            isShuffle = false
        }
    }
}

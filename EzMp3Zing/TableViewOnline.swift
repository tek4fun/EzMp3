//
//  TableViewOnline.swift
//  EzMp3Zing
//
//  Created by iOS Student on 2/13/17.
//  Copyright © 2017 tek4fun. All rights reserved.
//

import UIKit
let kDOCUMENT_DIRECTORY_PATH = NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true).first
class TableViewOnline: UIViewController, UITableViewDelegate,UITableViewDataSource {
    var listSongs = [Song]()
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var btn_PreWeek: UIButton!
    @IBOutlet weak var btn_NextWeek: UIButton!

    var currentWeek:Int = 0
    var currentYear:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.delegate = self
        myTableView.dataSource = self
        getCurrentWeek()
        getCurrentYear()
        getData()

    }

    @IBAction func actionPreWeek(_ sender: UIButton) {
        if currentWeek > 0 {
            currentWeek -= 1
        } else {
            currentWeek = 52
            currentYear -= 1
        }
        print("http://mp3.zing.vn/bang-xep-hang/bai-hat-Viet-Nam/IWZ9Z08I.html?w=\(currentWeek)&y=\(currentYear)")
        listSongs.removeAll()
        getData()
        DispatchQueue.main.async {
            self.myTableView.reloadData()
        }
    }
    @IBAction func actionNextWeek(_ sender: UIButton) {
        if currentWeek < 52 {
            currentWeek += 1
        } else {
            currentWeek = 1
            currentYear += 1
        }
        print("http://mp3.zing.vn/bang-xep-hang/bai-hat-Viet-Nam/IWZ9Z08I.html?w=\(currentWeek)&y=\(currentYear)")
        listSongs.removeAll()
        getData()
        DispatchQueue.main.async {
            self.myTableView.reloadData()
        }
    }


    func getData()
    {

        let data = NSData(contentsOf: URL(string: "http://mp3.zing.vn/bang-xep-hang/bai-hat-Viet-Nam/IWZ9Z08I.html?w=\(currentWeek)&y=\(currentYear)")!)

        let doc = TFHpple(htmlData: data as Data!)
        if let elements = doc?.search(withXPathQuery: "//h3[@class='title-item']/a") as? [TFHppleElement]
        {

//            for element in elements
//            {
                DispatchQueue.global(qos: .default).async(execute: {
                    let id = "ZWZ97W7I" //self.getID(path: element.object(forKey: "href") as NSString)
                    let url = NSURL(string: "http://api.mp3.zing.vn/api/mobile/song/getsonginfo?keycode=fafd463e2131914934b73310aa34a23f&requestdata={\"id\":\"\(id)\"}".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)

                    let lyric = NSURL(string: "http://api.mp3.zing.vn/api/mobile/song/getlyrics?keycode=fafd463e2131914934b73310aa34a23f&requestdata={\"id\":\"\(id)\"}".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)



                    var stringData = ""
                    var lyricData = ""
                    do {
                        stringData = try String(contentsOf: url! as URL)
                        lyricData = try String(contentsOf: lyric! as URL)
                    }
                    catch let error as NSError
                    {
                        print(error)
                    }
                    let json = self.convertStringToDictionary(text: stringData)
                    let lyricJson = self.convertStringToDictionary(text: lyricData)
                    print(lyricJson)
                    if (json != nil)
                    {
                        self.addSongToList(json!, lyricJson!)
                    }
                })
            //}
        }
    }


    func getCurrentYear() {
        let date = Date()
        let calendar = Calendar.current
        currentYear = Int(calendar.component(.year, from: date))
    }
    func getCurrentWeek() {
        // get week
        let data = NSData(contentsOf: URL(string: "http://mp3.zing.vn/bang-xep-hang/bai-hat-Viet-Nam/IWZ9Z08I.html")!)
        let doc = TFHpple(htmlData: data as Data!)

        //split week number from String
        let element = String(describing: doc?.search(withXPathQuery: "//p[@class='pull-left']/strong"))
        let stringArray = element.components(separatedBy: CharacterSet.decimalDigits.inverted)
        let newString = NSArray(array: stringArray).componentsJoined(by: "")
        let strIndex = newString.index(newString.startIndex, offsetBy: 2)
        let week = String(newString[strIndex])

        //convert Week to Int
        currentWeek = Int(week)!
    }
    func getID(path: NSString) -> NSString {
        let id = (path.lastPathComponent as NSString).deletingPathExtension
        return id as NSString
    }

    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
                return json
            } catch {
                print("Sumtingwong!")
            }
        }
        return nil
    }

    func addSongToList(_ json: [String: AnyObject],_ lyricJson: [String: AnyObject])
    {
        let title = json["title"] as! String
        let artistName = json["artist"] as! String
        let thumbnail = json["thumbnail"] as! String
        let source = json["source"]!["128"] as! String
        let lyric = lyricJson["content"] as! String
        let currentSong = Song(title: title, artistName: artistName, thumbnail: thumbnail, source: source, lyric: lyric)
        listSongs.append(currentSong)
        DispatchQueue.main.async {
            self.myTableView.reloadData()
        }
    }
    func downloadSong(index: Int) {
        let dataSong = try? Data(contentsOf: URL(string:listSongs[index].sourceOnline)!)
        if let dir = kDOCUMENT_DIRECTORY_PATH {
            let pathToWriteSong = "\(dir)/\(listSongs[index].title)"
            //writing
            do
            {
                try FileManager.default.createDirectory(atPath: pathToWriteSong, withIntermediateDirectories: false, attributes: nil)
            } catch let error as NSError
            {
                print(error.localizedDescription)
            }

            //ghi bai hat
            writeDataToPath(dataSong! as NSObject, path: "\(pathToWriteSong)/\(listSongs[index].title).mp3")
            writeInfoSong(listSongs[index], path: pathToWriteSong)
        }
    }

    func writeInfoSong(_ song: Song, path: String)
    {
        let dictData = NSMutableDictionary()
        dictData.setValue(song.title, forKey: "title")
        dictData.setValue(song.artistName, forKey: "artistName")
        dictData.setValue("/\(song.title)/thumbnail.png", forKey: "localThumbnail")
        dictData.setValue(song.sourceOnline, forKey: "sourceOnline")
        dictData.setValue(song.lyric, forKey: "lyric")
        //writing info
        writeDataToPath(dictData, path: "\(path)/info.plist")

        //writing thumbnail
        let dataThumbnail = NSData(data: UIImagePNGRepresentation(song.thumbnail)!) as Data
        writeDataToPath(dataThumbnail as NSObject, path: "\(path)/thumbnail.png")
    }
    func writeDataToPath(_ data: NSObject, path: String)
    {
        if let dataToWrite = data as? Data
        {
            try? dataToWrite.write(to: URL(fileURLWithPath: path), options: [.atomic])
        }
        else if let dataInfo = data as? NSDictionary
        {
            dataInfo.write(toFile: path, atomically: true)
        }
    }



    //UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listSongs.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.imageView?.image = listSongs[indexPath.row].thumbnail
        cell.textLabel?.text = listSongs[indexPath.row].title
        cell.textLabel?.textColor = UIColor.white
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let audioPlay = AudioPlayer.sharedInstance
        audioPlay.pathString = listSongs[indexPath.row].sourceOnline
        audioPlay.titleSong = listSongs[indexPath.row].title + "(\(listSongs[indexPath.row].artistName))"
        audioPlay.lyric = listSongs[indexPath.row].lyric
        audioPlay.setupAudio()
        NotificationCenter.default.post(name: Notification.Name(rawValue: "setupObserverAudio"), object: nil)
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let edit = UITableViewRowAction(style: .normal, title: "Download") { action, index in
            DispatchQueue.global(qos: .default).async(
                execute: {
                    self.downloadSong(index: indexPath.row)
            })
            self.myTableView.reloadData()
        }
        edit.backgroundColor = UIColor(red: 248/255, green: 55/255, blue: 186/255, alpha: 1.0)
        return [edit]
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
}



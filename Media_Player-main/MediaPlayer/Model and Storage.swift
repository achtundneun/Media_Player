//
//  Model and Storage.swift
//  MediaPlayer
//
//  Created by Егор Никитин on 24.02.2021.
//

import UIKit

struct Track {
    let band: String
    let name: String
    let image: UIImage
    let fileName: String
    var url: URL? {
        if let filePath = Bundle.main.path(forResource: fileName, ofType: "mp3") {
            return URL.init(fileURLWithPath: filePath)
        }
        return nil
    }
}

struct Video {
    let name: String
    let previewImage: UIImage
    let youTubeString: String
}

final class Storage {
    
    static let shared = Storage()
    
    let tracks: [Track] = [
        Track(band: "Nirvana", name: "Sappy", image: #imageLiteral(resourceName: "nirvana"), fileName: "Nirvana-Sappy"),
        Track(band: "The Offspring", name: "Days Go By", image: #imageLiteral(resourceName: "offspring"), fileName: "TheOffspring-DaysGoBy"),
        Track(band: "Imagine Dragons", name: "Monster", image: #imageLiteral(resourceName: "ImagineDragons"), fileName: "ImagineDragons-monster"),
        Track(band: "Creedence Clearwater Revival", name: "Fortunate Son", image: #imageLiteral(resourceName: "Creedence"), fileName: "Creedence-FortunateSon"),
        Track(band: "Pink Floyd", name: "Wish You Were Here", image: #imageLiteral(resourceName: "pink floyd"), fileName: "PinkFloyd-WishYouWereHere")
    ]
    
    let videos: [Video] = [
        Video(name: "Месяц жизни с MacBook Air M1", previewImage: #imageLiteral(resourceName: "MacBook"), youTubeString: "https://www.youtube.com/watch?v=h8YOaGjLJQQ"),
        Video(name: "Реплика Apple 1", previewImage: #imageLiteral(resourceName: "Apple 1"), youTubeString: "https://www.youtube.com/watch?v=pwPpISl5tGc"),
        Video(name: "Что такое Clubhouse?", previewImage: #imageLiteral(resourceName: "ClubHouse"), youTubeString: "https://www.youtube.com/watch?v=Q14HM2FZfYA"),
        Video(name: "MVC+Coordinator - авторизация.", previewImage: #imageLiteral(resourceName: "MVC"), youTubeString: "https://www.youtube.com/watch?v=iWYpFWQpvkA&t=197s"),
        Video(name: "The Legend of Kage (NES)", previewImage: #imageLiteral(resourceName: "Nes"), youTubeString: "https://www.youtube.com/watch?v=2zYLntVHGRw")
    ]
    
    var recordedAudio: Data?
    
    private init() {
        
    }
    
    
}

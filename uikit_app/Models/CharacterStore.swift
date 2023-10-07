//
//  CharacterStore.swift
//  uikit_app
//
//  Created by Mercedes Franchesca Gonzalez Cejas on 22/8/23.
//

import UIKit
import Combine
import Foundation

//pull to refresh o si eso el boton para refresh

class CharacterStore {
    let url = URL(string: "https://api.jikan.moe/v4/manga/13/characters")!

    var info: [Character] = []
    
//
//    init() {
//        loadJikanAPI()
//    }

    func loadJikanAPI(completion: @escaping () -> Void){
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                let charactersData = json["data"] as! [[String: Any]]
                self.info = charactersData.compactMap { character in
                    let characterData = character["character"] as! [String: Any]
                    let characterRole = character["role"]!
                    let characterImage = characterData["images"] as! [String: Any]
                    let characterImageURL = characterImage["jpg"] as! [String: Any]
                    
                    guard let id = characterData["mal_id"] as? Int64,
                          let name = characterData["name"] as? String,
                          let role = characterRole as? String,
                          let image_url = characterImageURL["image_url"] as? String
                    else {
                        return nil
                    }
                    
                    // Download the image data and save it to the Character object
                                    var imageData: Data?
                                    if let imageURL = URL(string: image_url) {
                                        imageData = try? Data(contentsOf: imageURL)
                                    }
                    
                    return Character(id: id, name: name, role: role, image_url: image_url, imageData: imageData)
                }
                
                print("-------------------- Data From API: --------------------")
                print(self.toString())
                
                completion()
                
            } catch {
                print("Error al obtener los datos de la API")
            }
        }
        task.resume()
        
        
    }
    
    func loadCharacterData(character: Character, completion: @escaping () -> Void){
        let url = URL(string: "https://api.jikan.moe/v4/characters/\(character.id)")!
        var about: String = ""
        var nicknames: [String] = []

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                let characterData = json["data"] as! [String: Any]
                
                // Access the character data
                about = (characterData["about"] as? String) ?? "None"
                nicknames = (characterData["nicknames"] as? [String]) ?? ["None"]
                
                // ...
                character.about = about
                character.nicknames = nicknames
                
                print(about)
                print(nicknames)
                
                completion()
                
            } catch {
                print("Error al obtener los datos de la API")
            }
        }
        task.resume()
        
        

    }
    
    func toString() -> String {
        var string: String = ""
        info.forEach { info in
            string += "Character[\(info.toString())]"
        }
        
        return string
    }
    
}

extension FileManager {
    static var documentDirectoryURL: URL {
        return `default`.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}

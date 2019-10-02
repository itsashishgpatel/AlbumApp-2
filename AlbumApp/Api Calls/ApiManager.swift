//
//  ApiManager.swift
//  AlbumApp
//
//  Created by Ashish Patel on 27/09/19.
//  Copyright © 2019 Ashish Patel. All rights reserved.
//

import Foundation

class ApiManager {
    
    public typealias completionHandler = (_ success: Bool, _ response: [Album]?, _ error: Error?) -> ()
    
    func getAlbums(completion: @escaping completionHandler)
    {
        guard let url = URL(string: "https://rss.itunes.apple.com/api/v1/us/apple-music/top-albums/all/100/explicit.json") else {return}
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do{
                
                if let httpResponse = response as? HTTPURLResponse
                {
                    print(httpResponse.statusCode)
                    if httpResponse.statusCode == 200
                    {
                        let response = try JSONSerialization.jsonObject(with: dataResponse, options: .allowFragments)
                        
                        print(response)
                        
                        if let responseDict = response as? NSDictionary, let feed = responseDict.value(forKey: "feed") as? NSDictionary, let results = feed.value(forKey: "results") as? NSArray {
                            
                            var albumList = [Album]()
                            for result in results {
                                let albumData = try JSONSerialization.data(withJSONObject: result, options: .prettyPrinted)
                
                                let album = try JSONDecoder().decode(Album.self, from: albumData)
                                albumList.append(album)
                            }
                            completion(true, albumList, nil)
                        }
                    }
                }
                else
                {
                    completion(false, nil, nil)
                }
            } catch
            {
                print("Parsing Error \(error.localizedDescription)")
            }
        }
        task.resume()
    }
}

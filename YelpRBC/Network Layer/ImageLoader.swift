//
//  ImageLoader.swift
//  YelpRBC
//
//  Created by Chandra Sekhar Ravi on 13/02/21.
//

import UIKit

class ImageLoader{
    private var images = [URL: UIImage]()
    private var currentRequests = [UUID: URLSessionDataTask]()
    
    func loadImage(_ url: URL, _ completion: @escaping (Result<UIImage, Error>) -> Void) -> UUID? {

      if let image = images[url] {
        completion(.success(image))
        return nil
      }

      let uuid = UUID()

      let task = URLSession.shared.dataTask(with: url) { data, response, error in
        defer {self.currentRequests.removeValue(forKey: uuid) }

        if let data = data, let image = UIImage(data: data) {
          self.images[url] = image
          completion(.success(image))
          return
        }

        guard let error = error else {
          return
        }

        guard (error as NSError).code == NSURLErrorCancelled else {
          completion(.failure(error))
          return
        }
      }
      task.resume()
    currentRequests[uuid] = task
      return uuid
    }
    
    func cancelLoad(_ uuid: UUID) {
        currentRequests[uuid]?.cancel()
        currentRequests.removeValue(forKey: uuid)
    }

}

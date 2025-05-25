//  AstraTech-SwiftUi
//
//  Created by Ahmed Adel on 23/05/2025.
import SwiftUI

class APIService {
    static let shared = APIService()
    private init() {}
    
    func fetchData<T: Decodable>(from url: String, completion: @escaping (Result<T, Error>) -> Void) {
        guard let requestUrl = URL(string: url) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        URLSession.shared.dataTask(with: requestUrl) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func postData<T: Decodable>(to urlString: String,
                                body: Any?,
                                image: UIImage? = nil,
                                method: String = "POST",
                                completion: @escaping (Result<T, Error>) -> Void) {
                
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        if let image = image {
            let targetSize = CGSize(width: 1024, height: 1024)
            let resizedImage = resizeImage(image, targetSize: targetSize) ?? image
            guard let imageData = resizedImage.jpegData(compressionQuality: 0.5) else {
                completion(.failure(NSError(domain: "Image Compression Error", code: 400, userInfo: nil)))
                return
            }
            
            let maxSizeBytes = 2 * 1024 * 1024
            if imageData.count > maxSizeBytes {
                completion(.failure(NSError(domain: "Image Too Large", code: 400, userInfo: [
                    NSLocalizedDescriptionKey: "Selected image is too large. Please choose a smaller image."
                ])))
                return
            }
            
            let boundary = "Boundary-\(UUID().uuidString)"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            var bodyData = Data()
            
            if let bodyDict = body as? [String: Any] {
                for (key, value) in bodyDict {
                    bodyData.append("--\(boundary)\r\n".data(using: .utf8)!)
                    bodyData.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
                    bodyData.append("\(value)\r\n".data(using: .utf8)!)
                }
            }
            
            bodyData.append("--\(boundary)\r\n".data(using: .utf8)!)
            bodyData.append("Content-Disposition: form-data; name=\"photo\"; filename=\"post_image.jpg\"\r\n".data(using: .utf8)!)
            bodyData.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            bodyData.append(imageData)
            bodyData.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
            
            request.httpBody = bodyData
            request.setValue("\(bodyData.count)", forHTTPHeaderField: "Content-Length")
            } else {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            if let bodyDict = body as? [String: Any] {
                do {
                    request.httpBody = try JSONSerialization.data(withJSONObject: bodyDict)
                } catch {
                    completion(.failure(error))
                    return
                }
            } else if let encodableBody = body as? Encodable {
                do {
                    request.httpBody = try JSONEncoder().encode(encodableBody)
                } catch {
                    completion(.failure(error))
                    return
                }
            }
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No Data", code: 404, userInfo: nil)))
                return
            }
            
            if let responseString = String(data: data, encoding: .utf8), responseString.contains("<!DOCTYPE html>") {
                completion(.failure(NSError(domain: "Invalid Response", code: 500, userInfo: [
                    NSLocalizedDescriptionKey: "Server returned HTML instead of JSON."
                ])))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 422 {
                    do {
                        let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                        let errorMessage = errorResponse.errors.flatMap { $0.value }.joined(separator: "; ")
                        completion(.failure(NSError(domain: "Validation Error", code: 422, userInfo: [
                            NSLocalizedDescriptionKey: errorMessage
                        ])))
                    } catch {
                        completion(.failure(error))
                    }
                } else {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    private func resizeImage(_ image: UIImage, targetSize: CGSize) -> UIImage? {
        let size = image.size
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        let scaleFactor = min(widthRatio, heightRatio)
        
        let newSize = CGSize(width: size.width * scaleFactor, height: size.height * scaleFactor)
        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}

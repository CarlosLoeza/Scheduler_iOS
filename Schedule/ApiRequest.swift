//
//  ApiRequest.swift
//  Schedule
//
//  Created by Carlos Loeza on 6/24/21.
//

import Foundation

struct ApiRequest{
    
    func uploadImage(data: Data, completionHandler: @escaping(_ result: ImageResponse)-> Void){
        let httpUtility = HttpUtility()
        
        let request = ImageRequest(attachment: data.base64EncodedString(), fileName: "Syllabus_Image")
        
        do{
            let postBody = try JSONEncoder().encode(request)
            httpUtility.postApiData(requestUrl: URL(string: "http://167.172.157.65:5000/api/send_syllabus")!, requestBody: postBody, resultType: ImageResponse.self){
                (response) in _ = completionHandler(response)
            }
        } catch let error {
            debugPrint(error)
        }
    }
    
}










//import Foundation
//
//// API errors we may encounter during our POST request
//enum ApiError:Error{
//    case responseProblem
//    case decodingProblem
//    case encodingProblem
//}
//
//
//struct ApiRequest{
//
//    let resourceURL: URL
//
//    init(resourceURL: URL){
//        self.resourceURL = resourceURL
//    }
//
//    // save our message, later on change message to image
//    func save(_ messageToSave: ImagePOST, completion: @escaping(Result<ImagePOST, ApiError>) -> Void){
//        do{
//            var urlRequest = URLRequest(url: resourceURL)
//            urlRequest.httpMethod = "POST"
//            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
//            urlRequest.httpBody = try JSONEncoder().encode(messageToSave)
//
//            let dataTask = URLSession.shared.dataTask(with: urlRequest) {data, response, _ in
//                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
//                    let jsonData = data else {
//                    completion(.failure(.responseProblem))
//                    return
//                }
//
//                do {
//                    let messageData = try JSONDecoder().decode(ImagePOST.self, from: jsonData)
//                    completion(.success(messageData))
//                } catch {
//                    completion(.failure(.decodingProblem))
//                }
//
//            }
//            dataTask.resume()
//        } catch{
//            completion(.failure(.encodingProblem))
//        }
//
//    }
//
//}

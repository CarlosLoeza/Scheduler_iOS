import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate  {
    @IBOutlet var imageView: UIImageView!
    var imagePicker = UIImagePickerController()

    
    // Allow user to select image from camera roll
    @IBAction func btnClicked() {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = .photoLibrary
        image.allowsEditing = false
        self.present(image, animated: true){
        }
    }

    // Work in progress: create a POST request
    @IBAction func send_image(_ sender: UIButton) {
        //call postRequest with username and password parameters
        postRequest(username: "username", password: "password") { (result, error) in
            if let result = result {
                print("success: \(result)")
            } else if let error = error {
                print("error: \(error.localizedDescription)")
            }
        }
    }
    
    
    func postRequest(username: String, password: String, completion: @escaping ([String: Any]?, Error?) -> Void) {

        //declare parameter as a dictionary which contains string as key and value combination.
        let parameters = ["name": username, "password": password]

        //create the url with NSURL
        let url = URL(string: "http://167.172.157.65:5000")!

        //create the session object
        let session = URLSession.shared

        //now create the Request object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to data object and set it as request body
        } catch let error {
            print(error.localizedDescription)
            completion(nil, error)
        }

        //HTTP Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request, completionHandler: { data, response, error in

            guard error == nil else {
                completion(nil, error)
                return
            }

            guard let data = data else {
                completion(nil, NSError(domain: "dataNilError", code: -100001, userInfo: nil))
                return
            }

            do {
                //create json object from data
                guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {
                    completion(nil, NSError(domain: "invalidJSONTypeError", code: -100009, userInfo: nil))
                    return
                }
                print(json)
                completion(json, nil)
            } catch let error {
                print(error.localizedDescription)
                completion(nil, error)
            }
        })
        task.resume()
    }
    
   
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
        } else {
            print("ERROR")
        }

        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
            // Do any additional setup after loading the view.
        imagePicker.delegate = self
    }
}

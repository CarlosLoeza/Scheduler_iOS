import UIKit



class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate  {
    @IBOutlet var imageView: UIImageView! // Display's image selected by user's camera roll
    @IBOutlet weak var server_string: UILabel! // Display's string received from server. (ex: course schedule list)
    var imagePicker = UIImagePickerController()
    private var manager: ApiRequest?
    
    
    
    // Allow user to select image from camera roll
    @IBAction func btnClicked() {
        print("library")
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = .photoLibrary
        image.allowsEditing = false
        self.present(image, animated: true){
        }
    }
    


    // create a POST request
    @IBAction func send_image(_ sender: UIButton) {
        print("hello")
        
        uploadImageOne()
//        manager?.uploadImage(data: (self.imageView.image?.pngData())!, completionHandler: {
//            (response) in
//
//
//            if (response.path.isEmpty == false){
//                let alert = UIAlertController(title: "Image", message: "Image uploaded", preferredStyle: .alert)
//                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
//                alert.addAction(okAction)
//                self.present(alert, animated: true)
//            }
//        })
        
    }
    
    
    // Your method to upload image with parameters to server.

    func uploadImageOne(){
        
        let url = URL(string: "http://167.172.157.65:5000/api/send_syllabus")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("image/jpeg", forHTTPHeaderField: "Content-Type")
        var d = imageView.image!.pngData()! as Data
        
        let task = URLSession.shared.uploadTask(with: request, from: d) { data, response, error in
            if let error = error {
                print ("error: \(error)")
                return
            }
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else {
                print ("server error")
                return
            }
            if let mimeType = response.mimeType,
                mimeType == "application/json",
                let data = data,
                let dataString = String(data: data, encoding: .utf8) {
                print ("got data: \(dataString)")
            }
        }
        task.resume()
    }
    
    @IBAction func selectImage(_ sender: Any) {
        print("select")
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = .camera
        image.allowsEditing = false
        self.present(image, animated: true){
        }
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
        manager = ApiRequest()
    }
}

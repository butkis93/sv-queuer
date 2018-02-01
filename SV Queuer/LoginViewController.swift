import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func loginPressed(_ sender: Any) {
        guard let username = usernameField.text, !username.isEmpty else {
            //Display alert for valid username
            return
        }
        
        guard let password = passwordField.text, !password.isEmpty else {
            //Display alert for valid password
            return
        }
        
        let requestBody = LoginRequest(username: username, password: password)
        let request = HerokuRequest(path: "session", httpBody: requestBody, httpMethod: .post)
        
        HerokuService.send(with: request, responseType: LoginResponse.self, onSuccess: { [weak self] response, urlResponse in
            guard let code = urlResponse as? HTTPURLResponse, code.statusCode == NumberConstants.successCode else {
                // Will be assuming status code 200 is success here
                // may need to handle any other codes in different ways
                return
            }
            
            if let loginResponse = response as? LoginResponse {
                UserDefaults.standard.set(loginResponse.apiKey, forKey: StringConstants.apiKey)
                DispatchQueue.main.async {
                    self?.performSegue(withIdentifier: "projects", sender: self)
                }
            } else {
                // Log error
            }
        }) { [weak self] requestError in
            DispatchQueue.main.async {
                let errorAlert = UIAlertController.errorAlert(with: requestError, completion: nil)
                self?.present(errorAlert, animated: true, completion: nil)
            }
        }
    }
}

import UIKit

extension UIImageView {
    func setImage(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else {
                return
            }
            
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    
    func setImage(urlString: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: urlString) else {
            return
        }
        
        setImage(url: url, contentMode: mode)
    }
}

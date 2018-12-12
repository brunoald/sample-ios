import UIKit
import Alamofire

protocol CityViewDelegate {
    func onTemperatureFound()
}

class CityViewController: ViewController {
    var cityName: String!
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var temperature: UILabel!
    
    var delegate: CityViewDelegate!
    
    override func viewDidLoad() {
        label.text = cityName
        requestTemperature()
    }
    
    func requestTemperature() {
        let endpoint = "https://api.openweathermap.org/data/2.5/weather?q=\(cityName.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!)&units=metric&appid=21935d3a6682a59b28ccbdb398591285"
        
        Alamofire.request(endpoint).responseJSON { response in
            if let result = response.result.value as? [String: Any] {
                let main = result["main"] as! [String : Any]
                let temperature = main["temp"] as! Double
                print(temperature)
                self.temperature.text = String(temperature)
                self.delegate.onTemperatureFound()
                
            }
        }
        
        print(endpoint)
    }
}

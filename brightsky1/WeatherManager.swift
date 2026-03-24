import Foundation

struct WeatherManager{
    
    let apiKey = "1545d199f9755e18fd5b5cc2b0791d29"
    
    var onWeatherUpdated: ((WeatherData) -> Void)?
    var onForecastUpdated: (([ForecastItem]) -> Void)?
    
    // İnternetten veriyi çeken ana fonksiyon
    func fetchWeather(cityName: String){
        
        let safeCityName = cityName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? cityName
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(safeCityName)&appid=\(apiKey)&units=metric"
        
        //String olan adresi, İOS'un anlayacağı bir URL nesnesine çeviriyoruz
        guard let url = URL(string: urlString) else { return }
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                print("İnternet bağlantı hatası: \(error)")
                return
            }
            if let safeData = data {
                parseJSON(weatherData: safeData)
            }
        }
        task.resume()
    }
    
    // Belirtilen şehrin 5 günlük ve saatlik hava tahminlerini API'den çekme
    func fetchForecast(cityName: String) {
        // Şehir adını düzenleyerek API'nin anlayacağı hale getiriyor
        let safeCityName = cityName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? cityName
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?q=\(safeCityName)&appid=\(apiKey)&units=metric"

        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error{
                print("Tahmin verisi çekilemedi: \(error)")
                return
            }
            if let safeData = data{
                parseForecastJSON(forecastData: safeData)
            }
        }
        task.resume()
    }
    
    // Gelen JSON metnini, WeatherData kalıbına döken fonksiyon
    func parseJSON(weatherData: Data){
        let decoder = JSONDecoder()
        
        do{
            // İnternetten gelen veriyi (weatherData) al, yazdığım 'WeatherData' modeline göre çiz (decode)
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            self.onWeatherUpdated?(decodedData)
            
        } catch {
            print("Veri çeviri hatası: \(error)")
        }
    }
    
    private func parseForecastJSON(forecastData: Data){
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(ForecastData.self, from: forecastData)
            self.onForecastUpdated?(decodedData.list)
        } catch {
            print("Tahmin verisi çeviri hatası: \(error)")
        }
    }
}

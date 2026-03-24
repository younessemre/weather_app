import Foundation
//WeatherData
struct WeatherData: Codable{
    let name: String
    let main: MainWeather
    let wind: WindInfo
    let weather: [Weather]
    
    var conditionName: String{
        guard let conditionId = weather.first?.id else { return "cloud.fill" }
        
        switch conditionId{
        case 200...232:
            return "cloud.bolt.rain.fill"
        case 300...321:
            return "cloud.drizzle.fill"
        case 500...531:
            return "cloud.rain.fill"
        case 600...622:
            return "cloud.snow.fill"
        case 701...781:
            return "cloud.fog.fill"
        case 800:
            return "sun.max.fill"
        case 801...804:
            return "cloud.fill"
        default:
            return "cloud.sun.fill"
        }
    }
}

struct ForecastData: Codable {
    let list: [ForecastItem]
}

struct ForecastItem: Codable {
    let dt: TimeInterval
    let main: MainWeather
    let weather: [Weather]
    
    var conditionName: String{
        guard let conditionId = weather.first?.id else { return "cloud.fill" }
        
        switch conditionId{
        case 200...232: return "cloud.bolt.rain.fill"
        case 300...321: return "cloud.drizzle.fill"
        case 500...531: return "cloud.rain.fill"
        case 600...622: return "cloud.snow.fill"
        case 701...781: return "cloud.fog.fill"
        case 800: return "sun.max.fill"
        case 801...804: return "cloud.fill"
        default: return "cloud.sun.fill"
        }
    }
}

struct MainWeather: Codable{
    let temp: Double
    let humidity: Int
}

struct WindInfo: Codable{
    let speed: Double
}

struct Weather: Codable{
    let id: Int
    let description: String
}







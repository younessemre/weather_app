import UIKit

class ViewController: UIViewController {
    
    let scrollView = UIScrollView()
    let contentView = UIView()

    let searchBar = ModernSearchBar()
    
    let weatherImageView = UIImageView()
    let cityLabel = UILabel()
    let temperatureLabel = UILabel()
    let detailsStackView = UIStackView()
    
    let windCard = WeatherDetailCardView(title: "Rüzgar")
    let humidityCard = WeatherDetailCardView(title: "Nem")
    
    var forecastCollectionView: UICollectionView!
    var dailyTableView: UITableView!
    var tableViewHeightConstraint: NSLayoutConstraint!
    
    var weatherManager = WeatherManager()
    var forecastList : [ForecastItem] = []
    var dailyList: [ForecastItem] = []

    // PR için eklendi
    override func viewDidLoad() {
        super.viewDidLoad()
        print("👉 ViewController çalıştı!")
        
        setupBackgroundColor()
        setupWeatherIcon()
        setupCityLabel()
        setupScrollView()
        
        searchBar.searchTextField.delegate = self
        searchBar.searchButton.addTarget(self, action: #selector(searchPressed), for: .touchUpInside)
        contentView.addSubview(searchBar)
        
        setupTemperatureLabel()
        setupDetailsStackView()
        
        setupCollectionView()
        setupTableView()
        setupConstraints()

        // Sıcaklık, nem, rüzgar gibi değerleri güncelleme
        weatherManager.onWeatherUpdated = { data in
            DispatchQueue.main.async {
                
                let tempString = String(Int(round(data.main.temp)))
                self.temperatureLabel.text = "\(tempString)°C"
                
                let windString = String(Int(round(data.wind.speed)))
                self.windCard.updateValue("\(windString) km/s")
                self.humidityCard.updateValue("%\(data.main.humidity)")
                
                self.cityLabel.text = data.name
                self.weatherImageView.image = UIImage(systemName: data.conditionName)
            }
        }
        // API'den gelen veriyi yatay ve dikey listelerin içeriğini düzenler
        weatherManager.onForecastUpdated = { list in
            DispatchQueue.main.async{
                self.forecastList = list.filter { item in
                    let itemDate = Date(timeIntervalSince1970: item.dt)
                    return Calendar.current.isDateInToday(itemDate)
                }
                self.forecastCollectionView.reloadData()
                
                var utcCalendar = Calendar.current
                utcCalendar.timeZone = TimeZone(abbreviation: "UTC")!
                
                self.dailyList = list.filter{ item in
                    let itemDate = Date(timeIntervalSince1970: item.dt)
                    let hour = utcCalendar.component(.hour, from: itemDate)
                    return hour == 12
                }
                self.dailyTableView.reloadData()
                self.tableViewHeightConstraint.constant = CGFloat(self.dailyList.count * 70)
            }
        }
        weatherManager.fetchWeather(cityName: "Istanbul")
        weatherManager.fetchForecast(cityName: "Istanbul")
    }
    
    // Arkaplan rengini belirleyen fonksiyon
    private func setupBackgroundColor() {
        view.backgroundColor = .systemCyan
    }
    
    // Butona basıldığında klavyeyi gizleyerek arama işlemini tetiklemesi sağlanıyor.
    @objc func searchPressed() {
            // Klavyeyi aşağı indirir ve aramayı başlatır
            searchBar.searchTextField.endEditing(true)
        }
    
    // ScrollView özelliğinin eklenmesi
    private func setupScrollView(){
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
    }


    // Ekrandaki hava durumu ikonu düzenlemeleri ve ekrana ekleme
    private func setupWeatherIcon() {
        weatherImageView.image = UIImage(systemName: "cloud.sun.fill")
        weatherImageView.tintColor = .white
        weatherImageView.contentMode = .scaleAspectFit
        weatherImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(weatherImageView)
    }
    
    // Ekrandaki şehir yazısı düzenlemeleri ve ekrana ekleme
    private func setupCityLabel() {
        cityLabel.text = "Yükleniyor..."
        cityLabel.font = .systemFont(ofSize: 34, weight: .bold)
        cityLabel.textColor = .white
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cityLabel)
    }
    
    // Derece metni (BÜYÜK)
    private func setupTemperatureLabel(){
        temperatureLabel.text = "--°C"
        temperatureLabel.font = .systemFont(ofSize: 80, weight: .black)
        temperatureLabel.textColor = .white
        
        // Eski sistemi sustur
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(temperatureLabel)
    }
    
    // Rüzgar ve Nem kartının eklenmesi
    private func setupDetailsStackView(){
        detailsStackView.addArrangedSubview(windCard)
        detailsStackView.addArrangedSubview(humidityCard)
        
        detailsStackView.axis = .horizontal
        detailsStackView.distribution = .fillEqually
        detailsStackView.spacing = 20
        detailsStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(detailsStackView)
    }
     
    // Saatlik hava durumunun yan yana dizilmesi
    private func setupCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 90, height: 110)
        layout.minimumLineSpacing = 15
        
        forecastCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        forecastCollectionView.backgroundColor = .clear
        forecastCollectionView.showsHorizontalScrollIndicator = false
        
        forecastCollectionView.register(HourlyForecastCell.self, forCellWithReuseIdentifier: "HourlyCell")
        
        forecastCollectionView.dataSource = self
        
        forecastCollectionView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(forecastCollectionView)
    }
    
    // Haftalık hava durumunun alt alta dizilmesi
    private func setupTableView(){
        dailyTableView = UITableView()
        dailyTableView.backgroundColor = .clear
        dailyTableView.separatorStyle = .none
        dailyTableView.showsVerticalScrollIndicator = false
        dailyTableView.isScrollEnabled = false
        
        dailyTableView.register(DailyForecastCell.self, forCellReuseIdentifier: "DailyCell")
        dailyTableView.dataSource = self
        
        dailyTableView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(dailyTableView)
    }
    
    
    // Ekran üzerindeki konumlandırmalar
    private func setupConstraints() {
        
        let safeArea = view.safeAreaLayoutGuide
        
        tableViewHeightConstraint = dailyTableView.heightAnchor.constraint(equalToConstant: 0)
        tableViewHeightConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            
            scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            
            searchBar.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 30),
            searchBar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            searchBar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            searchBar.heightAnchor.constraint(equalToConstant: 40),
            
            weatherImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            weatherImageView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20),
            weatherImageView.widthAnchor.constraint(equalToConstant: 120),
            weatherImageView.heightAnchor.constraint(equalToConstant: 120),
            
            cityLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            cityLabel.topAnchor.constraint(equalTo: weatherImageView.bottomAnchor, constant: 10),
            
            temperatureLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            temperatureLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 5),
            
            forecastCollectionView.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 40),
            forecastCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            forecastCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            forecastCollectionView.heightAnchor.constraint(equalToConstant: 130),
            
            detailsStackView.topAnchor.constraint(equalTo: forecastCollectionView.bottomAnchor, constant: 30),
            detailsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            detailsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            detailsStackView.heightAnchor.constraint(equalToConstant: 100),
            
            dailyTableView.topAnchor.constraint(equalTo: detailsStackView.bottomAnchor, constant: 30),
            dailyTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            dailyTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            dailyTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
        
        ])
    }
}

// Arama kutusunun klavye ile olan tüm iletişimini yönetir
extension ViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchBar.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" { return true }
        else{
            textField.placeholder = "Lütfen bir şehir yazın!"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchBar.searchTextField.text{
            weatherManager.fetchWeather(cityName: city)
            weatherManager.fetchForecast(cityName: city)
        }
        searchBar.searchTextField.text = ""
    }
}


// Saatlik hava durumunun veri kısmı
extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return forecastList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyCell", for: indexPath) as! HourlyForecastCell
        
        let forecast = forecastList[indexPath.row]
        
        cell.configure(with: forecast)
        
        return cell
    }
    
}

// Haftalık hava durumunun veri kısmı
extension ViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DailyCell", for: indexPath) as! DailyForecastCell
        let dailyData = dailyList[indexPath.row]
        cell.configure(with: dailyData)
        return cell
    }
}

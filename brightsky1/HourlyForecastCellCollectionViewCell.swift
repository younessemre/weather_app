import UIKit
//HourlyForecastCellCollectionViewCell
class HourlyForecastCell: UICollectionViewCell {
    
    // Kartın içindeki nesneler saat, sıcaklık ve ikon
    let timeLabel = UILabel()
    let temperatureLabel = UILabel()
    let iconImageView = UIImageView()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder){
        fatalError("init(coder:) has not been impelemented")
    }
    
    // Saatlik hava tahmini gösteren kartın tasarımı
    private func setupUI(){
        
        contentView.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        contentView.layer.cornerRadius = 15
        
        timeLabel.font = .systemFont(ofSize: 18, weight: .medium)
        timeLabel.textColor = .white
        timeLabel.textAlignment = .center
        
        temperatureLabel.font = .systemFont(ofSize: 20, weight: .bold)
        temperatureLabel.textColor = .white
        
        iconImageView.tintColor = .white
        iconImageView.contentMode = .scaleAspectFit
        
        let stackView = UIStackView(arrangedSubviews: [timeLabel, iconImageView,temperatureLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            
            iconImageView.heightAnchor.constraint(equalToConstant: 30),
            iconImageView.widthAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    // Verileri Doldurma
    func configure(with item: ForecastItem){
        
        // Gelen unix saatini normal saate çevirme
        let date = Date(timeIntervalSince1970: item.dt)
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        timeLabel.text = formatter.string(from: date)
        
        // Dereceyi yuvarlayıp yazdırıyoruz.
        let tempInt = Int(round(item.main.temp))
        temperatureLabel.text = "\(tempInt)°C"
        
        iconImageView.image = UIImage(systemName: item.conditionName)
    }
}

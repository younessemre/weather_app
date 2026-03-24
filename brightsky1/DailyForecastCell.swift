import UIKit

class DailyForecastCell: UITableViewCell {

    // Kartın arka planı, gün yazısı, derece yazısı
    let cardView = UIView()
    let dayLabel = UILabel()
    let iconImageView = UIImageView()
    let temperatureLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }

    // Günlük kart tasarımını oluşturma
    private func setupUI(){
        backgroundColor = .clear
        selectionStyle = .none
        
        cardView.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        cardView.layer.cornerRadius = 15
        cardView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cardView)
        
        dayLabel.font = .systemFont(ofSize: 18, weight: .medium)
        dayLabel.textColor = .white
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        dayLabel.textAlignment = .left
        cardView.addSubview(dayLabel)
        
        iconImageView.tintColor = .white
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(iconImageView)
        
        temperatureLabel.font = .systemFont(ofSize: 22, weight: .bold)
        temperatureLabel.textColor = .white
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.textAlignment = .right
        cardView.addSubview(temperatureLabel)
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            
            cardView.heightAnchor.constraint(equalToConstant: 60),
            
            dayLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            dayLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            dayLabel.trailingAnchor.constraint(lessThanOrEqualTo: temperatureLabel.leadingAnchor, constant: -10),
            
            iconImageView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            iconImageView.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            iconImageView.heightAnchor.constraint(equalToConstant: 30),
            iconImageView.widthAnchor.constraint(equalToConstant: 30),
            
            temperatureLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            temperatureLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),
            
            // Uzun günlerin ikon ile çakışmaması için constant verildi
            dayLabel.trailingAnchor.constraint(lessThanOrEqualTo: iconImageView.leadingAnchor, constant: -10)
        ])
    }
    
    func configure(with item: ForecastItem){
        let date = Date(timeIntervalSince1970: item.dt)
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        formatter.locale = Locale(identifier: "tr_TR")
        
        if Calendar.current.isDateInToday(date){
            dayLabel.text = "Bugün"
        } else {
            dayLabel.text = formatter.string(from: date).capitalized
        }
        
        let tempInt = Int(round(item.main.temp))
        temperatureLabel.text = "\(tempInt)°C"
        
        iconImageView.image = UIImage(systemName: item.conditionName)
    }
    
}

import UIKit
//WeatherDetailCardView
class WeatherDetailCardView: UIView {
    
    let titleLabel = UILabel()
    let valueLabel = UILabel()
    
    // Constructor
    init(title: String) {
        super.init(frame: .zero)
        setupUI(with: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(with title: String) {
        backgroundColor = UIColor.white.withAlphaComponent(0.3)
        layer.cornerRadius = 15
        
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = .white
        
        valueLabel.text = "--"
        valueLabel.font = .systemFont(ofSize: 24, weight: .bold)
        valueLabel.textColor = .white
        
        let innerStack = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
        innerStack.axis = .vertical
        innerStack.alignment = .center
        innerStack.spacing = 5
        innerStack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(innerStack)
        
        NSLayoutConstraint.activate([
            innerStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            innerStack.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func updateValue(_ value: String) {
        valueLabel.text = value
    }
}

import UIKit

class ModernSearchBar: UIStackView {
    
    let searchTextField = UITextField()
    let searchButton = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        searchTextField.placeholder = "Şehir Ara..."
        searchTextField.font = .systemFont(ofSize: 18)
        searchTextField.textColor = .white
        searchTextField.borderStyle = .none
        searchTextField.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        searchTextField.returnKeyType = .search
        searchTextField.layer.cornerRadius = 20
        searchTextField.layer.borderWidth = 1
        searchTextField.layer.borderColor = UIColor.white.withAlphaComponent(0.4).cgColor
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 40))
        searchTextField.leftView = paddingView
        searchTextField.leftViewMode = .always
        
        searchButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        searchButton.tintColor = .white
        searchButton.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        searchButton.layer.cornerRadius = 20
        searchButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        searchButton.layer.borderWidth = 1
        searchButton.layer.borderColor = UIColor.white.withAlphaComponent(0.4).cgColor
        
        self.addArrangedSubview(searchTextField)
        self.addArrangedSubview(searchButton)
        self.axis = .horizontal
        self.spacing = 10
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}

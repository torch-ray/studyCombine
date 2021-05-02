import UIKit

class MyTableViewCell: UITableViewCell {
    
    private lazy var cellLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "MyCell")
        configureMyCell()
        addSubview(cellLabel)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configureMyCell() {
        frame = CGRect(x: 0, y: 0, width: 100, height: 50)
    }
    
    func setupLabel(_ text:String) {
        cellLabel.text = text
        cellLabel.textColor = UIColor.red
    }
}

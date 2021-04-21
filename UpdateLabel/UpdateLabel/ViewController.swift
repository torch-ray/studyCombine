import UIKit
import Combine

class ViewController: UIViewController {

    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var updateTextField: UITextField!
    
    @Published private var cancellable = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        didChangedTextFieldText()
    }

    private func didChangedTextFieldText() {
        let textFieldPublisher = NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: updateTextField)
            .map { ($0.object as? UITextField)?.text }
        
        textFieldPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] value in
                self?.targetLabel.text = value
            })
            .store(in: &cancellable)
    }
}

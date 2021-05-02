import UIKit
import Combine

class ViewController: UIViewController {
    
    private lazy var mainTableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        return tableView
    }()
    
    private lazy var addNumberButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.backgroundColor = UIColor.systemYellow
        button.addTarget(self, action: #selector(addNumberButtonTouched), for: .touchUpInside)
        return button
    }()
    
    private let viewModel = MainViewModel()
    private var subscription = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMainTableView()
        configureAddNumberButton()
        //bind()
    }
    
    private func bind() {
        viewModel.$numberList
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.mainTableView.insertRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
            }
            .store(in: &subscription)
    }
}

//MARK: -Configuration
private extension ViewController {
    private func configureMainTableView() {
        view.addSubview(mainTableView)
        mainTableView.translatesAutoresizingMaskIntoConstraints = false
        mainTableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        mainTableView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        mainTableView.register(MyTableViewCell.self, forCellReuseIdentifier: "MyCell")
        mainTableView.dataSource = self
    }
    
    private func configureAddNumberButton() {
        mainTableView.addSubview(addNumberButton)
        addNumberButton.translatesAutoresizingMaskIntoConstraints = false
        addNumberButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        addNumberButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        addNumberButton.centerXAnchor.constraint(equalTo: mainTableView.centerXAnchor).isActive = true
        addNumberButton.topAnchor.constraint(equalTo: mainTableView.topAnchor, constant: 10).isActive = true
    }
}

//MARK: -Action
private extension ViewController {
    @objc private func addNumberButtonTouched() {
        viewModel.numberList.append(viewModel.lastNumber()+1)
        
        let alert = UIAlertController(title: "체크", message: "홀수입니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: .none))
        
        viewModel.errorAndValue()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { error in
                switch error {
                case .failure(.notEven):
                    print(error)
                    self.mainTableView.insertRows(at: [IndexPath(row: self.viewModel.numberList.count-1, section: 0)], with: .automatic)
                    self.present(alert, animated: true, completion: nil)
                case .finished:
                    break
                }
            }, receiveValue: { value in
                self.mainTableView.insertRows(at: [IndexPath(row: self.viewModel.numberList.count-1, section: 0)], with: .automatic)
                print(value)
            })
            .store(in: &subscription)
    }
    
}

//MARK: -DataSource
extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as? MyTableViewCell else {
            return UITableViewCell()
        }
        cell.setupLabel(viewModel.getString(indexPath.row))
        return cell
    }
}

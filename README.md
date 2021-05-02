## Combine Study.2
- Future를 활용하여 ViewModel의 List에 추가될 때 Error로 처리한다.
- 홀수가 추가될 경우 Error를 받아서 Alert창을 화면에 보여준다.
- 숫자가 추가되면 TableView의 Cell의 label.text를 업데이트한다.

## Swift Code
```swift
@Published var numberList = [1]
```
- ViewModel Class에 있는 list를 @Published로 선언한다.

```swift
func errorAndValue() -> Future<Int, MyError> {
    let future = Future<Int, MyError> { promise in
        if self.lastNumber() % 2 == 1
        {
            promise(.failure(.notEven))
                
        }
        else
        {
            promise(.success(self.lastNumber()))
        }
    }
    return future
}
```
- Future를 활용하여 홀수인 경우 Error로 설정한다.

```swift 
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
```
- numberLisit에 변화값이 있을 때마다 TableView를 다시 그려준다.

## 실행화면
<img src="https://user-images.githubusercontent.com/74946802/116801118-bf8f5e00-ab41-11eb-8e61-d8489d010995.gif" width="300" height="600">

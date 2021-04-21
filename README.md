## Combine Study.1
- Combine을 활용하여 텍스트필드에 값을 입력하면 Label에 반영되도록 프로그래밍한다.

## Swift Code
```swift
@Published private var cancellable = Set<AnyCancellable>()
```
- 먼저 AnyCancellable을 Publisher로 사용하기 위해 @Published를 활용하여 선언한다.

```swift
let textFieldPublisher = NotificationCenter.default
    .publisher(for: UITextField.textDidChangeNotification, object: updateTextField)
    .map { ($0.object as? UITextField)?.text }
```
- NotificationCenter를 publihser로 등록하고, TextField의 text값을 보낼준비를 한다.

```swift
textFieldPublisher
    .receive(on: DispatchQueue.main)
    .sink(receiveValue: { [weak self] value in
        self?.targetLabel.text = value
    })
    .store(in: &cancellable)
```
- View를 업데이트해서 그려줘야하기 때문에 main 큐로 받아온다.
- [weak self]를 활용하여 강한순환참조 문제를 해결해준다.

## 실행화면
<img src="https://user-images.githubusercontent.com/74946802/115480884-66dcdd00-a286-11eb-93f7-ac008a99ebd0.gif" width="300" height="600">

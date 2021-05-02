import Foundation
import Combine

class MainViewModel {
    
    @Published var numberList = [1]
    
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
    
    func getString(_ index:Int) -> String {
        return String(numberList[index])
    }
    
    func lastNumber() -> Int {
        return numberList[numberList.endIndex-1]
    }
}

enum MyError: Error {
    case notEven
}

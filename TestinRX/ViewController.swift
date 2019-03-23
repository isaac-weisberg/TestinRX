import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    let oneRelay = BehaviorRelay(value: 0)
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.global().async {[unowned self] in
            print("Before one sub")
            
            /*
             Subscription will happen on global concurrent queue,
             and - surprise-surprise - the initial emission
             will happen in a synchronous context on the same global queue
             */
            self.oneRelay
                .bind { val in
                    print("one:", val) // SET BREAKPOINT HERE
                }
                .disposed(by: self.disposeBag)
            
            DispatchQueue.global().async {[unowned self] in
                self.oneRelay.accept(5) // synchronous execution starting
                                        //on global concurrent queue
            }
            
            DispatchQueue.main.async {
                self.oneRelay.accept(8) // synchronous execution
                                        // starting on main serial queue
            }
            
            print("After two sub")
        }
    }
}

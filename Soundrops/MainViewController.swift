import UIKit

class MainViewController: UIViewController {
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.destination is DashboardViewController {
            let trans = CATransition()
            trans.type = kCATransitionMoveIn
            trans.subtype = kCATransitionFromBottom
            trans.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            trans.duration = 0.35
            self.navigationController?.view.layer.add(trans, forKey: nil)
            
        }
        if segue.destination is ForMeViewController {
            let trans = CATransition()
            trans.type = kCATransitionMoveIn
            trans.subtype = kCATransitionFromLeft
            trans.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            trans.duration = 0.35
            self.navigationController?.view.layer.add(trans, forKey: nil)
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizerDirection.right {
        }
        else if gesture.direction == UISwipeGestureRecognizerDirection.left {
            self.performSegue(withIdentifier: "main_for_me", sender: self)
        }
        else if gesture.direction == UISwipeGestureRecognizerDirection.up {
        }
        else if gesture.direction == UISwipeGestureRecognizerDirection.down {
            self.performSegue(withIdentifier: "main_dashboard", sender: self)

        }
    }
    
  

}

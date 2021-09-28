import AutoLayout
import UIKit

final class ViewController: UIViewController
{
    private let dismissButton = UIButton()
    
    init(bgColor: UIColor) {
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = bgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(dismissButton)
        dismissButton.setTitle("Dismiss", for: .normal)
        dismissButton.addTarget(self, action: #selector(didTapDismiss(sender:)), for: .touchUpInside)
        dismissButton.al.center()
    }
    
    @objc
    func didTapDismiss(sender: UIButton) {
        dismiss(animated: true)
    }
}


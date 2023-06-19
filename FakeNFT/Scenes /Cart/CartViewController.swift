import UIKit

class CartViewController: UIViewController {
    private lazy var sortButton = UIBarButtonItem(
        image: UIImage.Icons.sort,
        style: .plain,
        target: self,
        action: #selector(didTapSortButton)
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
    }
    
    @objc
    private func didTapSortButton() {
        // TODO: добавить сортировку
    }
}

// MARK: - Layout methods

private extension CartViewController {
    
    func setupNavBar() {
        navigationController?.navigationBar.tintColor = .black
        navigationItem.rightBarButtonItem = sortButton
    }
}

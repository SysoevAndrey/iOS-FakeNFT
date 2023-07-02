//
//  Catalogue.swift
//  FakeNFT
//
//  Created by Konstantin Kirillov on 25.06.2023.
//

import UIKit

final class CollectionListViewController: UIViewController {
	private lazy var tableView: UITableView = {
		let tableView = UITableView()
		tableView.register(CollectionListCell.self)
		tableView.rowHeight = 187
		tableView.separatorStyle = .none
		tableView.translatesAutoresizingMaskIntoConstraints = false
		
		tableView.dataSource = self
		tableView.delegate = self
		return tableView
	}()
	
	private lazy var sortButton = UIBarButtonItem(
		image: UIImage.Icons.sort,
		style: .plain,
		target: self,
		action: #selector(sortCollections)
	)
	
	private var collectionListViewModel: CollectionListViewModel?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if collectionListViewModel == nil {
			collectionListViewModel = CollectionListViewModel(provider: CatalogueDataProvider())
		}
		
		bindViewModel()
		setupLayout()
		setupNavBar()
		
		UIBlockingProgressHUD.show()
		collectionListViewModel?.getCollections()
	}
	
	func initialise(viewModel: CollectionListViewModel) {
		self.collectionListViewModel = viewModel
	}
	
	private func bindViewModel() {
		guard let viewModel = collectionListViewModel else { return }
		viewModel.$collections.bind { [weak self] _ in
			guard let self = self else { return }
			self.tableView.reloadData()
			UIBlockingProgressHUD.dismiss()
		}
	}
	
	private func setupNavBar() {
		navigationItem.rightBarButtonItem = sortButton
		navigationController?.navigationBar.tintColor = .black
	}
	
	private func setupLayout() {
		view.addSubview(tableView)
		
		NSLayoutConstraint.activate([
			tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
			tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
			tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
			tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
		])
	}

	@objc
	private func sortCollections() {
		let actionSheet = UIAlertController(title: "Сортировка",
											message: nil,
											preferredStyle: .actionSheet)
		
		let sortByName = UIAlertAction(title: "По названию",
									   style: .default) { [weak self] _ in
			guard let self = self else { return }
			
			UIView.animate(withDuration: 0.3) {
				self.collectionListViewModel?.setFilterByName()
				self.view.layoutIfNeeded()
			}
		}
		
		let sortByCount = UIAlertAction(title: "По количеству NFT",
									   style: .default) { [weak self] _ in
			guard let self = self else { return }
			
			UIView.animate(withDuration: 0.3) {
				self.collectionListViewModel?.setFilterByCount()
				self.view.layoutIfNeeded()
			}
		}
		
		let cancel = UIAlertAction(title: "Отмена", style: .cancel)
		
		actionSheet.addAction(sortByName)
		actionSheet.addAction(sortByCount)
		actionSheet.addAction(cancel)
		
		present(actionSheet, animated: true)
	}
}

extension CollectionListViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		collectionListViewModel?.collections.count ?? 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: CollectionListCell = tableView.dequeueReusableCell()
		
		guard let collectionItem = collectionListViewModel?.collections[indexPath.row] else { return UITableViewCell() }
		cell.config(collectionItem: collectionItem)
		
		return cell
	}
}

extension CollectionListViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let collection = collectionListViewModel?.collections[indexPath.row] else { return }
		
		let collectionVC = CollectionViewController()
		let collectionVM = CollectionViewModel()
		collectionVC.modalPresentationStyle = .fullScreen
		collectionVC.initialise(viewModel: collectionVM, model: collection)
		
		navigationController?.pushViewController(collectionVC, animated: true)
	}
}

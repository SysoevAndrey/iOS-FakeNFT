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
		return tableView
	}()
	
	private lazy var filterButton: UIButton = {
		let button = UIButton()
		button.setImage(UIImage.Icons.sort, for: .normal)
		button.addTarget(self,
						 action: #selector(sortCollections),
						 for: .touchUpInside)
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}()
	
	private var collectionListViewModel: CollectionListViewModel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if collectionListViewModel == nil {
			collectionListViewModel = CollectionListViewModel(provider: MockCatalogueProvider())
		}
		
		bindViewModel()
		setupLayout()
	}
	
	func initialise(viewModel: CollectionListViewModel) {
		self.collectionListViewModel = viewModel
	}
	
	private func bindViewModel() {
		
	}
	
	private func setupLayout() {
		view.addSubview(tableView)
		view.addSubview(filterButton)
		
		NSLayoutConstraint.activate([
			tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
			tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
			tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 64),
			tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
			
			filterButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			filterButton.heightAnchor.constraint(equalToConstant: 42),
			filterButton.widthAnchor.constraint(equalToConstant: 42),
			filterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -9)
		])
	}

	@objc
	private func sortCollections() {
		let actionSheet = UIAlertController(title: "Сортировка",
											message: nil,
											preferredStyle: .actionSheet)
		
		let sortByName = UIAlertAction(title: "По названию",
									   style: .default) { [weak self] _ in
			self?.collectionListViewModel.setFilterByName()
		}
		
		let sortByCount = UIAlertAction(title: "По количеству NFT",
									   style: .default) { [weak self] _ in
			self?.collectionListViewModel.setFilterByCount()
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
		collectionListViewModel.collections.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: CollectionListCell.defaultReuseIdentifier, for: indexPath)
		
		guard let collectionItemCell = cell as? CollectionListCell else {
			return UITableViewCell()
		}
		
		let collectionItem = collectionListViewModel.collections[indexPath.row]
		collectionItemCell.config(collectionItem: collectionItem)
		return cell
	}
}

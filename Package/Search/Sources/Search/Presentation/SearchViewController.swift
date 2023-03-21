//
//  File.swift
//  
//
//  Created by 엄기철 on 2023/03/19.
//

import Foundation
import UIKit

import ModuleComponents
import SearchRequirement

import ReactorKit

import DetailRequirement


import DomainEntity


final class SearchViewController: UIViewController, SearchControllerable, ReactorKit.View {
    
    // MARK: - View
    lazy var content = ListView().then {
        $0.delegate = self
    }
    
    // MARK: - Property
    var router: SearchRoutable?
    weak var listener: SearchListener?
    
    var disposeBag: DisposeBag = DisposeBag()
    
    typealias Reactor = SearchReactor
    
    // MARK: - Initializer
    
    // MARK: - Lifecycle
    override func loadView() {
        self.view = content
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
    }
    
    // MARK: - Public
    
    // MARK: - Private
    private func setUp() {
        setUpLayout()
        setUpAction()
        configureNavigationBar()
        configureSearchController()
    }
    
    private func setUpLayout() {
        self.view.backgroundColor = .white
    }
    
    private func setUpAction() {}
    
    private func configureNavigationBar() {
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
        
        navigationItem.title = "검색"
    }
    
    private func configureSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "검색어 입력"
        
        let textField = searchController.searchBar.searchTextField
        textField.textColor = .black
        
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        searchController.automaticallyShowsCancelButton = true
    }
    
    func bind(reactor: SearchReactor) {
        self.bindViewDidLoad(reactor: reactor)
        self.bindKeywordRemove(reactor: reactor)
        self.bindErrorMessage(reactor: reactor)
        self.bindTableViewSection(reactor: reactor)
        self.bindSelectedItem(reactor: reactor)
    }
}

extension SearchViewController {
    private func bindViewDidLoad(reactor: Reactor) {
        self.rx.viewWillAppear
            .take(1)
            .map { _ in Reactor.Action.searchHistoryAll }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
    }
    
    private func bindKeywordRemove(reactor: Reactor) {
        reactor.pulse(\.$removeSearchKeyword)
            .compactMap { $0 }
            .asDriver(onErrorJustReturn: "")
            .drive(with: self, onNext: { vc , keyword in
                vc.navigationItem.searchController?.searchBar.text = keyword
            })
            .disposed(by: self.disposeBag)
    }
    
    private func bindErrorMessage(reactor: Reactor) {
        reactor.pulse(\.$isErrorMessage)
            .compactMap { $0 }
            .asDriver(onErrorJustReturn: "")
            .drive(with: self, onNext: { vc, message in
                let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
                let confirmAction =  UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(confirmAction)
                vc.present(alert, animated: true)
            })
            .disposed(by: self.disposeBag)
    }
    
    private func bindTableViewSection(reactor: Reactor) {
        reactor.pulse(\.$searchSection)
            .compactMap { $0 }
            .asDriver(onErrorJustReturn: [])
            .drive(with: self, onNext: {vc, section in
                vc.content.updateUI(sections: section)
            })
            .disposed(by: self.disposeBag)
    }
    
    private func bindSelectedItem(reactor: Reactor) {
        reactor.pulse(\.$selectedItem)
            .compactMap { $0 }
            .asDriver(onErrorJustReturn: .init(item: .init()))
            .drive(with: self) { vc, items in
                guard let router = vc.router?.routeToDetail(with: DetailParameter.init(viewModel: items )) as? DetailControllerable else { return }
                router.listener = self
                vc.navigationController?.pushViewController(router.uiviewController, animated: true)
            }
            .disposed(by: self.disposeBag)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.reactor?.action.onNext(Reactor.Action.searchHistoryAll)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text?.lowercased() else { return }
        self.reactor?.action.onNext(Reactor.Action.searchText(keyword: text))
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text?.lowercased() else { return }
        guard !text.isEmpty else { return }
        self.reactor?.action.onNext(Reactor.Action.updateSearchText(keyword: text))
    }
}


extension SearchViewController: ListViewDelegate {
    func selectedItem(with item: StoreDomainEntity) {
        self.reactor?.action.onNext(Reactor.Action.selectedItem(item))
    }
    
    func selectedKeyword(with keyword: String) {
        self.navigationItem.searchController?.searchBar.text = keyword
        self.reactor?.action.onNext(Reactor.Action.searchText(keyword: keyword))
    }
}

extension SearchViewController: DetailListener {}

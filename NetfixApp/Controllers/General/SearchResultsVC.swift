//
//  SearchResultsVC.swift
//  NetfixApp
//
//  Created by Шарап Бамматов on 03.08.2022.
//

import UIKit

protocol SearchResultsVCDelegate:AnyObject {
    func SearchResultsVCDidTapElement(_ viewModel: TitlePreviewViewModel)
}

class SearchResultsVC: UIViewController {
    
    public var titles: [Title] = [Title]()
    
    public weak var delegate: SearchResultsVCDelegate?
    
    
    public let searchResultsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        layout.minimumInteritemSpacing = 0
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.id)
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGreen
        view.addSubview(searchResultsCollectionView)
        searchResultsCollectionView.delegate = self
        searchResultsCollectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultsCollectionView.frame = view.bounds
    }
}

extension SearchResultsVC: UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.id, for: indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
        }
        let titles = titles[indexPath.row]
        cell.configure(with: titles.posterPath ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let titles = titles[indexPath.row]
        let titleName = titles.titleRu ?? ""
        
        APICaller.shared.getMovie(with: titleName) { [weak self] results in
            guard let self = self else {return}
                DispatchQueue.main.async {
                switch results{
                case.success(let videoElement):
                    self.delegate?.SearchResultsVCDidTapElement(TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: titles.overview ?? "", genresID: titles.genreIDS!))
                case.failure(let error):
                    print(error)
                }
            }
        }
       
    }

}

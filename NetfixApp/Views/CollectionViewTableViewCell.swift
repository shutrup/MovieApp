//
//  CollectionViewTableViewCell.swift
//  NetfixApp
//
//  Created by Шарап Бамматов on 02.08.2022.
//

import UIKit
protocol CollectionViewTableViewCellDelegate: AnyObject {
    func CollectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewViewModel)
}
class CollectionViewTableViewCell: UITableViewCell {
    
    static let id = "CollectionViewTableViewCell"
    
    weak var delegate: CollectionViewTableViewCellDelegate?
    private var titles: [Title] = [Title]()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.id)
        return collection
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemPink
        contentView.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    public func configure(with titles: [Title]){
        self.titles = titles
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    private func downloadTitleAt(indexPath: IndexPath){
        DataPersistenceManager.shared.downloadTitleWith(model: titles[indexPath.row]) { results in
            switch results{
            case.success():
                NotificationCenter.default.post(name: NSNotification.Name("скачали"), object: nil)
            case.failure(let error):
                print(error)
            }
        }
    }
}

extension CollectionViewTableViewCell: UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.id, for: indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: titles[indexPath.row].posterPath!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let title = titles[indexPath.row]
        guard let titleName = title.titleRu ?? title.name else {
            return
        }
        
        APICaller.shared.getMovie(with: titleName + " trailer") {[weak self] results in
            guard let self = self else {return}
            DispatchQueue.main.async { [self] in
                switch results{
                case.success(let videoElement):
                    let titles = self.titles[indexPath.row]
                    guard let titleOverview = titles.overview else {return}
                    let model = TitlePreviewViewModel(title: titleName, youtubeView: videoElement , titleOverview: titleOverview, genresID: titles.genreIDS!)
                    self.delegate?.CollectionViewTableViewCellDidTapCell(self, viewModel: model)
                case.failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(identifier: nil,
                                                previewProvider: nil) { _ in
            let downloadAction = UIAction(title: "Сохранить", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) {[weak self] _ in
                self?.downloadTitleAt(indexPath: indexPath)
            }
            
            return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [downloadAction])
        }
        return config
    }
    
    
}

//
//  TitlePreviewVC.swift
//  NetfixApp
//
//  Created by Шарап Бамматов on 04.08.2022.
//

import UIKit
import WebKit
import SnapKit

class TitlePreviewVC: UIViewController {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.numberOfLines = 0
        label.text = "Harry poter"
        return label
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 5
        label.text = "This is the best movie ever to watch as s kid!"
        return label
    }()

    private let webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    private let genreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .lightGray
        label.text = "Жанры:"
        return label
    }()
    
    let genresCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(GenresCollection.self, forCellWithReuseIdentifier: GenresCollection.id)
        return collection
    }()
    
    var genres:[Genre] = [Genre]() {
        didSet {
            changedGenres = genres.filter({
                receivedGenres.contains($0.id!)
            })
            genresCollectionView.reloadData()
        }
    }
    
    var changedGenres:[Genre] = [Genre]()
    var receivedGenres:[Int] = [Int]()
    override func viewDidLoad() {
        super.viewDidLoad()
        getGenres()
        view.backgroundColor = .systemBackground
        view.addSubview(webView)
        view.addSubview(titleLabel)
        view.addSubview(overviewLabel)
        view.addSubview(genreLabel)
        view.addSubview(genresCollectionView)
        configureConstraints()
        
        genresCollectionView.dataSource = self
        genresCollectionView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    private func configureConstraints(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(reveralText))
        overviewLabel.isUserInteractionEnabled = true
        overviewLabel.addGestureRecognizer(tap)
        
        
        let webViewConstraints = [
            webView.topAnchor.constraint(equalTo: view.topAnchor,constant: 50),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.heightAnchor.constraint(equalToConstant: 300)
        ]
        
        let titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: webView.bottomAnchor,constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        
        let overViewLabelConstraints = [
            overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,constant: 15),
            overviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            overviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            
        ]
        
        let genreLabelConstraints = [
            genreLabel.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 20),
            genreLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            genreLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        
        genresCollectionView.snp.makeConstraints { make in
            make.top.equalTo(genreLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(200)
        }
        
        NSLayoutConstraint.activate(webViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(overViewLabelConstraints)
        NSLayoutConstraint.activate(genreLabelConstraints)
       
        
    }
    
    @objc func reveralText(sender: UIButton!) {
        if overviewLabel.numberOfLines != 0{
            overviewLabel.numberOfLines = 0
        }else{
            overviewLabel.numberOfLines = 5
            
        }
    
    }
    
    func configure(with model:TitlePreviewViewModel){
        titleLabel.text = model.title
        overviewLabel.text = model.titleOverview
        
        guard let url = URL(string: "https://www.youtube.com/embed/\(model.youtubeView.id.videoId)") else {return}
        webView.load(URLRequest(url: url))
        receivedGenres = model.genresID
    }
    
    private func getGenres(){
        APICaller.shared.getGenres { [weak self] results in
            guard let self = self else {return}
            DispatchQueue.main.async {
                switch results{
                case .success(let genres):
                    self.genres = genres
                    self.genresCollectionView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }

}

extension TitlePreviewVC: UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120.0, height: 20.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return changedGenres.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenresCollection.id, for: indexPath) as? GenresCollection else {
            return UICollectionViewCell()
        }
        let genres = changedGenres[indexPath.row]
        
        cell.configure(with: genres)
        return cell
    }
    
    
}

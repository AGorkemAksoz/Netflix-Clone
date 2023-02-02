//
//  DownloadsViewController.swift
//  Netflix Clone
//
//  Created by Ali Görkem Aksöz on 31.01.2023.
//

import UIKit

class DownloadsViewController: UIViewController {
    
    private var titles: [TitleItem] = [TitleItem]()
    
    private let downloadedTable: UITableView = {
        
       let tableView = UITableView()
        tableView.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return tableView
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Downloads"
        
        view.addSubview(downloadedTable)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        downloadedTable.delegate = self
        downloadedTable.dataSource = self
        
        fetchLocalStorageForDownload()
        NotificationCenter.default.addObserver(forName: NSNotification.Name("Downloaded"), object: nil, queue: nil) { _ in
            self.fetchLocalStorageForDownload()
        }
    }
    
    private func fetchLocalStorageForDownload() {
        DataPersistenceManager.shared.fetchingTitlesFromDatabase { [weak self] results in
            switch results {
            case .success(let titles):
                self?.titles = titles
                
                DispatchQueue.main.async {
                    self?.downloadedTable.reloadData()
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        downloadedTable.frame = view.bounds
    }


}

extension DownloadsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        let title = titles[indexPath.row].orignal_title ?? titles[indexPath.row].original_name ?? "Unknwon"
        let posterPath = titles[indexPath.row].poster_path ?? "Unkown"
        cell.configure(with: TitleViewModel(titleName: title, posterURL: posterPath))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            DataPersistenceManager.shared.deleteTitle(with: titles[indexPath.row]) { [weak self ]result in
                switch result {
                case .success(_):
                    print("Deleted from the database")
                case .failure(let failure):
                    print(failure.localizedDescription)
                }
                self?.titles.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
            }
            
        default:
            break
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        
        guard let titleName = title.orignal_title ?? title.original_name  else { return }
        
        APICaller.shared.getMovie(with: titleName) { [weak self] result in
            switch result {
            case .success(let videoElement):
                DispatchQueue.main.async {
                    let vc = TitlePreviewViewController()
                    vc.configure(with: TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: title.overview!))
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
}

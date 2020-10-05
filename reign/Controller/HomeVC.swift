//
//  HomeVC.swift
//  reign
//
//  Created by Beto Salcido on 04/10/20.
//  Copyright © 2020 BetoSalcido. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let refreshControl = UIRefreshControl()
    private let dateFormat = DateFormat.shared
    private let labelManager = LabelManager.shared
    private let homeDataModel = HomeDataModel()
    private var data: HackerNews?
    private var deletedNews = [String]()
    
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        configModel()
        configTableView()
        
    }
    
    private func configView() {
        self.navigationController?.navigationBar.isHidden = true
        refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    private func configTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
    }
    
    private func configModel() {
        showLoadingView(transparent: true)
        homeDataModel.delegate = self
        homeDataModel.getData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newsDetail" {
            let vc = segue.destination as! DetailVC
            vc.url = sender as? String
        }
    }
    
    private func reloadData(alert: UIAlertAction!) {
        showLoadingView(transparent: true)
        homeDataModel.getData()
    }
    
    private func removeDeletedNews(data: HackerNews?) {
        if let deletedNews = userDefaults.array(forKey: "deletedNews") as? [String] {
            if let hits = data?.hits {
                for (index, a) in hits.enumerated() {
                    for objectID in deletedNews {
                        if a.objectID == objectID {
                            self.data?.hits?.remove(at: index)
                        }
                    }
                }
            }
        }
        tableView.isHidden = false
        tableView.reloadData()
    }
    
    @objc private func refreshWeatherData(_ sender: Any) {
        homeDataModel.getData()
    }
}


extension HomeVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.hits?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Home") as! HomeTC
        cell.selectionStyle = .none
        if let data = data?.hits?[indexPath.row] {
            cell.configCell(data: data, labelManager: labelManager, dateFormat: dateFormat)
        }
        return cell
    }
    
}

extension HomeVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let data = data?.hits?[indexPath.row], let url = data.storyURL?.value {
            performSegue(withIdentifier: "newsDetail", sender: url)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
             if let element = data?.hits?[indexPath.row], let id = element.objectID {
                deletedNews.append(id)
                userDefaults.set(deletedNews, forKey: "deletedNews")
                data?.hits?.remove(at: indexPath.row)
                let indexPath = IndexPath(item: indexPath.row, section: 0)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
}

extension HomeVC: HomeDataModelDelegate {
    func didReceiveData(response: HackerNews) {
        removeLoadingView()
        refreshControl.endRefreshing()
        data = response
        removeDeletedNews(data: data)
    }

    func didFail(error: CodeError) {
        removeLoadingView()
        switch error {
        case .connectionError:
            AlertManager.showConnectionError(on: self, handlerAction: reloadData)
        default:
             AlertManager.showOverallMessage(on: self, handlerAction: reloadData)
        }
    }
}


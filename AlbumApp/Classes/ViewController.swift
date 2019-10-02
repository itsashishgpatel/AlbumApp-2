//
//  ViewController.swift
//  AlbumApp
//
//  Created by Ashish Patel on 27/09/19.
//  Copyright © 2019 Ashish Patel. All rights reserved.
//

import UIKit



class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    let albumListTable = UITableView()   // creating table view
    let cellID = "CustomCell"   // custom cell id
    var albums = [Album]()  // Array of Album class objects that we gonna retrieve from API
    
    override func viewDidLoad()
    {
        self.createTableView()  // we are calling a function that creates table view
        self.navigationItem.title = "Albums"
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.albums.isEmpty {
            fetchAlbums()
        }
    }
    
    func fetchAlbums() {
        
        let loader = AppLoader(frame: self.view.bounds)  //
        self.view.addSubview(loader)
        loader.showLoaderWithMessage("Loading...")
        
        ApiManager().getAlbums()
            { (status, result, error) in
                if status {
                    if let albumList = result {
                        self.albums = albumList
                    }
                    
                    DispatchQueue.main.async  {
                        AppLoader.hideLoaderIn(self.view)
                        self.albumListTable.reloadData()
                    }
                } else {
                    AppLoader.showErrorIn(view: self.view, withMessage: "Could not fetch details at the moment. Please try again later...")
                }
        }
    }
    
    func createTableView()
    {
        albumListTable.delegate = self
        albumListTable.dataSource = self
        albumListTable.register(AlbumCell.self, forCellReuseIdentifier: cellID) // registering the custom table view cell
        albumListTable.translatesAutoresizingMaskIntoConstraints = false // enabling autolayout to set anchors
        self.view.addSubview(albumListTable)
        
        albumListTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        albumListTable.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        albumListTable.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        albumListTable.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true

        albumListTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath as IndexPath) as! AlbumCell
        cell.album = albums[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = DetailController()
        vc.albumDetail = albums[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
            
        
    }
    
}



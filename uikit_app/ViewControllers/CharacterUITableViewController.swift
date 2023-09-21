//
//  CharacterUITableViewController.swift
//  uikit_app
//
//  Created by Mercedes Franchesca Gonzalez Cejas on 23/8/23.
//

import Foundation

import UIKit

enum Section: String, CaseIterable {
    case Main = "Main Character"
    case Supporting = "Supporting Character"
}

enum SortStyle {
    case name
}


class CharacterCell: UITableViewCell{
    //    @IBOutlet weak var characterImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var characterImage: UIImageView!
    @IBOutlet weak var roleLabel: UILabel!
}

class CharacterDetailViewController: UIViewController{
    var dataSource: CharacterStore = CharacterStore()

    let character: Character
    
    
    @IBOutlet weak var characterImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var roleLabel: UILabel!
    
    @IBOutlet weak var aboutTextView: UITextView!
    @IBOutlet weak var nicknameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        nameLabel.text = character.name
        roleLabel.text = character.role
        if let imageData = character.imageData {
            characterImage.image = UIImage(data: imageData)
        }
        
//      Display the nicknames and about data
        nicknameLabel.text = "Nicknames: \(character.nicknames?.joined(separator: ", ") ?? "none")"
        aboutTextView.text = character.about
    }

    
    
    
    required init?(coder: NSCoder) {
        fatalError("this should never be called!")
    }
    
    init?(coder: NSCoder, character: Character) {
        dataSource.loadCharacterData(character: character)
        self.character = character
        super.init(coder: coder)
    }
}


class CharaterUITableViewController: UITableViewController {
    var dataSource: CharacterStore = CharacterStore()
    
    var activityIndicator = UIActivityIndicatorView()
    
    func setupActivityIndicator() {
        // Centrar el activity indicator horizontalmente
        activityIndicator.center.x = view.center.x
        
        // Posicionar el activity indicator cerca del borde superior
        activityIndicator.frame.origin.y = 20
        
        // Configurar el activity indicator
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        
        // Agregar el activity indicator a la vista
        view.addSubview(activityIndicator)
    }

    
    func setupRefreshControll(){
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configurar el activity indicator
        setupActivityIndicator()
        
        // Configurar el refresh control
        setupRefreshControll()
        
        
        loadDataList()
    }
    
    @IBAction func reloadButton(_ sender: UIBarButtonItem) {
        loadDataList()
    }
    
    @IBSegueAction func showDetailView(_ coder: NSCoder) -> CharacterDetailViewController? {
        guard let indexPath = tableView.indexPathForSelectedRow
        else { fatalError("Nothing selected!") }
        let character = dataSource.info[indexPath.row]
        return CharacterDetailViewController(coder: coder, character: character)
    }
    
    @objc func refreshData() {
        // Iniciar la animación del activity indicator
        activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        // Cargar los datos de la API
        dataSource.loadJikanAPI {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
                self.view.isUserInteractionEnabled = true
                
                // Detener la animación del refresh control
                self.tableView.refreshControl?.endRefreshing()
            }
        }
    }
    
    func loadDataList(){
        // Iniciar la animación del activity indicator
        activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        // Cargar los datos de la API
        dataSource.loadJikanAPI {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
                self.view.isUserInteractionEnabled = true
            }
        }
    }
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.info.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(CharacterCell.self)", for: indexPath) as? CharacterCell
        else { fatalError("Could not create CharacterCell") }
        
        let character = dataSource.info[indexPath.row]
        cell.nameLabel.text = character.name
        cell.roleLabel.text = character.role
        cell.characterImage.image = UIImage(data: character.imageData!)

        
        return cell
    }
    
    
    
}



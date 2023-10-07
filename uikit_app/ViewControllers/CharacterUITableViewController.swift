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
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var characterImage: UIImageView!
    @IBOutlet weak var roleLabel: UILabel!
}

class CharacterDetailViewController: UIViewController{
    var dataSource: CharacterStore = CharacterStore()
    var activityIndicator = UIActivityIndicatorView()
    var refreshControl = UIRefreshControl()
    var overlayView = UIView()
    
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
    
    func setupOverlayView() {
        overlayView.frame = self.view.bounds
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.addSubview(overlayView)
        overlayView.isHidden = true
    }
    
    @objc func refreshData() {
        // Mostrar la vista de superposición y desactivar la interacción del usuario
        overlayView.isHidden = false
        self.view.isUserInteractionEnabled = false
        
        // Iniciar la animación del activity indicator
        activityIndicator.startAnimating()
        
        // Cargar los datos de la API
        dataSource.loadCharacterData(character: character) {
            DispatchQueue.main.async {
                self.reloadData()
                self.activityIndicator.stopAnimating()
                
                // Ocultar la vista de superposición y permitir la interacción del usuario
                self.overlayView.isHidden = true
                self.view.isUserInteractionEnabled = true
                
                // Detener la animación del refresh control
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func setupRefreshControll(){
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    let character: Character
    
    
    @IBOutlet weak var characterImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var roleLabel: UILabel!
    
    @IBOutlet weak var aboutTextView: UITextView!
    @IBOutlet weak var nicknameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configurar el activity indicator
        setupActivityIndicator()
        
        // Configurar el refresh control
        setupRefreshControll()
        
        // Configurar la vista de superposición
        setupOverlayView()
        
        loadDataCharacter(character: character)
    }
    
    
    
    
    required init?(coder: NSCoder) {
        fatalError("this should never be called!")
    }
    
    init?(coder: NSCoder, character: Character) {
        self.character = character
        super.init(coder: coder)
    }
    
    func reloadData(){
        nameLabel.text = character.name
        roleLabel.text = character.role
        if let imageData = character.imageData {
            characterImage.image = UIImage(data: imageData)
        }
        
        //      Display the nicknames and about data
        if let nicknames = character.nicknames, !nicknames.joined(separator: ", ").isEmpty {
            nicknameLabel.text = nicknames.joined(separator: ", ")
        } else {
            nicknameLabel.text = "none"
        }
        
        aboutTextView.text = character.about
    }
    
    func loadDataCharacter(character: Character){
        // Iniciar la animación del activity indicator
        activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        // Cargar los datos de la API
        dataSource.loadCharacterData(character: character) {
            DispatchQueue.main.async {
                self.reloadData()
                self.activityIndicator.stopAnimating()
                self.view.isUserInteractionEnabled = true
            }
        }
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



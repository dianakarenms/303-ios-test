//
//  ViewController.swift
//  ContactsDirectory
//
//  Created by Karen Muñoz on 30/11/17.
//  Copyright © 2017 Karen. All rights reserved.
//

import UIKit

class ContactsListController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet var tbContactsList: UITableView!
    
    // MARK: - Properties
    fileprivate var contacts: [Contact] = []
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        contactsTableSetup()
        
    }
    
    // MARK: - Init Methodsaa
    func contactsTableSetup() {
        tbContactsList.register(UINib(nibName: "ContactCell", bundle: nil), forCellReuseIdentifier: "contactCellId")
        tbContactsList.rowHeight = UITableViewAutomaticDimension
        tbContactsList.estimatedRowHeight = 83

        loadContctsTableContent()
    }
    
    func loadContctsTableContent() {
        let URLString = ContactsAPI.Endpoints.Contacts.getList()
        let url = URL(string: URLString)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        ContactsAPI.request(request: request) { (result, data) in
            print(data)
            // Contacts array from JSON
            let contacts = data.flatMap({ (dict) -> Contact? in
                guard let fname = dict["fname"] as? String,
                    let lname = dict["lname"] as? String,
                    let city = dict["city"] as? String else {
                        return nil
                }
                
                return Contact(fname: String(fname),
                               lname: String(lname),
                               city: String(city))
            })
            
            DispatchQueue.main.async {
                // Update UI
                self.contacts = contacts.sorted(by: {$0.lname! < $1.lname!})
                self.tbContactsList.reloadData()
            }
        }
    }
}

// MARK: - Table View DataSource
extension ContactsListController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCellId") as! ContactCell
        cell.nameLabel.text = "\(contacts[indexPath.row].lname!), \(contacts[indexPath.row].fname!)"
        cell.leCityLabel.text = "\(contacts[indexPath.row].city!)"
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.contacts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contacts.count
    }
}

// MARK: - Table View Delegate
extension ContactsListController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow
        let currentCell = tableView.cellForRow(at: indexPath!)! as! ContactCell
        print(currentCell.nameLabel!.text!)
        
    }
}

//
//  GiftsTableViewController.swift
//  CoreData GiftProject
//
//  Created by Yermakov Anton on 08.09.17.
//  Copyright © 2017 Yermakov Anton. All rights reserved.
//

import UIKit
import CoreData

class GiftsTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    
    var presents = [Presents]()
    var managedObject: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        managedObject = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        tableView.reloadData()
        tableView.rowHeight = 200
        loadData()
    }
    
    @IBAction func addNewGift(_ sender: Any) {
      
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            picker.dismiss(animated: true, completion: {
                self.createGift(with: image)
            })
        }
    }
    
    private func createGift(with image: UIImage){
        
        let giftsItem = Presents(context: managedObject)
        giftsItem.image = NSData(data: UIImageJPEGRepresentation(image, 1)!)
        
        let inputAlert = UIAlertController(title: "GIFTS", message: "Add new present!", preferredStyle: .alert)
        
        inputAlert.addTextField { (textField: UITextField) in
            textField.placeholder = "Person"
        }
        
        inputAlert.addTextField { (textField: UITextField) in
            textField.placeholder = "Present"
        }
        
        inputAlert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (action: UIAlertAction) in
          
            let personText = inputAlert.textFields?.first
            let presentText = inputAlert.textFields?.last
            
            if personText?.text != "" && presentText?.text != ""{
                giftsItem.name = personText?.text
                giftsItem.gift = presentText?.text
                
                do{
                    try self.managedObject.save()
                    self.loadData()
                } catch {
                    print (error.localizedDescription)
                }
            }
        }))
        
        inputAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        self.present(inputAlert, animated: true, completion: nil)
        
    }
    
    
    private func loadData(){
        
        let request : NSFetchRequest<Presents> = Presents.fetchRequest()
        
        do {
            presents = try managedObject.fetch(request)
            self.tableView.reloadData()
        } catch {
            print (error.localizedDescription)
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return presents.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GiftsTableViewCell
        
        let giftsItem = presents[indexPath.row]
        
        cell.myName.text = giftsItem.name
        cell.myGift.text = giftsItem.gift
        
        if let giftsImage = UIImage(data: giftsItem.image! as Data){
            cell.myImage.image = giftsImage
        }
        
        return cell
    }
    
 
 
 }







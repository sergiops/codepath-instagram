//
//  FeedTableViewController.swift
//  codepath-instagram
//
//  Created by Sergio P. on 11/13/19.
//  Copyright © 2019 Sergio P. All rights reserved.
//

import UIKit
import Parse
import Alamofire

class FeedTableViewController: UITableViewController {
    
    var posts = [PFObject]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        DataRequest.addAcceptableImageContentTypes(["application/octet-stream"])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let query = PFQuery(className: "posts")
        query.includeKeys(["author", "comments", "comments.author"])
        query.limit = 20
        query.order(byDescending: "_created_at")
        
        query.findObjectsInBackground { (data, error) in
            if (data != nil) {
                self.posts = data!
                self.tableView.reloadData()
            } else {
                print("Error: \(error?.localizedDescription ?? "No description")")
            }
        }
    }
    
    // MARK: - Feed Actions
    @IBAction func onLogout(_ sender: Any) {
        PFUser.logOut()
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = main.instantiateViewController(withIdentifier: "LoginViewController")
        let delegate = self.view.window?.windowScene?.delegate as! SceneDelegate
        delegate.window?.rootViewController = loginViewController
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return posts.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let activePost = posts[section]
        let comments = (activePost["comments"] as? [PFObject]) ?? []
        return comments.count + 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let activePost = posts[indexPath.section]
        let comments = (activePost["comments"] as? [PFObject]) ?? []
        
        if (indexPath.row == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FeedTableViewCell") as! FeedTableViewCell

            let user = activePost["author"] as! PFUser
            let imageFile = activePost["image"] as! PFFileObject
            let urlString = imageFile.url!
            let imageUrl = URL(string: urlString)!
            
            cell.authorLabel.text = user.username
            cell.captionLabel.text = (activePost["caption"] as! String)
            cell.photoView.af_setImage(withURL: imageUrl)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell") as! CommentTableViewCell
            let activeComment = comments[indexPath.row - 1]
            let user = activeComment["author"] as! PFUser
            cell.nameLabel.text = user.username
            cell.commentLabel.text = (activeComment["text"] as! String)
            return cell
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

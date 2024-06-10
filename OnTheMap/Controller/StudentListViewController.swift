//
//  StudentListViewController.swift
//  OnTheMap
//
//  Created by MadhuBabu Adiki on 6/4/24.
//

import UIKit

class StudentListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadTableData()
        
        // Do any additional setup after loading the view.
        //        let _ = UdacityClient.getStudentList { students, error in
        //            StudentList.studentList = students
        //            DispatchQueue.main.async {
        //                self.tableView.reloadData()
        //            }
        //        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        navigationItem.title = "Student List"
    }
    //}
    
    func reloadTableData() {
        UdacityClient.getStudentList { students, error in
            if !students.isEmpty {
                StudentList.studentList = students
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                self.showTapFailure(message: "Students' Location Download Failed.")
                print("Fetching student data failed")
            }
        }
    }
}


extension StudentListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentList.studentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentItem")!
        let student = StudentList.studentList[indexPath.row]
        
        cell.textLabel?.text = "\(student.firstName)" + " " + "\(student.lastName)"
        cell.imageView?.image = UIImage(systemName: "mappin.and.ellipse" )
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = StudentList.studentList[indexPath.row]
        let urlString = student.mediaURL
        if let url = URL(string: urlString), isValidURL(student.mediaURL) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            print("not a valid url")
            showTapFailure(message: "URL: \(urlString) provided is not a valid URL")
        }
    }
    
    func isValidURL(_ urlString: String) -> Bool {
        guard let url = URL(string: urlString) else { return false }
        return UIApplication.shared.canOpenURL(url)
    }
    
    func showTapFailure(message: String) {
        let alertVC = UIAlertController(title: "Invalid mediaURL", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true)
    }
    
    @IBAction func postALocation(_ sender: Any) {
        performSegue(withIdentifier: "addLocation", sender: nil)
    }
}

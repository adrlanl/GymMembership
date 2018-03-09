//
//  DataViewController.swift
//  GB3HealthClubs
//
//  Created by Adrian Lopez on 12/13/17.
//  Copyright © 2017 Adrian Lopez. All rights reserved.
//

import UIKit
import QuickLook

class DataViewController: UIViewController, QLPreviewControllerDataSource {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var locationNameLbl: UILabel!
    @IBOutlet weak var hoursLbl: UILabel!
    
    var gb3Loc:GB3Data?
    
    var itemURL = URL(string: "http://gb3clubs.com")!
    var fileURL = URL(string: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = gb3Loc?.name
        
        // Hide these
//        locationNameLbl.text = gb3Loc?.name
//        hoursLbl.text = gb3Loc?.hours
//        imageView.image = gb3Loc?.imageName
        
        locationNameLbl.isHidden = true
        hoursLbl.isHidden = true
        imageView.isHidden = true
        
        let classGB3 = gb3Loc!.hours
        //print("Location: \(classGB3)")
        itemURL = URL(string: "http://docs.wixstatic.com/ugd/\(classGB3).pdf")!
        loadClasses()
    }
    
    func loadClasses() {
        let quickLookController = QLPreviewController()
        quickLookController.dataSource = self
        
        // Download the pdf and get it as nsdata
        let data = NSData(contentsOf: itemURL)
        do {
            // Get the documents directory
            let documentsDirectoryURL = try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            // Give the file a name and append it to the file path
            let fileName = gb3Loc!.name
            fileURL = documentsDirectoryURL.appendingPathComponent("\(fileName).pdf")
            // Write the pdf to disk
            try data?.write(to: fileURL!, options: .atomic)
            
            // Make sure the file can be opened and then present the pdf
            if QLPreviewController.canPreview(itemURL as QLPreviewItem) {
                quickLookController.currentPreviewItemIndex = 0
                present(quickLookController, animated: true, completion: nil)
                
                //self.navigationController?.pushViewController(quickLookController, animated: true)
                //self.navigationController?.isNavigationBarHidden = true
                
                // Reload tableView after dismissing PDF
                performSegue(withIdentifier: "backToList", sender: nil)
                self.navigationController?.popToRootViewController(animated: true)
            }
        } catch {
            // cant find the url resource
        }
    }
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return fileURL! as QLPreviewItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

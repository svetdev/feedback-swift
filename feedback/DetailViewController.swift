//
//  DetailViewController.swift
//  feedback
//
//  Created by Andrey Kasatkin on 12/14/16.
//  Copyright © 2016 Svetliy. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!

    @IBOutlet weak var messageTextView: UITextView!
    
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let label = self.detailDescriptionLabel {
               // NSDate().shortDate
                let shortDate = DateFormatter()
                shortDate.dateStyle = .long
                shortDate.timeStyle = .long
                let string = shortDate.string(from: detail.timestamp as! Date)
                label.text = string
            }
            if let nLabel = self.nameLabel {
                nLabel.text = detail.name
            }
            if let eLabel = self.emailLabel {
                eLabel.text = detail.email
            }
            if let mText = self.messageTextView {
                mText.text = detail.message
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: Feedback? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
}



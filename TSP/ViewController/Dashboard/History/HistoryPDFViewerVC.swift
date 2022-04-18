//
//  HistoryPDFViewerVC.swift
//  TSP
//
//  Created by Ankur Kathiriya on 01/09/21.
//

import UIKit
import PDFKit

class HistoryPDFViewerVC: UIViewController {

    @IBOutlet weak var pdfView: PDFView!
    
    var filePathURL:URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let pdfDocument = PDFDocument(url: filePathURL) {
            pdfView.displayMode = .singlePageContinuous
            pdfView.autoScales = true
            pdfView.displayDirection = .vertical
            pdfView.document = pdfDocument
            pdfView.backgroundColor = .white
        }

        // Do any additional setup after loading the view.
    }
    

    @IBAction func buttonDismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}

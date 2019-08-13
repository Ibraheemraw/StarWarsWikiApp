//
//  OpeningIntroController.swift
//  StarWarsWiki
//
//  Created by Ibraheem rawlinson on 8/12/19.
//  Copyright © 2019 Ibraheem rawlinson. All rights reserved.
//

import UIKit

class OpeningIntroController: UIViewController {
    // MARK: - Properties & Outlets
    @IBOutlet weak var textView: UITextView!
    public var intro = String(){
        didSet {
            DispatchQueue.main.async {
                self.textView.reloadInputViews()
            }
        }
    }
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
         callMethods()
    }
    // MARK: - Methods & Actions
    private func callMethods(){
        setupTextView()
    }
    private func setupTextView(){
        textView.text = intro
        print("\(intro)")
        // TODO: make sure the text view is non selected able
    }
}

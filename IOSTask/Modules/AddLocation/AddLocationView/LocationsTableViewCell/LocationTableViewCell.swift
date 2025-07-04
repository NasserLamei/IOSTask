//
//  LocationTableViewCell.swift
//  IOSTask
//
//  Created by Nasser Lamei on 03/07/2025.
//

import UIKit

class LocationTableViewCell: UITableViewCell {

    @IBOutlet weak var viewParent: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblLong: UILabel!
    @IBOutlet weak var lblLat: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
        self.selectionStyle = .none
    }
    
    func setUpUI(){
        viewParent.addShadowAndCorner(cornerRadius: 6, shadowColor: .black, shadowOpacity: 0.16, shadowRadius: 1.5, borderWidth: 0.1, borderColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.06))
    }

 
    func configureCell(data:LocationModel){
        lblName.text = ("Name : \(data.name)")
        lblLat.text = ("Latitude : \(data.latitude)")
        lblLong.text = ("Longitude : \(data.longitude)")
    }
}

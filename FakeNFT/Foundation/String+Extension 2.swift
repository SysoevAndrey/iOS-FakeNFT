//
//  String+Extension.swift
//  FakeNFT
//
//  Created by Konstantin Kirillov on 25.06.2023.
//

import Foundation

extension String{
	var encodeUrl : String {
		return self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
	}
}

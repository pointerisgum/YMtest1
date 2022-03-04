//
//  WKWebView+M.swift
//  Lulla
//
//  Created by Mac on 2018. 3. 16..
//  Copyright © 2018년 pplus. All rights reserved.
//

import WebKit

extension WKWebView {
	
	func load(string: String?) {
		if let string = string, let url = URL(string: string) {
			load(URLRequest(url: url))
		}
	}
	
}


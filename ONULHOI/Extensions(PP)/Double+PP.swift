//
//  Double+PP.swift
//  Lulla
//
//  Created by Mac on 2019/11/11.
//  Copyright © 2019 pplus. All rights reserved.
//

import Foundation

extension Double {
    
    /// FormatType
    ///
    /// distance: 미터 단위 거리
    enum FormatType {
        case distance
    }
    
    func string(type: FormatType) -> String? {
        switch type {
        case .distance:
            if self > 1 {
                return String(format: "%.1fkm", self)
            } else {
                return String(format: "%.fm", self * 1000)
            }
        }
    }
    
}

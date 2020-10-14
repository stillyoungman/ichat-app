//
//  iChatTests.swift
//  iChatTests
//
//  Created by Constantine Nikolsky on 09.10.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//

import XCTest
import UIKit
import iChat

class UIViewExtensions: XCTestCase {
    
    // MARK: - nestedSubviews
    func test_when_noSubviews() throws {
        let topView = UIView()
        
        XCTAssert(topView.nestedSubviews.count == 0)
    }
    
    func test_when_flatSubviews() throws {
        let topView = UIView()
        topView.addSubview(UIView())
        topView.addSubview(UIView())
        
        XCTAssert(topView.nestedSubviews.count == 2)
    }
    
    func test_when_nestedSubviews() throws {
        let topView = UIView()
        topView.addSubview(UIView())
        
        let nested = UIView()
        nested.addSubview(UIView())
        topView.addSubview(nested)
        
        XCTAssertEqual(topView.nestedSubviews.count, 3)
    }
}

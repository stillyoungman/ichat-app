//
//  ContainerTests.swift
//  iChatLibTests
//
//  Created by Constantine Nikolsky on 05.11.2020.
//  Copyright © 2020 Constantine Nikolsky. All rights reserved.
//
// swiftlint:disable force_cast force_try

import Foundation
import XCTest
@testable import iChatLib

class ContainerTests: XCTestCase {
    var sut: (IContainer & IServiceResolver)!
    
    override func setUp() {
        super.setUp()
        sut = Container()
        self.continueAfterFailure = false
    }
    
    func test_should_registerAndResolveSingleton() {
        let toProvide = VendingMachine()
        
        sut.register(as: .singleton,
                     IFoodProvider.self,
                     IMoneyReceiver.self) { _ in toProvide }
        
        let resolvedFoodProvider = sut.resolve(for: IFoodProvider.self) as! VendingMachine
        let resolvedMoneyReceiver = sut.resolve(for: IMoneyReceiver.self) as! VendingMachine
        let resolvedVendingMachine = sut.resolve(for: VendingMachine.self)
        
        XCTAssert(resolvedFoodProvider == toProvide, "Resolved incorrect value.")
        XCTAssert(resolvedMoneyReceiver == toProvide, "Resolved incorrect value.")
        XCTAssert(resolvedVendingMachine == toProvide, "Resolved incorrect value.")
    }
    
    func test_should_registerAndResolveTransient() {
        let factory: (IServiceResolver) -> VendingMachine = { _ in VendingMachine() }
        
        sut.register(as: .transient,
                     IFoodProvider.self,
                     IMoneyReceiver.self,
                     factory: factory)
        
        let resolvedFoodProvider = sut.resolve(for: IFoodProvider.self) as! VendingMachine
        let resolvedMoneyReceiver = sut.resolve(for: IMoneyReceiver.self) as! VendingMachine
        let resolvedVendingMachine = sut.resolve(for: VendingMachine.self)
        
        XCTAssert(resolvedFoodProvider != resolvedMoneyReceiver, "Resolved incorrect value.")
        XCTAssert(resolvedFoodProvider != resolvedVendingMachine, "Resolved incorrect value.")
        XCTAssert(resolvedMoneyReceiver != resolvedVendingMachine, "Resolved incorrect value.")
        XCTAssert(resolvedMoneyReceiver != resolvedVendingMachine, "Resolved incorrect value.")
    }
    
    func test_should_registerAndResolveScoped() {
        let factory: (IServiceResolver) -> VendingMachine = { _ in VendingMachine() }
        
        sut.register(as: .scoped,
                     IFoodProvider.self,
                     IMoneyReceiver.self,
                     factory: factory)
        
        let resolvedFoodProvider = sut.resolve(for: IFoodProvider.self) as! VendingMachine
        let resolvedMoneyReceiver = sut.resolve(for: IMoneyReceiver.self) as! VendingMachine
        let resolvedVendingMachine = sut.resolve(for: VendingMachine.self)
        
        XCTAssert(resolvedFoodProvider == resolvedMoneyReceiver, "Resolved incorrect value.")
        XCTAssert(resolvedFoodProvider == resolvedVendingMachine, "Resolved incorrect value.")
        XCTAssert(resolvedMoneyReceiver == resolvedVendingMachine, "Resolved incorrect value.")
        XCTAssert(resolvedMoneyReceiver == resolvedVendingMachine, "Resolved incorrect value.")
        
        try! sut.nextScope(for: IFoodProvider.self)
        
        let resolved1FoodProvider = sut.resolve(for: IFoodProvider.self) as! VendingMachine
        let resolved1MoneyReceiver = sut.resolve(for: IMoneyReceiver.self) as! VendingMachine
        let resolved1VendingMachine = sut.resolve(for: VendingMachine.self)
        
        XCTAssert(resolved1FoodProvider == resolved1MoneyReceiver, "Resolved incorrect value.")
        XCTAssert(resolved1FoodProvider == resolved1VendingMachine, "Resolved incorrect value.")
        XCTAssert(resolved1MoneyReceiver == resolved1VendingMachine, "Resolved incorrect value.")
        XCTAssert(resolved1MoneyReceiver == resolved1VendingMachine, "Resolved incorrect value.")
        
        XCTAssert(resolved1FoodProvider != resolvedFoodProvider, "Resolved incorrect value.")
        XCTAssert(resolved1MoneyReceiver != resolvedMoneyReceiver, "Resolved incorrect value.")
        XCTAssert(resolved1VendingMachine != resolvedVendingMachine, "Resolved incorrect value.")
    }
    
    func test_should_resolveNonOptionalForOptionalType() {
        let toProvide = VendingMachine()
        var resolvedInstance: VendingMachine?
        
        sut.register(as: .singleton,
                     IFoodProvider.self,
                     IMoneyReceiver.self) { _ in toProvide }
        
        resolvedInstance = sut.resolve()
        XCTAssert(resolvedInstance != nil, "Resolved instance with incorrect type.")
        XCTAssert(resolvedInstance == toProvide, "Resolved incorrect value.")
    }
}

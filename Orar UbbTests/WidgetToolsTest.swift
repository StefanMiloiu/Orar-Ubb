//
//  Orar_UbbTests.swift
//  Orar UbbTests
//
//  Created by Stefan Miloiu on 05.04.2024.
//

import XCTest
@testable import Orar_Ubb

class WidgetToolsTest: XCTestCase {
    private let widgetTools = WidgetTools()
    //MARK: - Tested 16 Apr (Tuesday)
    func testGetWeekFromDate() {
        let week = widgetTools.getWeekFromDate()
        XCTAssertNotEqual(week, "")
        XCTAssertNotNil(week)
    }
    
    func testGetCurrentHour() {
        let hour = widgetTools.getCurrentHour()
        XCTAssertNotEqual(hour, "")
        XCTAssertNotNil(hour)
    }
    
    func testCheckBetween() {
        let result = widgetTools.checkBetween(interval: "01-24")
        let result2 = widgetTools.checkBetween(interval: "8-10")
        XCTAssertEqual(result, true)
        XCTAssertEqual(result2, false)
        //Case for current hour hour 20:45
        //let result3 = widgetTools.checkBetween(interval: "20-22")
        //XCTAssertEqual(result3, true)
    }
    
    func testcheckNextLecture() {
        //Case for current hour hour 20:45
//        let test1 = widgetTools.checkNextLecture(interval: "08-10")
//        let test2 = widgetTools.checkNextLecture(interval: "20-22")
//        let test3 = widgetTools.checkNextLecture(interval: "22-24")
//        XCTAssertEqual(test1, false)
//        XCTAssertEqual(test2, false)
//        XCTAssertEqual(test3, true)
    }
}

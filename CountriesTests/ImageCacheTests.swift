//
//  ImageCacheTests.swift
//  CountriesTests
//
//  Created by Nikolay N. Dutskinov on 23.03.23.
//

import XCTest
@testable import Countries

final class ImageCacheTests: XCTestCase {
    
    var imageCache: ImageCache!
    
    override func setUpWithError() throws {
        imageCache = ImageCache()
        try super.setUpWithError()
    }
    
    override func tearDownWithError() throws {
        imageCache.removeAllImages()
        imageCache = nil
        try super.tearDownWithError()
    }
    
    func testInsertImage() {
        // Given
        let testImage = UIImage(systemName: "multiply.circle.fill")
        let testURL = URL(string: "https://example.com/testImage.png")!
        
        // When
        imageCache.insertImage(testImage, for: testURL)
        
        // Then
        XCTAssertNotNil(imageCache.image(for: testURL))
    }
    
    func testRemoveImage() {
        // Given
        let testImage = UIImage(systemName: "multiply.circle.fill")
        let testURL = URL(string: "https://example.com/testImage.png")!
        
        // When
        imageCache.insertImage(testImage, for: testURL)
        imageCache.removeImage(for: testURL)
        
        // Then
        XCTAssertNil(imageCache.image(for: testURL))
    }
    
    func testRemoveAllImages() {
        // Given
        let image1 = UIImage(systemName: "multiply.circle.fill")
        let testURL1 = URL(string: "https://example.com/testImage1.png")!
        let image2 = UIImage(systemName: "multiply.circle.fill")
        let testURL2 = URL(string: "https://example.com/testImage2.png")!
        
        // When
        imageCache.insertImage(image1, for: testURL1)
        imageCache.insertImage(image2, for: testURL2)
        imageCache.removeAllImages()
        
        // Then
        XCTAssertNil(imageCache.image(for: testURL1))
        XCTAssertNil(imageCache.image(for: testURL2))
    }
    
    func testSubscript() {
        // Given
        let testImage = UIImage(systemName: "multiply.circle.fill")
        let testURL = URL(string: "https://example.com/testImage.png")!
        
        // When
        imageCache[testURL] = testImage
        
        // Then
        XCTAssertNotNil(imageCache[testURL])
    }
    
    func testImageFor() {
        // Given
        let testImage = UIImage(systemName: "multiply.circle.fill")
        let testURL = URL(string: "https://example.com/testImage.png")!
        
        // When
        imageCache.insertImage(testImage, for: testURL)
        
        // Then
        XCTAssertNotNil(imageCache.image(for: testURL))
    }
    
}

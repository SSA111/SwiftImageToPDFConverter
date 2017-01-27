//
//  NSData+ImageToPDFConverter.swift
//  PDF
//
//  Created by Sebastian Andersen on 15/12/14.
//  Copyright (c) 2014 SebastianAndersen. All rights reserved.
//
import Foundation
import UIKit

let defaultResolution: Int = 72

extension NSData {
    
    class func convertImageToPDF(image: UIImage) -> NSData? {
        return convertImageToPDF(image: image, resolution: 96)
    }
    
    class func convertImageToPDF(image: UIImage, resolution: Double) -> NSData? {
        return convertImageToPDF(image: image, horizontalResolution: resolution, verticalResolution: resolution)
    }
    
    class func convertImageToPDF(image: UIImage, horizontalResolution: Double, verticalResolution: Double) -> NSData? {
        
        if horizontalResolution <= 0 || verticalResolution <= 0 {
            return nil;
        }
        
        let pageWidth: Double = Double(image.size.width) * Double(image.scale) * Double(defaultResolution) / horizontalResolution
        let pageHeight: Double = Double(image.size.height) * Double(image.scale) * Double(defaultResolution) / verticalResolution
        
        let pdfFile: NSMutableData = NSMutableData()
        
        let pdfConsumer: CGDataConsumer = CGDataConsumer(data: pdfFile as CFMutableData)!
        
        var mediaBox: CGRect = CGRect(x: 0, y: 0, width: CGFloat(pageWidth), height: CGFloat(pageHeight))
        
        let pdfContext: CGContext = CGContext(consumer: pdfConsumer, mediaBox: &mediaBox, nil)!
        
        pdfContext.beginPage(mediaBox: &mediaBox)
        pdfContext.draw(image.cgImage!, in: mediaBox)
        pdfContext.endPage()
        
        
        return pdfFile
    }
    
    class func convertImageToPDF(image: UIImage, resolution: Double, maxBoundRect: CGRect, pageSize: CGSize) -> NSData? {
        
        if resolution <= 0 {
            return nil
        }
        
        var imageWidth: Double = Double(image.size.width) * Double(image.scale) * Double(defaultResolution) / resolution
        var imageHeight: Double = Double(image.size.height) * Double(image.scale) * Double(defaultResolution) / resolution
        
        let sx: Double = imageWidth / Double(maxBoundRect.size.width)
        let sy: Double = imageHeight / Double(maxBoundRect.size.height)
        
        if sx > 1 || sy > 1 {
            let maxScale: Double = sx > sy ? sx : sy
            imageWidth = imageWidth / maxScale
            imageHeight = imageHeight / maxScale
        }
        
        let imageBox: CGRect = CGRect(x: maxBoundRect.origin.x, y: maxBoundRect.origin.y + maxBoundRect.size.height - CGFloat(imageHeight), width: CGFloat(imageWidth), height: CGFloat(imageHeight));
        
        let pdfFile: NSMutableData = NSMutableData()
        
        let pdfConsumer: CGDataConsumer = CGDataConsumer(data: pdfFile as CFMutableData)!
        
        var mediaBox: CGRect = CGRect(x: 0, y: 0, width: pageSize.width, height: pageSize.height);
        
        let pdfContext: CGContext = CGContext(consumer: pdfConsumer, mediaBox: &mediaBox, nil)!
        
        pdfContext.beginPage(mediaBox: &mediaBox)
        pdfContext.draw(image.cgImage!, in: mediaBox)
        pdfContext.endPage()
        
        return pdfFile
    }
    
    
}

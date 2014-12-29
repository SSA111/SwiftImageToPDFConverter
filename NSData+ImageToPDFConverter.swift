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
        return convertImageToPDF(image, resolution: 96)
    }
    
    
    class func convertImageToPDF(image: UIImage, resolution: Double) -> NSData? {
        return convertImageToPDF(image, horizontalResolution: resolution, verticalResolution: resolution)
    }

    
    class func convertImageToPDF(image: UIImage, horizontalResolution: Double, verticalResolution: Double) -> NSData? {
        
        if horizontalResolution <= 0 || verticalResolution <= 0 {
            return nil;
        }
    
        let pageWidth: Double = Double(image.size.width) * Double(image.scale) * Double(defualtResolution) / horizontalResolution
        let pageHeight: Double = Double(image.size.height) * Double(image.scale) * Double(defualtResolution) / verticalResolution
        
        let pdfFile: NSMutableData = NSMutableData()
        
        let pdfConsumer: CGDataConsumerRef = CGDataConsumerCreateWithCFData(pdfFile as CFMutableDataRef)
        
        var mediaBox: CGRect = CGRectMake(0, 0, CGFloat(pageWidth), CGFloat(pageHeight))
        
        let pdfContext: CGContextRef = CGPDFContextCreate(pdfConsumer, &mediaBox, nil)
        
        CGContextBeginPage(pdfContext, &mediaBox)
        CGContextDrawImage(pdfContext, mediaBox, image.CGImage)
        CGContextEndPage(pdfContext)

    
        return pdfFile
    }
    
    
    class func convertImageToPDF(image: UIImage, resolution: Double, maxBoundRect: CGRect, pageSize: CGSize) -> NSData? {
        
        if resolution <= 0 {
            return nil
        }
        
        var imageWidth: Double = Double(image.size.width) * Double(image.scale) * Double(defualtResolution) / resolution
        var imageHeight: Double = Double(image.size.height) * Double(image.scale) * Double(defualtResolution) / resolution
    
        let sx: Double = imageWidth / Double(maxBoundRect.size.width)
        let sy: Double = imageHeight / Double(maxBoundRect.size.height)

        if sx > 1 || sy > 1 {
            let maxScale: Double = sx > sy ? sx : sy
            imageWidth = imageWidth / maxScale
            imageHeight = imageHeight / maxScale
        }

        let imageBox: CGRect = CGRectMake(maxBoundRect.origin.x, maxBoundRect.origin.y + maxBoundRect.size.height - CGFloat(imageHeight), CGFloat(imageWidth), CGFloat(imageHeight));
        
        let pdfFile: NSMutableData = NSMutableData()
        
        let pdfConsumer: CGDataConsumerRef = CGDataConsumerCreateWithCFData(pdfFile as CFMutableDataRef)

        var mediaBox: CGRect = CGRectMake(0, 0, pageSize.width, pageSize.height);
        
        let pdfContext: CGContextRef = CGPDFContextCreate(pdfConsumer, &mediaBox, nil)
      
        CGContextBeginPage(pdfContext, &mediaBox)
        CGContextDrawImage(pdfContext, imageBox, image.CGImage)
        CGContextEndPage(pdfContext)
    
        return pdfFile
    }
    
    
}
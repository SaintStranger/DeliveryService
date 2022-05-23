//
//  PhotoCollectionLayout.swift
//  DeliveryService
//
//  Created by test on 03.05.2022.
//

import UIKit

class PhotoCollectionLayout: UICollectionViewLayout {
    
    var cacheAttributes = [IndexPath: UICollectionViewLayoutAttributes]()
    
    var columnsCount = 3
    
    private var totalCellHeight: CGFloat = 0
    
    override func prepare() {
        self.cacheAttributes = [:]
        
        guard let collectionView = self.collectionView else {
            return
        }
        

        let itemsCount = collectionView.numberOfItems(inSection: 0)
        
        guard itemsCount > 0 else {
            return
        }
    
        let cellWidth = (collectionView.frame.width - 32) / 3
        
        let cellHeight: CGFloat = cellWidth
        
        var lastX: CGFloat = 8
        var lastY: CGFloat = 0
    
        for index in 0..<itemsCount {
            let indexPath = IndexPath(item: index, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            attributes.frame = CGRect(x: lastX, y: lastY, width: cellWidth, height: cellHeight)

            let isLastColumn = (index + 1) % self.columnsCount == 0
            
            if isLastColumn {
                lastY += cellHeight + 8
                lastX = 8
            } else {
                lastX += cellWidth + 8
            }
            
            cacheAttributes[indexPath] = attributes
            
            self.totalCellHeight = lastY
            
        }
        
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cacheAttributes.values.filter { attributes in return rect.intersects(attributes.frame)
        }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cacheAttributes[indexPath]
    }
    
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: self.collectionView?.frame.width ?? 0, height: self.totalCellHeight)
    }

}

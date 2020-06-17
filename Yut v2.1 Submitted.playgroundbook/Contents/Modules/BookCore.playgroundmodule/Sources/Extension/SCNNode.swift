//
//  WWDC 2020
//
//  Created by BumMo Koo on May 2020.
//  Copyright © 2020 BumMo Koo. All rights reserved.
//

import SceneKit

extension SCNNode {
    var fittingBox: SCNBox {
        let max = boundingBox.max
        let min = boundingBox.min
        let width = CGFloat(max.x - min.x)
        let height = CGFloat(max.y - min.y)
        let length = CGFloat(max.z - min.z)
        return SCNBox(width: width, height: height, length: length, chamferRadius: 0)
    }
    
    func fittingBox(scaled scale: CGFloat) -> SCNBox {
        let max = boundingBox.max
        let min = boundingBox.min
        let width = CGFloat(max.x - min.x) * scale
        let height = CGFloat(max.y - min.y) * scale
        let length = CGFloat(max.z - min.z) * scale
        return SCNBox(width: width, height: height, length: length, chamferRadius: 0)
    }
}

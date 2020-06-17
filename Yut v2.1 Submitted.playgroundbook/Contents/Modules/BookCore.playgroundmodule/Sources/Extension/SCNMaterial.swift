//
//  WWDC 2020
//
//  Created by BumMo Koo on May 2020.
//  Copyright © 2020 BumMo Koo. All rights reserved.
//

import SceneKit

extension SCNMaterial {
    static var floorMaterial: SCNMaterial {
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.systemGreen
        material.metalness.contents = 0.05
        material.specular.contents = 0.05
        return material
    }
}


//
//  ViewController.swift
//  Planets
//
//  Created by Marko Jovanov on 30.8.21.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    let configuration = ARWorldTrackingConfiguration()
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        sceneView.autoenablesDefaultLighting = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sceneView.session.run(configuration)
    }
    override func viewDidAppear(_ animated: Bool) {
        let earthParent = SCNNode()
        let venusParent = SCNNode()
        let moonParent = SCNNode()
        let sun = planet(geometry: SCNSphere(radius: 0.35),
                         diffuse: UIImage(named: "Sun")!,
                         specular: nil,
                         emission: nil,
                         normal: nil,
                         position: SCNVector3(0,0,-1))
        earthParent.position = SCNVector3(0,0,-1)
        venusParent.position = SCNVector3(0,0,-1)
        moonParent.position = SCNVector3(1.2,0,0)
        sceneView.scene.rootNode.addChildNode(sun)
        sceneView.scene.rootNode.addChildNode(earthParent)
        sceneView.scene.rootNode.addChildNode(venusParent)
        
        let earth = planet(geometry: SCNSphere(radius: 0.2),
                           diffuse: UIImage(named: "Earth")!,
                           specular: UIImage(named: "Earth Specular")!,
                           emission: UIImage(named: "Earth Clouds")!,
                           normal: UIImage(named: "Earth Normal")!,
                           position: SCNVector3(1.2,0,0))
        let venus = planet(geometry: SCNSphere(radius: 0.1),
                           diffuse: UIImage(named: "Venus-surface")!,
                           specular: nil,
                           emission: UIImage(named: "Venus-atmosphere")!,
                           normal: nil,
                           position: SCNVector3(0.7,0,0))
        let moonEarth = planet(geometry: SCNSphere(radius: 0.05),
                          diffuse: UIImage(named: "Moon")!,
                          specular: nil,
                          emission: nil,
                          normal: nil,
                          position: SCNVector3(0,0,-0.3))
        
        
        sun.runAction(rotation(time: 8))
        earthParent.runAction(rotation(time: 14))
        venusParent.runAction(rotation(time: 10))
        earth.runAction(rotation(time: 8))
        venus.runAction(rotation(time: 8))
        moonParent.runAction(rotation(time: 2))
        
        earthParent.addChildNode(earth)
        earthParent.addChildNode(moonParent)
        venusParent.addChildNode(venus)
        moonParent.addChildNode(moonEarth)
        earth.addChildNode(moonEarth)
        
    }
    func planet(geometry: SCNGeometry, diffuse: UIImage?, specular: UIImage?, emission: UIImage?, normal: UIImage?, position: SCNVector3) -> SCNNode {
        let planet = SCNNode(geometry: geometry)
        planet.geometry?.firstMaterial?.diffuse.contents = diffuse
        planet.geometry?.firstMaterial?.specular.contents = specular
        planet.geometry?.firstMaterial?.emission.contents = emission
        planet.geometry?.firstMaterial?.normal.contents = normal
        planet.position = position
        return planet
    }
    func rotation(time: TimeInterval) -> SCNAction {
        let rotation = SCNAction.rotateBy(x: 0, y: 2 * .pi, z: 0, duration: time)
        let foreverRotation = SCNAction.repeatForever(rotation)
        return foreverRotation
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
}

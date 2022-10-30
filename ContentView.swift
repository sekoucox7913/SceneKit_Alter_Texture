//
//  ContentView.swift
//  Scene
//
//  Created by sekou on 10/27/22.
//

import SwiftUI
import SceneKit


struct ContentView: View {
    
    let settings = SharedView.shared
    var (scene,cameraNode) = GameScene.shared.makeView()
    
    var body: some View {
        GameView(scene: scene, cameraNode: cameraNode)
    }
}

struct GameView: View {
    let gameScene = GameScene.shared
    
    @State var scene: SCNScene
    @State var cameraNode: SCNNode
    
    var body: some View {
        VStack{
            SceneView(
                scene: scene,
                pointOfView: cameraNode,
                options: [.autoenablesDefaultLighting, .rendersContinuously, .allowsCameraControl])
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2)
            
            Button(action:{
                withAnimation{
                    gameScene.changeTexture()
                }
            }, label: {
                Text("Change Texture")
                    .font(.system(size: 35, weight: .bold))
            })
        }
    }
}

class SharedView: ObservableObject {
    @Published var view:UIView!
    @Published var scene:SCNScene!
    @Published var index: Int!
    static var shared = SharedView()
}


class GameScene: UIView {
    static var shared = GameScene()
    var view: SCNView!
    var scene: SCNScene!
    var cameraNode: SCNNode!
    var index: Int!
    var textures = ["earth", "moon", "sun"]
    var sphereNode: SCNNode!
    
    func makeView() -> (SCNScene, SCNNode) {
        
        let camera = SCNCamera()
        camera.fieldOfView = 30.0
        camera.orthographicScale = 9
        camera.zNear = 0
        camera.zFar = 50
        let light = SCNLight()
        light.color = UIColor.white
        light.type = .omni
        cameraNode = SCNNode()
        cameraNode.simdPosition = SIMD3<Float>(0.0, 0.0, 6)
        cameraNode.camera = camera
        cameraNode.light = light

        scene = SCNScene()
        scene.background.contents = UIColor.white
        
        index = 0
        
        sphereNode = createSphere()
        scene.rootNode.addChildNode(sphereNode)

        view = SCNView()
        view.scene = scene
        view.pointOfView = cameraNode
        
        
        
        return (scene, cameraNode)
    }
    
    func createSphere() -> SCNNode {
        let sphere = SCNSphere(radius: 1)
        sphere.firstMaterial?.diffuse.contents = UIImage(named: textures[index])
        let sphereNode = SCNNode(geometry: sphere)
        sphereNode.name = "sphere"
        sphereNode.position = SCNVector3(0, 0, 0)
        return sphereNode
    }
    
    func changeTexture() {
        index = (index + 1) % textures.count
        sphereNode?.geometry?.firstMaterial?.diffuse.contents = UIImage(named: textures[index])
    }
}


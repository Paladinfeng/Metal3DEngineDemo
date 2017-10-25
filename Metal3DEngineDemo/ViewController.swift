//
//  ViewController.swift
//  Metal3DEngineDemo
//
//  Created by zang qilong on 2017/10/24.
//  Copyright © 2017年 zang qilong. All rights reserved.
//

import UIKit
import MetalKit

enum Colors {
    static let wenderlichGreen = MTLClearColor(red: 0.0,
                                               green: 0.4,
                                               blue: 0.21,
                                               alpha: 1.0)
    static let skyBlue = MTLClearColor(red: 0.66,
                                       green: 0.9,
                                       blue: 0.96,
                                       alpha: 1.0)
}

class ViewController: UIViewController {
    
    var metalView: MTKView = MTKView(frame: CGRect.zero)
    
    var renderer: Renderer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        metalView.device = MTLCreateSystemDefaultDevice()
        metalView.frame = self.view.bounds
        metalView.depthStencilPixelFormat = .depth32Float
        self.view.addSubview(metalView)
        guard let device = metalView.device else {
            fatalError("Device not created. Run on a physical device")
        }
        
        metalView.clearColor =  Colors.wenderlichGreen
        renderer = Renderer(device: device)
        let scene = GameScene(device: device, size: view.bounds.size)
        scene.sceneDelegate = self
        renderer?.scene = scene
        metalView.delegate = renderer
    }
    
    override var prefersStatusBarHidden: Bool { return true }
    
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        renderer?.scene?.touchesBegan(view, touches:touches,
                                      with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        renderer?.scene?.touchesMoved(view, touches: touches,
                                      with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        renderer?.scene?.touchesEnded(view, touches: touches,
                                      with: event)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>,
                                   with event: UIEvent?) {
        renderer?.scene?.touchesCancelled(view, touches: touches,
                                          with: event)
    }
}

extension ViewController: SceneDelegate {
    func transition(to scene: Scene) {
        scene.size = view.bounds.size
        scene.sceneDelegate = self
        renderer?.scene = scene
    }
}



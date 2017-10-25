import MetalKit

class Renderer: NSObject {
  let device: MTLDevice
  var commandQueue: MTLCommandQueue!
  
  var scene: Scene?
  
  var samplerState: MTLSamplerState?
  var depthStencilState: MTLDepthStencilState?

  init(device: MTLDevice) {
    self.device = device
    commandQueue = device.makeCommandQueue()
    super.init()
    buildSamplerState()
    buildDepthStencilState()
  }
  
  private func buildSamplerState() {
    let descriptor = MTLSamplerDescriptor()
    descriptor.minFilter = .linear
    descriptor.magFilter = .linear
    samplerState = device.makeSamplerState(descriptor: descriptor)
  }
  
  private func buildDepthStencilState() {
    let depthStencilDescriptor = MTLDepthStencilDescriptor()
    depthStencilDescriptor.depthCompareFunction = .less
    depthStencilDescriptor.isDepthWriteEnabled = true
    depthStencilState = device.makeDepthStencilState(descriptor: depthStencilDescriptor)
    
  }
}

extension Renderer: MTKViewDelegate {
  func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
    scene?.sceneSizeWillChange(to: size)
  }
  
  func draw(in view: MTKView) {
    guard let drawable = view.currentDrawable,
      let descriptor = view.currentRenderPassDescriptor else { return }
    guard let commandBuffer = commandQueue.makeCommandBuffer() else { return }
    guard let commandEncoder =
        commandBuffer.makeRenderCommandEncoder(descriptor: descriptor) else { return }
    let deltaTime = 1 / Float(view.preferredFramesPerSecond)
    commandEncoder.setFragmentSamplerState(samplerState, index: 0)
    commandEncoder.setDepthStencilState(depthStencilState)
    scene?.render(commandEncoder: commandEncoder,
                  deltaTime: deltaTime)
    commandEncoder.endEncoding()
    commandBuffer.present(drawable)
    commandBuffer.commit()
  }
}



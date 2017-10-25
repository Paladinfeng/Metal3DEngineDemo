# Metal3DEngineDemo

# 如何构建一个简易Metal 3D引擎

## 熟悉Metal api
学习了Metal大概5-7天，略有心得。
在学习metal之前，我认为在GPU渲染管线不变的情况下，Metal和GL ES的编码流程应该也不会发生多大变化。
看了Metal API之后，确认了我的这个想法。

以GL ES为例。绘制一个简单三角形的流程如下。
![](https://ws1.sinaimg.cn/large/006tNc79ly1fk79o69jz6j30sk14e78k.jpg)

那么metal的api与GL ES其实是一一对应的关系。

EAGLContext  <----> MTLDevice
FrameBuffer  <----> MTLCommandBuffer
glViewport   <----> MTLViewPort
glProgram    <----> MTLRenderPipelineState
glDraw   <----> commandEncoder.drawIndexedPrimitives

其中Metal API强的地方有以下几点。

* 淡化GL中GLRenderBuffer, GLFrameBuffer, GLBuffer的概念。渲染绘制只有MTLCommandBuffer，储存顶点数据使用MTLBuffer。简化了Buffer类型。
* 简化了Shader的编译过程，将Shader编译过程前置（查阅了一些资料，Metal是在app加载过程中直接编译Bundle中的所有shader文件）。简化了fragment shader和vertex shader的加载流程。利用MTLLibrary等api一句话加载shader。
* shader中变量的优化。类似于GL ES 3.0中layout的用法。简化了GL ES 2.0中变量类型。attribute， uniform和varying现在简化为attribute一种类型。内置变量使用stage_in来标记。
* 优化了对struct类型的支持，在GL ES中，统一Objective-C中struct和shader中的数据格式非常麻烦。在Metal中有了MTLVertexDescriptor。就变得非常简单了。

综上，Metal的绘制流程就简化为了。
![](https://ws1.sinaimg.cn/large/006tNbRwgy1fku9e7k52oj30wq104dk9.jpg)

## 3D引擎的基本框架

### 基础部件
包含了对纹理，顶点， 相机， 模型， 光照的封装。

#### Renderer.swift
一个protocol，规定了渲染的最基本流程。
#### Texturable.swift
纹理的protocol，规定了绘制纹理的基本需求。
#### Model.swift
利用Model I/O framework 导入Blender制作的obj文件。包含MTKMesh。
#### Instance.swift
用来制造大量重复的model
#### Light
定义光照类型，包括漫反射，镜面反射等

### 上层部件

主要包含Node和Scene。

Node类似于SpriteKit里的sprite。
Scene类似于SpriteKit里的场景。

#### Node
规定了3D场景中某个实例的行为规则。
包括，rotate, scale, translate等transform操作和添加子Node。

#### Scene
规定了场景中的光照，相机位置，处理事件。

## 整体的架构如下

![](https://ws4.sinaimg.cn/large/006tNbRwgy1fku8y7fqv0j31ja0vcgpd.jpg)

## Demo
跟着ray上的教程走了一遍，一个基于Metal的撞砖块游戏

![](https://ws4.sinaimg.cn/large/006tNbRwgy1fku9047v8ij30yi1pce0x.jpg)


## 参考资料

1. video tutorial https://videos.raywenderlich.com/courses/54-beginning-metal/lessons/1


2. https://developer.apple.com/library/content/documentation/3DDrawing/Conceptual/MTLBestPracticesGuide/PersistentObjects.html#//apple_ref/doc/uid/TP40016642-CH4-SW1


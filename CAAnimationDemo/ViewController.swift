import UIKit

class ViewController: UIViewController, CAAnimationDelegate {
  
  //MARK - Properties
  
  @IBOutlet weak var button: UIButton!
  let layerOne = CALayer()
  let layerTwo = CALayer()
  let layerThree  = CALayer()
  let imageLayer = CALayer()
  
  //MARK - KeyPath + Keys
  
  enum KeyPath {
    static let opacity = "opacity"
    static let backgroundColor = "backgroundColor"
    static let positionY = "position.y"
    static let position = "position"
    static let transform = "transform.rotation"
  }
  
  enum Key {
    static let opacityKey = "opacityKey"
    static let layerOne = "layerOne"
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addLayerOne()
    addLayerTwo()
    addLayerThree()
    addImageLayer()
  }
  
  //MARK - Add Layers
  
  private func addLayerOne() {
    button.layer.backgroundColor = UIColor.purple.cgColor
    layerOne.frame = CGRect(x: 10, y: 20, width: 150, height: 150)
    layerOne.backgroundColor = UIColor.blue.cgColor
    // Add as a sublayer to our view's layer
    view.layer.addSublayer(layerOne)
  }
  
  private func addLayerTwo() {
    view.layer.addSublayer(layerTwo)
    layerTwo.frame = CGRect(x: 100, y: 100, width: 150, height: 150)
    layerTwo.backgroundColor = UIColor.orange.cgColor
  }
  
  private func addLayerThree() {
    layerThree.backgroundColor = UIColor.green.cgColor
    layerThree.frame = CGRect(x: 100, y: 100, width: 100, height: 150)
    view.layer.addSublayer(layerThree)
  }
  
  private func addImageLayer() {
    // Add rocket
    let image = UIImage(named: "rocket")
    imageLayer.contents = image?.cgImage
    view.layer.addSublayer(imageLayer)
    // move off right/bottom of screen
    imageLayer.frame = CGRect(x: view.frame.maxX, y: view.frame.maxY, width: (image?.size.width)!, height: (image?.size.height)!)
  }
  
  
  @IBAction func buttonTapped(_ sender: UIButton) {
    
    //1: TODO - Broken animation
    colorAnimation(on: sender)
    
    //    animateOpacityOfBlueView()
    
    //    animationBackgroundColor()
    
    //    animatePosition()
    
    //    animateCorners()
    
    //    transactionAnimation()
    
    //    keyFrameAnimation()
    
    //    keyFrameImageAnimation()
    
    pathAnimation()
    
  }
  
  private func colorAnimation(on button: UIButton) {
    let bgColorAnimation = CABasicAnimation(keyPath: KeyPath.backgroundColor)
    bgColorAnimation.duration = 2.0
    bgColorAnimation.fromValue = UIColor.purple.cgColor
    bgColorAnimation.toValue = UIColor.red.cgColor
    // Prevents animations from reverting to initial values
    bgColorAnimation.isRemovedOnCompletion = false
    bgColorAnimation.fillMode = kCAFillModeForwards
    
    button.layer.add(bgColorAnimation, forKey: nil)
  }
  
  private func animateOpacityOfBlueView() {
    // Animate opacity of blue view
    let opacityAnimation = CABasicAnimation(keyPath: KeyPath.opacity)
    
    opacityAnimation.fromValue = 1
    opacityAnimation.toValue = 0
    opacityAnimation.duration = 2
    opacityAnimation.beginTime = CACurrentMediaTime() + 2
    opacityAnimation.delegate = self
    opacityAnimation.repeatCount = 2
    opacityAnimation.autoreverses = true
    opacityAnimation.setValue(layerOne, forKey: Key.layerOne)
    layerOne.add(opacityAnimation, forKey: Key.opacityKey)
  }
  
  private func animationBackgroundColor() {
    // Animate background color
    
    let colorAnim = CABasicAnimation(keyPath: KeyPath.backgroundColor)
    colorAnim.fromValue = UIColor.blue.cgColor
    colorAnim.toValue = UIColor.green.cgColor
    colorAnim.duration = 0.75
    colorAnim.repeatCount = HUGE  // HUGE == keep repeating
    colorAnim.autoreverses = true
    layerOne.add(colorAnim, forKey: nil)
  }
  
  private func animatePosition() {
    // Animate y position
    let moveAnim = CABasicAnimation(keyPath: KeyPath.positionY)
    moveAnim.fromValue = layerOne.frame.midY
    moveAnim.toValue = 300
    moveAnim.duration = 1.5
    moveAnim.repeatCount = 2
    moveAnim.autoreverses = true
    layerOne.add(moveAnim, forKey: nil)
  }
  
  private func animateCorners() {
    // Animate corner radius
    let cornerAnim = CABasicAnimation(keyPath: "cornerRadius")
    cornerAnim.fromValue = 0
    cornerAnim.toValue = 75
    cornerAnim.duration = 1
    cornerAnim.repeatCount = HUGE
    cornerAnim.autoreverses = true
    layerOne.add(cornerAnim, forKey: nil)
  }
  
  private func transactionAnimation() {
    // Transaction
    
    CATransaction.setCompletionBlock {
      print(#line, "finished")
    }
    CATransaction.begin()
    CATransaction.setAnimationDuration(2.0)
    layerOne.opacity = 0.5
    layerOne.backgroundColor = UIColor.yellow.cgColor
    layerOne.cornerRadius = 75
    CATransaction.commit()
  }
  
  private func keyFrameAnimation() {
    
    // KeyFrame Animations -- `add layerTwo, layerThree`
    let position = CAKeyframeAnimation(keyPath: "position")
    position.values = [ NSValue.init(cgPoint: .zero) , NSValue.init(cgPoint: CGPoint(x: 0, y: -20))  ,  NSValue.init(cgPoint: .zero) ]
    
    position.timingFunctions = [ CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut),  CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)  ]
    
    position.isAdditive = true
    position.duration = 1.2
    
    let rotation = CAKeyframeAnimation(keyPath: "transform.rotation")
    rotation.values = [ 0, 0.14, 0 ]
    rotation.duration = 1.2
    rotation.timingFunctions = [ CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut),  CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)  ]
    
    let fadeAndScale = CAAnimationGroup()
    fadeAndScale.animations = [position, rotation]
    fadeAndScale.duration = 1
    
    layerOne.add(fadeAndScale, forKey: nil)
    layerTwo.add(fadeAndScale, forKey: nil)
  }
  
  func keyFrameImageAnimation() {
    let positionAnimation = CAKeyframeAnimation(keyPath: KeyPath.position)
    positionAnimation.values = [CGPoint(x: view.frame.maxX, y: view.frame.maxY),
                                CGPoint(x: -100, y: view.frame.height/2),
                                CGPoint(x: view.frame.maxX, y: view.frame.height/4),
                                CGPoint(x: -100, y: -50)]
    positionAnimation.timingFunctions = [CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut), CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut), CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut), CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)]
    positionAnimation.keyTimes = [0, 0.5, 0.75, 1]
    positionAnimation.duration = 10
    positionAnimation.fillMode = kCAFillModeForwards
    positionAnimation.isRemovedOnCompletion = false
    
    let transform1 = CABasicAnimation(keyPath: KeyPath.transform)
    transform1.beginTime = 2.0
    transform1.duration = 3.0
    transform1.fromValue = (0).degreesToRadians
    transform1.toValue = (90).degreesToRadians
    transform1.fillMode = kCAFillModeForwards
    transform1.isRemovedOnCompletion = false
    
    
    let transform2 = CABasicAnimation(keyPath: KeyPath.transform)
    transform2.beginTime = 5.0
    transform2.duration = 3.0
    transform2.fromValue = (90).degreesToRadians
    transform2.toValue = (0).degreesToRadians
    transform2.fillMode = kCAFillModeForwards
    transform2.isRemovedOnCompletion = false
    
    
    let group = CAAnimationGroup()
    
    group.animations = [positionAnimation, transform1, transform2]
    group.duration = 10
    
    
    imageLayer.add(group, forKey: nil)
  }
  
  private func pathAnimation() {
    // Path Animation
    let path = UIBezierPath(arcCenter: view.center,
                            radius: 150,
                            startAngle: 0,
                            endAngle: 2.0 * CGFloat.pi,
                            clockwise: true).cgPath
    let pathMoveAnim = CAKeyframeAnimation(keyPath: "position")
    pathMoveAnim.path = path
    pathMoveAnim.duration = 4
    pathMoveAnim.repeatCount = HUGE
    pathMoveAnim.rotationMode = kCAAnimationRotateAuto
    layerThree.add(pathMoveAnim, forKey: nil)
  }
}

extension ViewController {
  func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    print(#line, "Animation done \(anim)")
    if let layer = anim.value(forKey: Key.layerOne) {
      print(#line, #function, layer)
    }
  }
  func animationDidStart(_ anim: CAAnimation) {
    print(#line, "animation started \(anim)")
    if let layer = anim.value(forKey: Key.layerOne) {
      print(#line, #function, layer)
    }
  }
}

extension FloatingPoint {
  var degreesToRadians: Self { return self * .pi / 180 }
  var radiansToDegrees: Self { return self * 180 / .pi }
}



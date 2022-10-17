//
//  ViewController.swift
//  Lab3
//
//  Created by Daniel Ryu on 10/6/22.
//

import UIKit

class ViewController: UIViewController,UIGestureRecognizerDelegate {

    @IBOutlet weak var opacitySlider: UISlider!
    var currentShape: Shape?
    var drawCanvas: DrawingView!
    var currentColor: UIColor!
    var currentOpacity: CGFloat!
    
    @IBOutlet weak var shapesArray: UISegmentedControl!
    @IBOutlet weak var actionArray: UISegmentedControl!
    @IBOutlet weak var colorsArray: UISegmentedControl!
    @IBOutlet weak var fillStrokeArray: UISegmentedControl!
    @IBOutlet weak var canvasFrame: UIView!
    @IBOutlet var rotator: UIRotationGestureRecognizer!
    @IBOutlet var pinch: UIPinchGestureRecognizer!
    var isScaling = false
    var imageBackground: UIImage?
    
    let colors = [UIColor.red, UIColor.green, UIColor.yellow, UIColor.orange, UIColor.systemPink,UIColor.black]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        drawCanvas = DrawingView(frame: canvasFrame.frame)
        drawCanvas.backgroundColor = UIColor.clear
        view.addSubview(drawCanvas)
        selectColor(colorsArray)
        drawCanvas.addGestureRecognizer(pinch)
        drawCanvas.addGestureRecognizer(rotator)
        pinch.cancelsTouchesInView = false
        currentOpacity = CGFloat(opacitySlider.value)
    }
    
    @IBAction func selectColor(_ sender: UISegmentedControl) {
        currentColor = colors[sender.selectedSegmentIndex]
    }
    
    func selectShape(_ origin: CGPoint,_ color: UIColor) -> Shape{
        switch shapesArray.selectedSegmentIndex{
        case 0:
            if (fillStrokeArray.selectedSegmentIndex == 1){
                return StrokeSquare(origin: origin, color: color)
            }
            return Square(origin: origin, color: color)
        case 1:
            if (fillStrokeArray.selectedSegmentIndex == 1){
                return StrokeCircle(origin: origin, color: color)
            }
            return Circle(origin: origin, color: color)
        case 2:
            if (fillStrokeArray.selectedSegmentIndex == 1){
                return StrokeTriangle(origin: origin, color: color)
            }
            return Triangle(origin: origin, color: color)
        default:
            return Circle(origin: origin, color: color)
        }
    }
    
    @IBAction func sliderChange(_ sender: UISlider) {
        currentOpacity = CGFloat(opacitySlider.value)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard touches.count == 1,
              let touchPoint = touches.first?.location(in: drawCanvas)
        else { return }
        
        switch actionArray.selectedSegmentIndex{
        case 0:
            currentShape = selectShape(touchPoint, currentColor)
            currentShape?.opacity = currentOpacity
            drawCanvas.items.append(currentShape!)
        case 1:
            currentShape = drawCanvas.itemAtLocation(touchPoint) as? Shape
        case 2:
            let itemErase = drawCanvas.itemAtLocation(touchPoint)
            drawCanvas.items.removeAll(where: { $0 === itemErase })
            currentShape = nil
        default:
            currentShape = selectShape(touchPoint, currentColor)
            drawCanvas.items.append(currentShape!)
        }
        if let newShape = currentShape {
            drawCanvas.items.append(newShape)
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard touches.count == 1,
              let touchPoint = touches.first?.location(in: drawCanvas)
        else { return }
        
        
        if (actionArray.selectedSegmentIndex == 1 && !isScaling){
            currentShape?.center? = touchPoint
            drawCanvas.setNeedsDisplay()
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        currentShape = nil
    }
    
    @IBAction func clearStuff(_ sender: Any) {
        drawCanvas.items = []
        currentShape = nil
        drawCanvas.backgroundColor = UIColor.white
    }
    
    @IBAction func pinchGesture(_ sender: UIPinchGestureRecognizer) {
        
        if actionArray.selectedSegmentIndex != 1 {
            return
        }
        if let index = drawCanvas.items.lastIndex(where: {$0.contains(point:sender.location(in: drawCanvas))}){
            let pinchShape = drawCanvas.items[index] as? Shape
            
            if pinch.state.rawValue == 1{
                isScaling = true
            }
            
            if let tempShape = pinchShape {
                tempShape.scale = sender.scale
            }
            drawCanvas.setNeedsDisplay()
            
        }
        
        if (pinch.state.rawValue == 3){
            isScaling = false
        }
        
    }
    
    @IBAction func rotateGesture(_ sender: UIRotationGestureRecognizer) {
        if actionArray.selectedSegmentIndex != 1 {
            return
        }
        if let index = drawCanvas.items.lastIndex(where: {$0.contains(point:sender.location(in: drawCanvas))}){
            let rotateShape = drawCanvas.items[index] as? Shape
            
            if let tempShape = rotateShape {
                tempShape.angle = sender.rotation
            }
            
            drawCanvas.setNeedsDisplay()
        }
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
    shouldRecognizeSimultaneouslyWith otherGestureRecognizer:
    UIGestureRecognizer) -> Bool {
     true
    }
    
    @IBAction func uploadPhoto(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    @IBAction func saveCanvas(_ sender: Any) {
        let saveCanvas = UIGraphicsImageRenderer(size: drawCanvas.bounds.size)
        let image = saveCanvas.image { ctx in
            drawCanvas.drawHierarchy(in: drawCanvas.bounds,             afterScreenUpdates: true)
        }
        let PNG = image.pngData()
        if let compressed = UIImage(data: PNG!){
            UIImageWriteToSavedPhotosAlbum(compressed, nil, nil, nil)
            let alert = UIAlertController(title: "Saved!", message: "Your Drawing has been saved to your Photos", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:[UIImagePickerController.InfoKey : Any]){
        
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage{
            imageBackground = image
            let backgroundImage = UIColor(patternImage: imageBackground!)
            drawCanvas.backgroundColor = backgroundImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion:nil)
    }
}

# Soruce Description

1. [Main](#main)
2. [Media Feature](#media)
3. [Admin Feature](#admin)
4. [Cocoapod Library](#cocoapod-library)
5. [Etc](#etc)



# Main








# Media

- 방송 송출(Stream), 방송 수신(Broadcast) 메뉴
- 공통 기능(Common) 메뉴

## Common

### Model

- StoreProductType.swift

### View

- MediaMenuView.swift

### ViewModel

- BroadcastViewModel.swift
- ChatRoomViewModel.swift

### ViewController

- MediaMenuViewController.swift
- MediaMenuViewController+TableView.swift

## **Stream**

### Model

- StreamMenuSegues.swift
- VisualEffect.swift

### View

DrawSqaure.swift

### 1) Menu

- StreamViewController.swift

방송 송출 연결 해제 및 소켓 통신 이벤트 

- StreamViewController+OnboardingView.swift

방송송출 튜토리얼 메뉴

- StreamViewController+InputBarAccessoryView.swift

방송송출 채팅 메뉴

- StreamSettingViewController.swift

방송송출 설정 메뉴  

### 2) Onboarding

조도 센서

줌 컨트롤

뷰티 필터

카메라 반전 필터

방송 송출 라이브러리

- RTMP 송출([HaishinKit](https://github.com/shogo4405/HaishinKit.swift))

## **Broadcast**

- BroadcastViewController.swift

방송 수신 라이브러리

- AVPlayerLayer([VersaPlayer](https://github.com/josejuanqm/VersaPlayer))



# Admin



# Cocoapod Library

CocoadPod 라이브러리 중 SwinjectStoryboard, PictureInPicture, HaishinKit 라이브러리  파일에는 자체 작업 소스가 추가된 상태다. 그렇기 때문에, 라이브러리 수정시 기존에 수정한 소스를 다시 머지하여 기존 기능을 유지해야 한다.

## 작업 내용

SwinjectStoryboard, PictureInPicture, HaishinKit라이브러리에 기존 작업 소스 추가

### SwinjectStoryboard

라이브러리 포팅시 Hash 프로토콜 오류가 발생하기 때문에, Hash 프로토콜 오류를 수정해서 사용해야 한다.

- SwinjectStoryboardOption.swift

```swift
internal var hashValue: Int {
         return controllerType.hashValue
 }

func hash(into: inout Hasher) {
      into.combine(self.controllerType)
 }
```

### PictureInPicture

라이브러리 포팅시 Hash 프로토콜 오류가 발생하기 때문에, Hash 프로토콜 오류를 수정해서 사용해야 한다.

- PictureInPicture.swift

```swift
//기존 소스
static var defaultCorner: Corner {
      return Corner(.bottom, defaultEdge)
}

//수정 소스
static var defaultCorner: Corner {
	      return Corner(.top, defaultEdge)
}
```

- PictureInPictureWindow.swift

```swift
init(disposeHandler: @escaping (() -> Void)) {
//추가 소스
....
    let marginSize = CGSize(width: 20, height: 20)
    let pipCloseButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.width - (100 + marginSize.width), y: marginSize.height, width: 100, height: 100))
    pipCloseButton.setBackgroundImage(UIImage(named: "iconPipClose"), for: .normal)
    pipCloseButton.addTarget(self, action:#selector(tapCloseButton), for: .touchUpInside)
    userInterfaceShutoutView.addSubview(pipCloseButton)
....
}

//추가 소스
@objc private func tapCloseButton() {
      self.dismiss(animation: false)
 }
```

### HaishinKit

RTMP 라이브러리 기능에 줌 기능과 영상 필터 기능을 적용하기 위해 소스를 추가한다.

- VideoIOComponent+Extension.swift

```swift
extension VideoIOComponent {
...................................
// 핀치 줌 기능 추가
@available(iOS 11.0, *)
    func setPinchZoomFactor(_ state: UIGestureRecognizer.State, scale: CGFloat) -> CGFloat {
        guard let device: AVCaptureDevice = (input as? AVCaptureDeviceInput)?.device,
            1 <= zoomFactor && zoomFactor < device.activeFormat.videoMaxZoomFactor
            else { return 0  }
          
        var currentZoomFactor: CGFloat = 0
        
        switch state {
        case .began:
            self.initialZoomScale = device.videoZoomFactor
            currentZoomFactor = initialZoomScale
            
        case .changed:
            var factor = self.initialZoomScale * scale
            factor = max(1, min(factor, 10))
            print("factor",factor)
            
            currentZoomFactor = factor
            do {
                try device.lockForConfiguration()
                device.ramp(toVideoZoomFactor: factor, withRate: 3.0)
                device.unlockForConfiguration()
            } catch let error as NSError {
                logger.error("while locking device for clamp: \(error)")
            }
        default:
            return 0
        }
        
        return currentZoomFactor
    }
    
//카메라 노출 변경 기능
    var camExposureRange: [Float]? {
        get{
            guard let device: AVCaptureDevice = (input as? AVCaptureDeviceInput)?.device else {
                return nil
                }
        
            return [Float(device.minExposureTargetBias), Float(device.maxExposureTargetBias)]
        }
    }
...................................
}
```

- NetStream.swift

```swift
open class NetStream: NSObject {
...................................
//추가 소스
	open func camExposureRange() ->[Float]? {
	        return  mixer.videoIO.camExposureRange
	    }
	    
	    open func changeExposureValue(bias: Float) {
	        mixer.videoIO.exposureBias = bias
	    }
	    
	    @available(iOS 11.0, *)
	    open func setPinchZoomFactor(_ state: UIGestureRecognizer.State, scale: CGFloat) -> CGFloat {
	        return  mixer.videoIO.setPinchZoomFactor(state, scale: scale)
	    }
...................................
}
```

- VideoIOComponent.swift

```swift
final class VideoIOComponent: IOComponent {

		var position: AVCaptureDevice.Position = .back
...................................
//추가 소스
		var initialZoomScale: CGFloat = 1
    var zoomScaleRange: ClosedRange<CGFloat> = 1...10
...................................
//추가 소스
var exposureBias: Float = 0 {
          didSet {
              let exposureMode: AVCaptureDevice.ExposureMode = continuousExposure ? .continuousAutoExposure : .autoExpose
              guard let device: AVCaptureDevice = (input as? AVCaptureDeviceInput)?.device,
                  device.isExposureModeSupported(exposureMode) else {
                      logger.warn("exposureMode(\(exposureMode.rawValue)) is not supported")
                      return
              }
              do {
                  try device.lockForConfiguration()
                  device.exposureMode = .autoExpose
                  device.setExposureTargetBias(exposureBias, completionHandler: nil)
                  device.unlockForConfiguration()
              } catch let error as NSError {
                  logger.error("while locking device for autoexpose: \(error)")
              }
          }
      }
...................................
}

extension VideoIOComponent {
    func encodeSampleBuffer(_ sampleBuffer: CMSampleBuffer) {
	func encodeSampleBuffer(_ sampleBuffer: CMSampleBuffer) {
		// 추가 소스
		autoreleasepool {
...................................
		}
	}
}
```

# Etc

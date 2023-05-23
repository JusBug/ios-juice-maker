# 쥬스메이커🧃

> 과일의 재고를 관리하고 쥬스를 만드는 앱

</br>

## 목차

1. [팀원](#1.)
2. [순서도](#2.)
3. [타임라인](#3.)
4. [실행 화면(기능 설명)](#4.)
5. [트러블 슈팅](#5.)
6. [참고 링크](#6.)
7. [팀 회고](#7.)

---

</br>

<a id="1."></a>

## 1. 팀원

| [Erick](https://github.com/h-suo) | [JusBug](https://github.com/JusBug) |
| :---: | :---: |
| <img src="https://user-images.githubusercontent.com/109963294/235300758-fe15d3c5-e312-41dd-a9dd-d61e0ab354cf.png" height="150"/> | <Img src="https://github.com/JusBug/ios-juice-maker/assets/109963294/53a73571-41d9-4914-a917-d8ea099be948" width="150"/> |

---

<a id="2."></a>

</br>

## 2. 순서도

<details>
<summary>추후 추가 예정</summary>

![](https://hackmd.io/_uploads/SJPYz19r3.png)
    
</details>

</br>

---

<a id="3."></a>

## 3. 타임라인

### 2023.05.15.(월)

**ViewController, View 세팅**
- `ChangeStockViewController` 생성 및 레이아웃 세팅
- `ChangeStockViewController`와 view객체 연결
    -  `Stepper`의 `tag` 설정
- `UIViewController`를 확장하여 alert를 만들어 반환하는 `makeAlertMessage()` 생성

**ViewController간의 데이터 전달**
- `JuiceMakerViewController` -> `ChangeStockViewController`의 데이터 전달은 프로퍼티를 사용하여 구현
- `ChangeStockViewController` -> `JuiceMakerViewController`의 데이터 전달은 `Delegate`를 사용하여 구현
    - `ChangeStockDelegate` 프로토콜 생성

### **2023.05.16.(화)**

**리뷰 확인 및 코드 수정**
- 네이밍 수정
    - 버튼 액션 네임에서 `tap`을 접두사로 사용
    - `ChangeStockProtocol`에서 `ChangeStockDelegate`로 리네임
    - `compose`를 `set`으로 통일
- `JuiceMakerViewController`가 `ChangeStockDelegate`를 채택하는 코드는 extension으로 확장하여 구현

### **2023.05.18.(목)**

- 

### **2023.05.19.(금)**

- 

---

</br>

<a id="4."></a>

## 4. 실행 화면(기능 설명)

| 버튼 액션으로 화면 이동 |
| :--------: |
| <Img src = "https://hackmd.io/_uploads/SyY0G77r3.gif" width="600"/> |

| alert 액션으로 화면 이동 |
| :--------: |
| <Img src = "https://hackmd.io/_uploads/ryvtfQQB2.gif" width="600"/> |

| 쥬스 만들기 성공 |
| :--------: |
| <Img src = "https://hackmd.io/_uploads/H1BNQXmr2.gif" width="600"/> |

| 쥬스 만들기 실패 |
| :--------: |
| <Img src = "https://hackmd.io/_uploads/Sy3WN7mHh.gif" width="600"/> |

| 쥬스 만들기 화면에서 재고변경 화면으로 재고 데이터 전달 |
| :--------: |
| <Img src = "https://hackmd.io/_uploads/S1G4eJ9Hh.gif" width="600"/> |

| stepper를 이용한 재고 변경 |
| :--------: |
| <Img src = "https://hackmd.io/_uploads/BkCOlJcr2.gif" width="600"/> |

| 재고변경 화면에서 쥬스 만들기 화면으로 변경된 재고 데이터 전달 |
| :--------: |
| <Img src = "https://hackmd.io/_uploads/Hkhje19Hn.gif" width="600"/> |

</br>

<a id="5."></a>

## 5. 트러블 슈팅

### 모델과 원시값의 연관성 문제

**🔥문제점**
- `tag`나 `currentTitle`을 이용하여 `Juice`와 `Fruit` 모델에 쉽게 접근하기 위해 Int, String 원시값을 사용했습니다.
- 하지만 `tag`나 `currentTitle`은 View의 정보이기 때문에 모델이 이를 원시값으로 가지고 있는 것은 연관성을 찾기 어려웠습니다.

<details>
<summary>본문 코드 내용</summary>

**Fruit 코드**
    
```swift
enum Fruit: Int, CaseIterable {
    case strawberry
    case banana
    case pineapple
    case kiwi
    case mango
}
```
    
**Juice 코드**
    
```swift
enum Juice: String {
    case strawberryJuice = "딸기쥬스 주문"
    case bananaJuice = "바나나쥬스 주문"
    case pineappleJuice = "파인애플쥬스 주문"
    case kiwiJuice = "키위쥬스 주문"
    case mangoJuice = "망고쥬스 주문"
    case strawberryBananaJuice = "딸바쥬스 주문"
    case mangoKiwiJuice = "망키쥬스 주문"
    
    // ...
}
```

</details>

</br>

**🧯해결방안**
- Model에 원시값으로 접근하기 보단 ViewController에서 `tag`와 `currentTitle`로 분기처리하였습니다.


<details>
<summary>본문 코드 내용</summary>

**changeStockStepper() 코드**
```swift
@IBAction private func changeStockStepper(_ sender: UIStepper) {
    let amount = Int(sender.value)
        
    switch sender.tag {
    case 0:
        fruitStore.changeStock(amount, to: .strawberry)
    case 1:
        fruitStore.changeStock(amount, to: .banana)
    case 2:
        fruitStore.changeStock(amount, to: .pineapple)
    case 3:
        fruitStore.changeStock(amount, to: .kiwi)
    case 4:
        fruitStore.changeStock(amount, to: .mango)
    default:
        return
    }
        
    // ...
}
```
    
**tapOrderJuiceButton() 코드**
    
```swift
@IBAction private func tapOrderJuiceButton(_ sender: UIButton) {
    guard let title = sender.currentTitle else {
        print("버튼이 설정되지 않았습니다.")
        return
    }
        
    switch title {
    case "딸기쥬스 주문":
        orderJuice(.strawberryJuice)
    case "바나나쥬스 주문":
        orderJuice(.bananaJuice)
    case "파인애플쥬스 주문":
        orderJuice(.pineappleJuice)
    case "키위쥬스 주문":
        orderJuice(.kiwiJuice)
    case "망고쥬스 주문":
        orderJuice(.mangoJuice)
    case "딸바쥬스 주문":
        orderJuice(.strawberryBananaJuice)
    case "망키쥬스 주문":
        orderJuice(.mangoKiwiJuice)
    default:
        break
    }
}
```
    
</details>

</br>

### Singleton의 문제점

**🔥문제점**

- 어느 클래스에서든 하나의 인스턴스에 접근하는 것이기 때문에 의존성과 결합도가 높아져 개방폐쇄 원칙(OCP)에 위배되고 추후 유지보수 측면에서도 복잡해질 수 있습니다.
- 멀티 스레드 환경에서 객체가 중복생성될 우려가 있어 적시적소에 동기화 처리를 해주어야 하는 번거로움이 발생합니다.

<details>
<summary>본문 코드 내용</summary>

**FruitStore Singleton코드**

```swift
class FruitStore {
    static let shared = FruitStore()
    
    // ...
    private init() { }
    
    // ...
}
```
    
**JuiceMaker 코드**

```swift
struct JuiceMaker {
    let fruitStore = FruitStore.shared

    // ...
}
```
    
**ChangeStockViewController 코드**

```swift
class ChangeStockViewController: UIViewController {
    // ...
    private var fruitStore = FruitStore.shared

    // ...
}
```

</details>

</br>

**🧯해결방안**

- delegate를 이용하여 viewController 간 데이터 전달

- `ChangeStockDelegate` 프로토콜에 재고를 변경하는 기능을 가진 `changeStock` 메서드를 선언하고 `ChangeStockViewController`에 delegate, 즉 대리자를 생성 `delegate?.changeStock()`으로 접근하여 재고 데이터를 넘겨주었습니다.
- 이후 `JuiceMakerViewController`가 `ChangeStockDelegate`를 채택하고 `ChangeStockViewController.Delegate = self`로 설정하여 재고 데이터가 있는 `ChangeStock()`에 접근 및 세부 구현을 하여 데이터를 받아올 수 있도록 구현하였습니다. 

<details>
<summary>본문 코드 내용</summary>

**ChangeStockViewController 내 Delegate 코드**
    
```swift
final class ChangeStockViewController: UIViewController {
    // ...
    var fruitStore = FruitStore()
    var delegate: ChangeStockDelegate?
    
    // ...
    @IBAction private func tapCloseButton(_ sender: UIBarButtonItem) {
        self.delegate?.changeStock(fruitStore: fruitStore)
        self.navigationController?.popViewController(animated: true)
    }
    
    // ...
}   
```
    
**ChangeStockDelegate 채택 코드**

```swift
extension JuiceMakerViewController: ChangeStockDelegate {
    func changeStock(fruitStore: FruitStore) {
        self.juiceMaker.fruitStore = fruitStore
        setText()
    }
}
```
    
</details>

---

</br>

<a id="6."></a>

## 6. 참고 링크

- [🍎 Apple-tag](https://developer.apple.com/documentation/uikit/uiview/1622493-tag)
- [🍎 Apple-UIStepper](https://developer.apple.com/documentation/uikit/uistepper)
- [📚 Swift-protocols](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/protocols/)
- [📚 Swift-extensions](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/extensions)
- [🗒️ blog-delegate](https://velog.io/@kerri/iOS-Swift-Delegate%EB%A1%9C-ViewController-%EA%B0%84%EC%97%90-data-%EC%A0%84%EB%8B%AC%ED%95%98%EA%B8%B0-modal-dismiss-%EA%B5%AC%ED%98%84%ED%95%98%EA%B8%B0)
- [🗒️ blog-NotificationCenter](https://silver-g-0114.tistory.com/106)
- [🗒️ blog-Singleton](https://didu-story.tistory.com/405)

---

</br>

<a id="7."></a>

## 7. 팀 회고

### 👏🏻 우리팀이 잘한 점

- 처음 팀 배정 됐을 때부터 각자의 의견을 적극적으로 서로에게 공유하며 프로젝트에 방향성에 대해 충분히 논의를 해온 덕분에 큰 의견 차이 없이 매끄럽게 팀활동을 이어올 수 있었던 것 같습니다.
- 그라운드룰에 맞게 팀프로젝트를 잘 수행하였습니다.

### 👊🏻 우리팀이 개선할 점

- 코드의 확장성 재사용성에 대해 고민하는 시간이 부족했던 것 같습니다.

</br>

### 👍 서로에게 좋았던 점 피드백

### Dear. Erick

```
- 저와 달리 에릭이 ios개발 경험이 있으셔서 함께 프로젝트를 하면서 배운 점도 많았고 저도 그만큼 부족함을 많이 느겼던 것 같습니다. 앞으로 남은 기간동안 팀에 좋은 결과를 가져다 주기 위해 저의 부족함을 메꿔나가겠습니다.
```

### Dear. JusBug

```
- 제가 부족했던 에러처리와 do-catch문 작성 등에 대해 잘 알려주셨습니다.
- 매일 온화하게 대해주시고 제 의견도 잘 수용해주셨습니다.
```

</br>

### :pray: 서로에게 아쉬웠던 점 피드백

### Dear. Erick

```
- 함께 순서도를 작성하면서 각자의 코드 구성의 방향성을 제시하였고 처음엔 제가 제안했던 방향으로 딕셔너리로 과일과 재고를 관리하기로 했으나 에릭은 해당 Key, Value 값에 접근하기가 번거로워져 사용자 정의 타입으로 전환하는 것을 권유하였습니다. 하지만 Som은 유지보수성과 확장성 측면에서 전자로 관리하는 게 좋다고 말씀하셔서 다시 코드를 수정하는 일이 있었습니다. 앞으로는 Som의 리뷰대로 지적해 준 내용을 준수하며 효율적으로 시간을 관리하면서 팀에게 더욱 좋은 영향을 줄 거 같습니다.
```

### Dear. JusBug
```
- 생각하는 시간이 기셔서, 코드 구현 방향에 대해 짧게 생각 정리를 하시면 좋을 것 같습니다.
```

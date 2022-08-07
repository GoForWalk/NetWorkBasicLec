//
//  LocationViewController.swift
//  NetWorkBasicLec
//
//  Created by sae hun chung on 2022/07/29.
//

import UIKit

class LocationViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    // Notification 1.
    let notificationCenter = UNUserNotificationCenter.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestAuthorization()
        
        // custom Font
        // 프로젝트 내 모든 폰트 확인하는 코드
        for family in UIFont.familyNames {
            print("===============\(family)===============")
            
            for name in UIFont.fontNames(forFamilyName: family) {
                print(name)
            }
        }
    }

    @IBAction func localNotificationButtonTapped(_ sender: UIButton) {
        sendNotification()
    }
    
    @IBAction func downloadImage(_ sender: UIButton) {
    
        print("1", Thread.isMainThread)
        // 동시에 여러 작업이 가능하게 해줘!
        DispatchQueue.global(qos: .default).async { [weak self] in
            
            print("2", Thread.isMainThread)
            let url = "https://apod.nasa.gov/apod/image/2208/M13_final2_sinfirma.jpg"
            
            let data = try! Data(contentsOf: URL(string: url)!)
            
            let image = UIImage(data: data)

            DispatchQueue.main.async {
                print("3", Thread.isMainThread)
                self?.imageView.image = image
            }
        }
        // kingfisher 안쓰고 이미지 로드 받는 방법
    }
    
    
    
    
    // Notification 2. 권한 요청
    func requestAuthorization() {
        
        let authorizationOptions = UNAuthorizationOptions(arrayLiteral: .alert , .badge, .sound)
        // .criticalAlert : 긴급 알람
        
        notificationCenter.requestAuthorization(options: authorizationOptions) { success, error in
            
            if success {
                // 사용자가 허용했을 경우 사용하는 코드

            }
        }
    }//: requestAuthorization

    // Notification 3. 권한 허용한 사용자에게 알림 요청(언제?, 어떤 컨텐츠?)
    // iOS 시스템에서 알림을 담당 -> 알림을 등록하는 코드가 필요하다.
    func sendNotification() {
        
        // notification content 구성
        let notificationContent = UNMutableNotificationContent()
        
        notificationContent.title = "다마고치를 키워보세요"
        notificationContent.body = "저는 따끔따끔 다마고치입니다. 배고파요 ㅠㅠ"
        notificationContent.subtitle = "subtitle"
        notificationContent.badge = 40 // Badge에 40이라고 뜬다!
        
        // notification trigger 설정
        // 1. 시간 간격, 2. 캘린더, 3. 위치에 따라 설정 가능

        // 1. 시간 간격으로 알람 설정
        // 시간 간격일 경우 반복할 경우, timeInterval 60 이상
         let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        
        // 2. 캘린더로 알람 설정 > DateComponent 인스턴스에서 시간 설정
        var dateComponent = DateComponents()
        dateComponent.minute = 15
        dateComponent.hour = 10
        
//        let notificationTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
        
        // 알림 요청
        // identifier:
        // 만약 알림 관리를 할 필요 X -> 알림 클릭하면 앱을 켜주는 정도
        // 만약 알림 관리를 할 필요 O -> +1, 고유이름, 규칙 등
        let request = UNNotificationRequest(identifier: "\(Date())", // identifier가 일정하면 하나의 스택에 뭉쳐져서 올라간다. 다르게 만들면 알림의 스택이 계속 쌓인다.
                                            content: notificationContent,
                                            trigger: notificationTrigger
        )
        
        // Notification Control
        /*
         - 권한 허용 해야만 알림이 온다.
         - 권한 허용 문구 시스템적으로 최초 한번만 뜬다.
         - 하용 안된 경우, 애플 설정으로 직접 유도하는 코드를 구성해야 한다.
         
         - 기본적으로 알림은 포그라운드에서 수신되지 않는다.
         - 로컬 알림에서는 60초 이상 반복 가능 / 개수 제한 64개 / 커스텀 사운드(max: 30초)
         
         1. 뱃지 제거
         2. 노티 제거
            - 노티의 유효기간은? 한달정도
         3. 포그라운드 수신 > UNUserNotificationCenterDelegate에서 해결 가능
         
         +알파
            - 노티는 앱 실행이 기본인데, 특정 노티를 클릭할 때 특정 화면으로 가고 싶다면?
            - 포그라운드 수신 > 특정 화면(조건)에는 수신을 안 받는 경우??
            - iOS15+ 집중모드 등 5~6 우선순위 존재 -> 긴급한 경우 무조건 푸쉬를 보낼수 있다.
         */
        
        // 1. 뱃지 제거 -> 앱이 활성화 될 때 -> SceneDelegate
        // 2. 노티 제거 -> 앱이 처음으로 올라올 때 -> AppDelegate
 
        notificationCenter.add(request)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(#function)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(#function)
    }
    
    
}//: LocationViewController

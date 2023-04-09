//
//  ViewController.swift
//  ChatBotMission-alone
//
//  Created by 김라영 on 2023/02/02.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var userInput: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    
    //tableView에 들어갈 데이터들
    var msgList: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        sendBtn.layer.cornerRadius = 10
        
        //테이블 뷰에 사용할 셀들을 등록해준다 -> 여기서는 봇이 보낸 메시지 셀과 내가 보낸 메시지 셀 두가지로 나눌 수 있다
        myTableView.register(BotCell.uiNib, forCellReuseIdentifier: BotCell.reuseIdentifier)
        myTableView.register(MeCell.uiNib, forCellReuseIdentifier: MeCell.reuseIdentifier)
        
        //테이블 뷰의 dataSource를 메모리에 올라간 viewController로 정해준다
        self.myTableView.dataSource = self
        //버튼에 이벤트 달아주기
        sendBtn.addTarget(self, action: #selector(sendBtnClicked(_:)), for: .touchUpInside)
    }

    //어떤 이벤트인지 정해주는 부분
    @objc func sendBtnClicked(_ sender: UIButton) {
        print(#fileID, #function, #line, "- ")
        //textField에 쓰여진 데이터를 가지고 온다
        guard let content = userInput.text else { return }
        
        //새로운 데이터를 만들어준다 -> 새로운 데이터의 자료형은 struct로 정의해준 Message라는 자료형이다
        //실제 데이터를 만들어서 메모리에 올려준다
        let newData = Message(content: content, cellType: .me)
        //msgList에 만들어놓은 데이터를 넣어준다
        self.msgList.append(newData)
        //tableview를 새로고침해준다 -> 사실 여기서보다는 combine을 통해서 데이터가 업데이트 완료되면 그때 신호를 줘서 tableview를 새로고침해주는게 낫지 않을까?
//        self.myTableView.reloadData()

        requestSimsimmiApi(content)
        
    }

    //심심이한테 메시지 보내고 받아오기(API호출 메서드 부분)
    func requestSimsimmiApi(_ input: String) {
        print(#fileID, #function, #line, "- <#comment#>")
        //api에 보낼 데이터 -> 위에 Curl이랑 데이터 형태를 맞춰준다
        //[key : value]형태의 딕셔너리 형태로 데이터를 넣어준다
        let parameters: [String: String] = [
            "utext": input,
            "lang" : "ko"
        ]
        
        //headers에 필요한 데이터를 넣어주는 부분
        let headers: HTTPHeaders = [
            "x-api-key": "i18KWP7qzjqw764XKuyb5It7HmW0ratdmczHkbZn",
            "Content-Type": "application/json" //우리는 Content를 요청하니까 Content-Type으로 넣어주면 된다
        ]
        
        //url request를 만들어주는 부분
        AF.request("https://wsapi.simsimi.com/190410/talk",
                   method: .post, //post방식으로 데이터 요청
                   parameters: parameters, //request보낼때 같이 보낼 요청
                   //encoder: JSONParameterEncoder는 JSON으로 인코딩해준다는 것을 의미한다
                   encoder: JSONParameterEncoder.default,
                   headers: headers
                   )
        //decoding을 해주지 않으면 responseData에서 data가 그냥 바이트로 들어온다 -> 그러므로 Swift가 JSON데이터를 알아볼 수 있도록 swift로 디코딩이 필요하다
        //그리고 디코딩을 하기 위해서는 JSON에서 변경되야 하는 데이터가 어떻게 되야 하는지 알려줘야 한다 -> 그리고 BotResponse이다
        //즉, responseDecodable을 이용해서 JSON형태의 데이터를 BotResponse의 형태로 데이터를 변경해준다
        //그리고 of: BotResponse.self의 의미는 -> 자기자신의 타입을 가지고 와서 BotResponse 자료형으로 데이터를 파싱하겠다
        .responseDecodable(of: BotResponse.self,
                           //completionHandler는 클로져로 (AFDataResonse<T> -> Void)형태 함수의 정의(값)이 들어간다
                           //값이 (response: DataResponse<Decodable, AFError>) -> Decodable에 Decodable자료형이 들어가진다
                           completionHandler: { (response: DataResponse<BotResponse, AFError>) in
            debugPrint(response)
            switch response.result {
                case .failure(let afErr):
                    print(#fileID, #function, #line, "- failure: \(afErr)")
                case .success(let data):
                    print(#fileID, #function, #line, "- success: \(data)")
                    guard let botMessage = data.atext else { return }
                    let message = Message(content: botMessage, cellType: .bot)
                    self.msgList.append(message)
                    DispatchQueue.main.async {
                        self.myTableView.reloadData()
                        //메시지를 보냈으면 textField를 초기화해준다
                        self.userInput.text = ""
                    }
                }
            })
        //API를 request하면 즉, API를 보냈으면 response부분 즉, 받는 부분이 필요하다
        //response의 가장 기본적인 형태는 responseData이다 -> 데이터를 받아올 수 있다
        //responseDecodable은 내가 굳이 decoding하지 않아도 decoding이 된 형태로 보낸다
//        .responseData { response in
//            switch response.result {
//            case .failure(let afErr):
//                print(#fileID, #function, #line, "- failure: \(afErr)")
//            case .success(let data):
//                print(#fileID, #function, #line, "- success: \(data)")
//            }
//        }
    }
}

extension ViewController: UITableViewDataSource {
    //몇개의 section을 만들어줄건지 정해준다
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return msgList.count
    }
    
    //어떤 셀을 보여줄 건지 정해주는 부분
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //어떤 셀을 보여줄 건지 정해준다 -> 현재 indexPath의 row를 통해서 msgList의 데이터를 가지고 온다
        let cellData: Message = msgList[indexPath.row]
        print(#fileID, #function, #line, "- msgList: \(msgList)")
        //msgList의 데이터 타입은 Message로 Message는 타입을 변수로 가지고 있다. 이 타입에 따라서 어떤 cell을 보여줄 건지 정해준다
        switch cellData.cellType {
        case .me:
            //재사용할 셀을 가지고 온다
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MeCell.reuseIdentifier, for: indexPath) as? MeCell else { return UITableViewCell() }
            
            cell.content.text = cellData.content
            
            return cell
        case .bot:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BotCell.reuseIdentifier, for: indexPath) as? BotCell else { return UITableViewCell() }
            cell.content.text = cellData.content
            
            return cell
        }
        
    }
}

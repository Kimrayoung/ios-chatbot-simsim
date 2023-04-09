//
//  Response.swift
//  ChatBotMission-alone
//
//  Created by 김라영 on 2023/02/02.
//

import Foundation

// MARK: - BotResponse
//말그대로 여기가 응답의 swift의 형식
struct BotResponse: Codable {
    let status: Int?
    let statusMessage, atext, lang: String?
    let request: Request?
}

// MARK: - Request
//요청을 보낼때의 데이터형식
struct Request: Codable {
    let utext, lang: String?
}

//셀 데이터 정의
struct Message {
    enum MsgType {
        case me
        case bot
    }
    //메시지의 내용
    let content: String
    //어떤 타입의 셀인지 여기서 정의해줌
    //enum을 통해서 정해준다
    let cellType: MsgType 
}

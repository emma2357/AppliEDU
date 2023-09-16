//
//  ChatGPT.swift
//  AppliEDU
//
//  Created by Emma Capaldi on 8/11/23.
//

import SwiftUI
import Alamofire
import Combine

//all information related to chatGPT

// Struct for organizing chat message information
struct ChatMessage {
    let id: String
    let content: String
    let createdAt: Date
    let sender: MessageSender
}

// Track who sends message
enum MessageSender {
    case me
    case chatGPT
}

// Information for openAI
struct OpenAICompletionsBody: Encodable {
    let model: String
    let prompt: String
    let temperature: Float?
    let max_tokens: Int 
}

// Struct of responses
struct OpenAIResponse: Decodable {
    let id: String
    let choices: [OpenAIResponseChoice]
}
struct OpenAIResponseChoice: Decodable {
    let text: String
}

class OpenAIService {
    let baseUrl = "https://api.openai.com/v1/completions"
    var isLoading: Bool = false
    
    // send a message to chatGPT
    func sendMessage(message: String) -> AnyPublisher<OpenAIResponse, Error> {
        let body = OpenAICompletionsBody(model: "text-davinci-003", prompt: message, temperature: 0.6, max_tokens: 1000)
        
        // use your own key here to communicate with chat gpt (key removed for privacy)
        let headers: HTTPHeaders = [
            "Authorization" : "INSERT UNIQUE KEY HERE"
        ] 
        
        return Future { [weak self] promise in
            guard let self = self else {return}
            AF.request(self.baseUrl, method: .post, parameters: body, encoder: .json, headers: headers).responseDecodable(of: OpenAIResponse.self) { response in
                switch response.result {
                    case .success(let result): promise(.success(result))
                        
                    case.failure(let error): promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

struct ChatGPT_Previews: PreviewProvider {
    static var previews: some View {
        ChatGPT()
    }
}

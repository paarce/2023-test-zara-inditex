//
//  URLSessionNetworkClient.swift
//  RickyMortyInditex
//
//  Created by Augusto Cordero Perez on 14/3/23.
//

import Foundation

protocol NetworkClient {
    func perform<Output: Decodable>(for request: URLRequest) async throws -> Output
}

struct ErrorResponse: Codable {
    let code: String?
    let message: String?
}

class URLSessionNetworkClient: NetworkClient {

    func perform<Output: Decodable>(for request: URLRequest) async throws -> Output {

        print(request)

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpUrlResponse = response as? HTTPURLResponse, httpUrlResponse.statusCode == 200 else {
            throw handleError(data: data, response: response)
        }

        do {
            let decodedResponseData = try JSONDecoder().decode(Output.self, from: data)
            return decodedResponseData
        } catch (let error) {
            if let error = error as? APIError {
                throw error
            } else if let decoding = error as? DecodingError {
                throw APIError.handleDecoding(error: decoding)
            } else {
                throw APIError.unknown
            }
        }
    }

    private func handleError(data: Data, response: URLResponse) -> Error {

        let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data)
        if let httpUrlResponse = response as? HTTPURLResponse {
            return APIError.handleResponse(
                code: httpUrlResponse.statusCode,
                message: errorResponse?.message
            )
        }
        return APIError.unknown
    }
}

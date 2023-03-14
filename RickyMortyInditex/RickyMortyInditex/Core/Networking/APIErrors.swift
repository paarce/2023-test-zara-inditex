//
//  APIErrors.swift
//  RickyMortyInditex
//
//  Created by Augusto Cordero Perez on 14/3/23.
//

import Foundation

enum APIError: LocalizedError {
    case parseError(keys: [CodingKey], description: String)
    case unknown
    case notFound
    case serverError
    case methodNotAllowed
    case forbidden
    case badRequest

    public var errorDescription: String? {
        switch self {
        case .parseError:
            return "CHARACTER_API_ERROR_PARSE".localized
        case .unknown:
            return "CHARACTER_API_ERROR_UNKNOWN".localized
        case .badRequest:
            return "CHARACTER_API_ERROR_BAD_REQUEST".localized
        case .notFound:
            return "CHARACTER_API_ERROR_NOT_FOUND".localized
        case .serverError:
            return "CHARACTER_API_ERROR_SERVER_ERROR".localized
        case .methodNotAllowed:
            return "CHARACTER_API_ERROR_METHOD_NOT_ALLOWED".localized
        case .forbidden:
            return "CHARACTER_API_ERROR_FORBIDDEN".localized
        }
    }
}

extension APIError {

    static func handleDecoding(error: DecodingError) -> APIError {
        switch error {
        case .keyNotFound(let codingPath, let context):
            return APIError.parseError(keys: [codingPath], description: context.debugDescription)
        case .dataCorrupted(let context):
            return APIError.parseError(keys: context.codingPath, description: context.debugDescription)
        default:
            return APIError.parseError(keys: [], description: error.localizedDescription)
        }
    }

    static func handleResponse(code: Int, message: String?) -> APIError {
        switch code {
        case 403:
            return APIError.forbidden
        case 405:
            return APIError.methodNotAllowed
        case 404:
            return APIError.notFound
        case 500...599:
            return APIError.serverError
        default:
            return APIError.unknown
        }
    }
}

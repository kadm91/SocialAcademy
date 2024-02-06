//
//  Firestore+Extensions.swift
//  SocialAcademy
//
//  Created by Kevin Martinez on 2/6/24.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

//MARK: - DocumentReference extension

extension DocumentReference {
    func setData<T: Encodable>(from value: T) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            // Method only throws if there’s an encoding error, which indicates a problem with our model.
            // We handled this with a force try, while all other errors are passed to the completion handler.
            try! setData(from: value) { error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                continuation.resume()
            }
        }
    }
}

//MARK: - Firestore Query type extension

extension Query {
    func getDocuments<T: Decodable> (as type: T.Type) async throws -> [T] {
        let snapshot =  try await getDocuments()
        return snapshot.documents.compactMap { document in
            try! document.data(as: type)
        }
    }
}

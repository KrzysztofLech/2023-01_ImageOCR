//  TextRecognitionService.swift
//  Created by Krzysztof Lech on 14/01/2023.

import UIKit
import Vision

protocol TextRecognitionServiceProtocol {
    func recogniseTextFromImage(_ image: UIImage, completion: @escaping (String?) -> Void)
}

class TextRecognitionService: TextRecognitionServiceProtocol {
    func recogniseTextFromImage(_ image: UIImage, completion: @escaping (String?) -> Void) {
        guard let cgImage = image.cgImage else {
            completion(nil)
            return
        }

        let queue = DispatchQueue(label: "textRecognitionQueue", qos: .userInitiated)
        queue.async {
            let recognizeTextRequest = VNRecognizeTextRequest { request, error in
                if let error {
                    print("Recognition error:", error.localizedDescription)
                    completion(nil)
                    return
                }

                guard let observations = request.results as? [VNRecognizedTextObservation] else {
                    completion(nil)
                    return
                }

                var finalRecognizedText = ""

                observations.forEach { observation in
                    guard let recognizedText = observation.topCandidates(1).first else { return }

                    if !finalRecognizedText.isEmpty {
                        finalRecognizedText += "\n"
                    }
                    finalRecognizedText += recognizedText.string
                }

                completion(finalRecognizedText)
            }
            recognizeTextRequest.recognitionLevel = .accurate
            recognizeTextRequest.usesLanguageCorrection = true

            do {
                let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
                try requestHandler.perform([recognizeTextRequest])
            } catch {
                print("Recognition error:", error.localizedDescription)
                completion(nil)
            }
        }
    }
}

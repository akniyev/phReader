//
//  TextGeometryViewer.swift
//  PhReader
//
// Created by Gasan Akniev on 09.12.2020.
//

import UIKit

final class TextGeometryViewer: UITextView {
    private let verticalOffset: CGFloat = 10
    private var labels: [Int:UILabel] = [:]

    override var text: String! {
        get {
            super.text
        }
        set {
            super.text = newValue
            computeWords()
        }
    }

    public private(set) var wordRects: [CGRect] = []
    public private(set) var words: [String] = []

    private func computeWords() {
        guard let text = text else {
            wordRects = []
            words = []
            return
        }

        let range = NSRange(location: 0, length: text.utf16.count)
        let regex = try! NSRegularExpression(pattern: "[a-zA-Z]+")

        let matches = regex.matches(in: text, range: range)
        let wordRanges = matches.map { $0.range }
        let words = wordRanges.map { range -> String in
            let start = text.index(text.startIndex, offsetBy: range.location)
            let end = text.index(start, offsetBy: range.length)
            return String(text[start..<end])
        }
        let wordRects = wordRanges.map { range in
            layoutManager.boundingRect(forGlyphRange: range, in: textContainer).offsetBy(dx: 0, dy: verticalOffset)
        }

        self.words = words
        self.wordRects = wordRects
    }

    let shapeLayer = CAShapeLayer()

    // MARK: Initialization

    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not implemented")
    }

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setUpUI()
    }

    // MARK: UI Setup

    private func setUpUI() {
        setUpParameters()
        setUpGestureRecognizer()
        setUpShapeLayer()
    }

    private func setUpParameters() {
        isEditable = false
        isScrollEnabled = true
        isSelectable = false
        textColor = .black
        backgroundColor = .white
    }

    private func setUpGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(processTap(_:)))
        addGestureRecognizer(tap)
    }

    @objc private func processTap(_ tap: UITapGestureRecognizer) {
        let location = tap.location(in: self)

        for i in 0..<wordRects.count {
            let rect = wordRects[i]
            let word = words[i]
            if rect.contains(location) {
                shapeLayer.path = UIBezierPath(roundedRect: rect.expanded(by: 1), cornerRadius: 2).cgPath
                if let label = labels[i] {
                    labels[i] = nil
                    DispatchQueue.main.async {
                        label.removeFromSuperview()
                    }
                } else {
                    WordTranslator.shared.transcribe(word: word) { [weak self] transcription in
                        guard let transcription = transcription else { return }
                        DispatchQueue.main.async {
                            let label = UILabel()
                            label.font = UIFont.systemFont(ofSize: 12)
                            label.textColor = .blue
                            label.text = "/\(transcription)/"
                            self?.labels[i] = label
                            self?.addSubview(label)
                            label.snp.makeConstraints { make in
                                make.center.equalTo(CGPoint(x: rect.minX + rect.width / 2, y: rect.minY))
                            }
                        }
                    }
                }
            }
        }
    }

    private func setUpShapeLayer() {
        layer.addSublayer(shapeLayer)
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.2).cgColor
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let origin = CGPoint.zero
        shapeLayer.frame = CGRect(origin: origin, size: bounds.size)
        computeWords()
    }
}

extension CGRect {
    func expanded(by diff: CGFloat) -> CGRect {
        CGRect(x: origin.x - diff, y: origin.y - diff, width: width + 2 * diff, height: height + 2 * diff)
    }
}

final class WordTranslator {
    static let shared = WordTranslator()
    private var dictionary = [String:String]()

    func transcribe(word: String, completion: @escaping (String?) -> Void) {
        if let transcription = dictionary[word] {
            completion(transcription)
            return
        }

        let parameters = "{\"service\":\"\",\"method\":\"transcribe\",\"id\":1,\"params\":[\"\(word)\",\"American\",false]}"
        let postData = parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: "https://www.phonetizer.com/phonetizer/default/call/jsonrpc?nocache=1601188600111")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            let result = String(data: data, encoding: .utf8)!

            let pattern1 = "<span class=\\\"transcr\\\">/"
            let pattern2 = "/</span></p><br/>\\n</body>\\n</html>"

            if let range1 = result.range(of: pattern1), let range2 = result.range(of: pattern2) {
                let transcription = String(result[range1.upperBound..<range2.lowerBound]).decodingUnicodeCharacters
                completion(transcription)
                self?.dictionary[word] = transcription
            } else {
                completion(nil)
            }
        }

        task.resume()
    }
}

extension String {
    var decodingUnicodeCharacters: String { applyingTransform(.init("Hex-Any"), reverse: false) ?? "" }
}

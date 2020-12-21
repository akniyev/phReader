//
//  TextGeometryViewer.swift
//  PhReader
//
// Created by Gasan Akniev on 09.12.2020.
//

import UIKit

final class TextGeometryViewer: UITextView {
    private let verticalOffset: CGFloat = 10

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
        backgroundColor = .lightGray
    }

    private func setUpGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(processTap(_:)))
        addGestureRecognizer(tap)
    }

    @objc private func processTap(_ tap: UITapGestureRecognizer) {
        let location = tap.location(in: self)

        for i in 0..<wordRects.count {
            let rect = wordRects[i]
            if rect.contains(location) {
                let index = text.index(text.startIndex, offsetBy: i)
                shapeLayer.path = UIBezierPath(roundedRect: rect, cornerRadius: 2).cgPath
            }
        }
    }

    private func setUpShapeLayer() {
        layer.addSublayer(shapeLayer)
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = UIColor.red.cgColor
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let origin = CGPoint.zero
        shapeLayer.frame = CGRect(origin: origin, size: bounds.size)
        computeWords()
    }
}

//
//  CommonExtension.swift
//  
//
//  Created by 엄기철 on 2023/03/19.
//

import Foundation
import UIKit


public extension Float {
    func roundToDecimal(_ places: Int = 1) -> Float {
        let multiplier = Float(pow(10.0, Double(places)))
        return Darwin.round(self * multiplier) / multiplier
    }
}

public extension Array {
    subscript (safe index: Int) -> Element? {
        guard (0..<count) ~= index else {
            return nil
        }
        return self[index]
    }
}

public extension Array where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}


public extension NSObject {
    static var className: String {
        return String(describing: self)
    }
}


public extension Int {
    func convertToRatingFormatter() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        if self < 1000 {
            return numberFormatter.string(for: self) ?? ""
        }
        
        var nonFractionalFormat: String = ""
        var fractionalFormat: String = ""
        var divideNumber: Int = 0
        
        if self > 100_000_000 {
            nonFractionalFormat = "%1$@억"
            fractionalFormat = "%1$@.%2$@억"
            divideNumber = 100_000_000
        } else if self > 10_000 {
            nonFractionalFormat = "%1$@만"
            fractionalFormat = "%1$@.%2$@만"
            divideNumber = 10_000
        } else {
            nonFractionalFormat = "%1$@천"
            fractionalFormat = "%1$@.%2$@천"
            divideNumber = 1000
        }
        
        let integerPart = self / divideNumber
        let integerPartDecimalFormat = numberFormatter.string(for: integerPart) ?? ""
        let fractionalPart = self % divideNumber / (divideNumber / 10)
        let fractionalParFormat = "\(fractionalPart)"
        
        if fractionalPart == 0 || integerPart > 100 {
            return String(format: nonFractionalFormat, integerPartDecimalFormat)
        } else {
            return String(format: fractionalFormat, integerPartDecimalFormat, fractionalParFormat)
        }
    }
}
    
    
public extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach {
            addArrangedSubview($0)
        }
    }
}

public extension String {
    func stringToDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssz"
        let date = dateFormatter.date(from: self)
        return date ?? Date()
    }
}

public extension Date {
    func dateToString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    func convertToReleaseGapFormatter(fromToday: Date, days: Int) -> String? {
        var gap: String?
        let calendar = Calendar.current
        let dateGapComponents = calendar.dateComponents([.year, .month, .day, .hour], from: self, to: fromToday)
        
        if case let (y?, m?, d?, h?) = (dateGapComponents.year, dateGapComponents.month, dateGapComponents.day, dateGapComponents.hour) {
            switch days {
                case 0:
                    gap = "\(h)시간 전"
                case 1..<7:
                    gap = "\(d)일 전"
                case 7..<14:
                    gap = "1주 전"
                case 14..<21:
                    gap = "2주 전"
                case 21..<28:
                    gap = "3주 전"
                case 28..<35:
                    gap = "4주 전"
                case 35..<365:
                    gap = "\(m)달 전"
                case 365...Int.max:
                    gap = "\(y)년 전"
                default:
                    break
            }
        }
        return gap
    }
}

public extension Optional {
    var isNil: Bool {
        switch self {
            case .some: return false
            case .none: return true
        }
    }
    
    var isNotNil: Bool {
        !isNil
    }
}

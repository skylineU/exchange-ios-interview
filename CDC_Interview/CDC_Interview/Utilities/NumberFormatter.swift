import Foundation

struct CryptoFormatter {

    /// Formats a cryptocurrency value to a fixed number of fractional digits (e.g., 8 for BTC)
    static func format(value: Decimal?, decimalPlaces: Int = 8, locale: Locale = .current) -> String {
        guard let value else {
            return "--"
        }

        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = decimalPlaces

        let nsDecimalValue = NSDecimalNumber(decimal: value)
        return formatter.string(from: nsDecimalValue) ?? "--"
    }

    /// Parses a string to a Decimal value
    static func parse(value: String, locale: Locale = .current) -> Decimal? {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.numberStyle = .decimal
        return formatter.number(from: value)?.decimalValue
    }
}

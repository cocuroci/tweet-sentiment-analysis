import Foundation

extension String {
    func maxLength(_ length: Int) -> String {
        let suffix = count > length ? "..." : ""
        return "\(String(prefix(length)))\(suffix)"
    }
}

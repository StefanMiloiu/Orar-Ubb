//MARK: - SharedGroupsViewModel
import SwiftUI

class SharedGroupsViewModel: ObservableObject {
    @Published var groups: [String] = []
}

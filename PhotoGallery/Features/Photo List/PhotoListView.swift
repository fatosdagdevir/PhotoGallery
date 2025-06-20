import SwiftUI

struct PhotoListView: View {
    @ObservedObject var viewModel: PhotoListViewModel
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    PhotoListView(
        viewModel: .init(navigator: Navigator())
    )
}

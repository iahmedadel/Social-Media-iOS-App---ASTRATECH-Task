//  AstraTech-SwiftUi
//
//  Created by Ahmed Adel on 23/05/2025.
import SwiftUI
struct HomeView: View {
    @StateObject private var showPostsViewModel = PostViewModel()
    @StateObject private var createPostViewModel = CreatePostViewModel()
    @StateObject private var postDetailViewModel = PostDeailViewModel()
    @State private var scale: CGFloat = 1.0
    @State private var navigateToCreatePost = false

    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundGradientView()
                MainContentView(
                    showPostsViewModel: showPostsViewModel,
                    createPostViewModel: createPostViewModel,
                    detailViewModel: postDetailViewModel,
                    scale: $scale,
                    navigateToCreatePost: $navigateToCreatePost
                )
                if  showPostsViewModel.isLoading {
                    LoadingView()
                }
            }
            .alert(isPresented: Binding<Bool>(
                get: { showPostsViewModel.errorMessage != nil },
                set: { if !$0 { showPostsViewModel.errorMessage = nil } }
            )) {
                Alert(
                    title: Text("Error"),
                    message: Text(showPostsViewModel.errorMessage ?? "An unknown error occurred"),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .preferredColorScheme(.dark)
        .tint(Color.white)
    }
    
}

struct BackgroundGradientView: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color(.systemGray6), Color(.systemBackground)]),
            startPoint: .top,
            endPoint: .bottom
        )
        .edgesIgnoringSafeArea(.all)
    }
}

   


struct PlusButtonView: View {
    @Binding var scale: CGFloat
    let action: () -> Void

    var body: some View {
        Button(action: {
            action()
            withAnimation(.spring()) {
                scale = 1.2
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring()) {
                    scale = 1.0
                }
            }
        }) {
            Image(systemName: "plus.circle.fill")
                .font(.title2)
                .foregroundStyle(.white)
                .scaleEffect(scale)
        }
    }
}
#Preview {
    HomeView()
}

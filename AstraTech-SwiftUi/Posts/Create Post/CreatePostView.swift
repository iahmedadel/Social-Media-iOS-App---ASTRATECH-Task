//  AstraTech-SwiftUi
//
//  Created by Ahmed Adel on 23/05/2025.
import SwiftUI

struct CreatePostView: View {
    @ObservedObject var viewModel: CreatePostViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var content = ""
    @State private var selectedImage: UIImage?
    @State private var isShowingImagePicker = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemBackground)
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 16) {
                        Button(action: {
                            isShowingImagePicker = true
                        }) {
                            ZStack {
                                if let image = selectedImage {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(height: 200)
                                        .clipShape(RoundedRectangle(cornerRadius: 16))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(Color.blue.opacity(0.5), lineWidth: 2)
                                        )
                                } else {
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.gray.opacity(0.2))
                                        .frame(height: 200)
                                        .overlay(
                                            Image(systemName: "camera.fill")
                                                .font(.system(size: 40))
                                                .foregroundStyle(.blue)
                                        )
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        TextField("Title", text: $title)
                            .font(.system(.title3, design: .rounded, weight: .medium))
                            .padding()
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                            .padding(.horizontal)
                        
                        ZStack(alignment: .topLeading) {
                            if content.isEmpty {
                                Text("Share your thoughts...")
                                    .font(.system(.body, design: .rounded))
                                    .foregroundStyle(.gray)
                                    .padding(.top, 12)
                                    .padding(.horizontal, 16)
                            }
                            
                            TextEditor(text: $content)
                                .font(.system(.body, design: .rounded))
                                .frame(minHeight: 150)
                                .padding(8)
                                .background(Color(.systemGray6))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                        }
                        .padding(.horizontal)
                        
                        Button(action: {
                            viewModel.createPost(title: title, content: content, image: selectedImage)
                        }) {
                            Text("Share Moment")
                                .font(.system(.headline, design: .rounded, weight: .semibold))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(title.isEmpty || content.isEmpty || selectedImage == nil  || viewModel.isLoading ? Color.gray.opacity(0.5) : Color.blue)
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .disabled(title.isEmpty || content.isEmpty || selectedImage == nil || viewModel.isLoading)
                        .padding(.horizontal)
                        .padding(.top, 8)
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("New Post")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.white, for: .navigationBar)
            
            
            .sheet(isPresented: $isShowingImagePicker) {
                ImagePicker(selectedImage: $selectedImage)
            }
            .overlay {
                if viewModel.isLoading {
                    LoadingView()
                }
            }
            .onChange(of: viewModel.postCreated) { newValue in
                if newValue {
                    dismiss()
                    viewModel.postCreated = false
                }
            }
        }
    }
}

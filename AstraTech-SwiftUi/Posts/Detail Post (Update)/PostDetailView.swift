//
//  PostDetailView.swift
//  AstraTech-SwiftUi
//
//  Created by Ahmed Adel on 23/05/2025.

import SwiftUI

struct PostDetailView: View {
    let post: Post
    @ObservedObject var viewModel: PostDeailViewModel
    
    @State private var title: String
    @State private var content: String
    @State private var isEditing = false
    @State private var showDeleteConfirmation = false
    @State private var selectedImage: UIImage?
    @State private var isShowingImagePicker = false
    @Environment(\.dismiss) var dismiss
    
    init(post: Post, viewModel: PostDeailViewModel) {
        self.post = post
        self.viewModel = viewModel
        _title = State(initialValue: post.title)
        _content = State(initialValue: post.content)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemBackground)
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        
                        if isEditing {
                            TextField("Title", text: $title)
                                .font(.system(.title2, design: .rounded, weight: .semibold))
                                .padding()
                                .background(Color(.systemGray6))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                        } else {
                            Text(post.title)
                                .font(.system(.title2, design: .rounded, weight: .semibold))
                                .foregroundStyle(.primary)
                        }
                        
                        if !isEditing {
                            HStack(spacing: 4) {
                                Image(systemName: "clock")
                                    .foregroundColor(.secondary)
                                Text(post.formattedDate)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        ZStack(alignment: .topTrailing) {
                            if isEditing {
                                if let selectedImage = selectedImage {
                                    Image(uiImage: selectedImage)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxWidth: .infinity)
                                        .clipShape(RoundedRectangle(cornerRadius: 16))
                                } else if !post.photo.isEmpty {
                                    AsyncImage(url: URL(string: post.photo)) { phase in
                                        if let image = phase.image {
                                            image
                                                .resizable()
                                                .scaledToFit()
                                                .frame(maxWidth: .infinity)
                                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                        } else if phase.error != nil {
                                            Image(systemName: "photo.fill")
                                                .font(.system(size: 60))
                                                .frame(maxWidth: .infinity, minHeight: 200)
                                                .background(Color.gray.opacity(0.2))
                                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                        } else {
                                            ProgressView()
                                                .frame(maxWidth: .infinity, minHeight: 200)
                                        }
                                    }
                                } else {
                                    Button(action: {
                                        isShowingImagePicker = true
                                    }) {
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(Color.gray.opacity(0.2))
                                            .frame(height: 200)
                                            .overlay(
                                                Image(systemName: "photo.fill")
                                                    .font(.system(size: 40))
                                                    .foregroundStyle(.blue)
                                            )
                                    }
                                }
                                
                                if !post.photo.isEmpty {
                                    Button(action: {
                                        isShowingImagePicker = true
                                    }) {
                                        Image(systemName: "pencil.circle.fill")
                                            .resizable()
                                            .frame(width: 32, height: 32)
                                            .foregroundStyle(.blue)
                                            .background(Circle().fill(Color.white))
                                            .padding(8)
                                    }
                                }
                            } else if !post.photo.isEmpty {
                                AsyncImage(url: URL(string: post.photo)) { phase in
                                    if let image = phase.image {
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(maxWidth: .infinity)
                                            .clipShape(RoundedRectangle(cornerRadius: 16))
                                    } else if phase.error != nil {
                                        Image(systemName: "photo.fill")
                                            .font(.system(size: 60))
                                            .frame(maxWidth: .infinity, minHeight: 200)
                                            .background(Color.gray.opacity(0.2))
                                            .clipShape(RoundedRectangle(cornerRadius: 16))
                                    } else {
                                        ProgressView()
                                            .frame(maxWidth: .infinity, minHeight: 200)
                                    }
                                }
                            }
                        }
                        
                        if isEditing {
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
                        } else {
                            Text(post.content)
                                .font(.system(.body, design: .rounded))
                                .foregroundStyle(.primary)
                        }
                        
                        if isEditing {
                            HStack(spacing: 12) {
                                Button(action: {
                                    isEditing = false
                                    selectedImage = nil
                                    title = post.title
                                    content = post.content
                                }) {
                                    Text("Cancel")
                                        .font(.system(.headline, design: .rounded, weight: .semibold))
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color(.systemGray5))
                                        .foregroundStyle(.primary)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                }
                                
                                Button(action: {
                                    let updatedPost = Post(
                                        id: post.id,
                                        title: title,
                                        content: content,
                                        photo: post.photo,
                                        createdAt: post.createdAt,
                                        updatedAt: post.updatedAt
                                    )
                                    viewModel.updatePost(updatedPost, image: selectedImage)
                                }) {
                                    Text("Save")
                                        .font(.system(.headline, design: .rounded, weight: .semibold))
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(title.isEmpty || content.isEmpty ? Color.gray.opacity(0.5) : Color.blue)
                                        .foregroundStyle(.white)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                }
                                .disabled(title.isEmpty || content.isEmpty)
                            }
                        } else {
                            HStack(spacing: 12) {
                                Button(action: {
                                    isEditing = true
                                }) {
                                    Text("Edit")
                                        .font(.system(.headline, design: .rounded, weight: .semibold))
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.blue)
                                        .foregroundStyle(.white)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                }
                                
                                Button(action: {
                                    showDeleteConfirmation = true
                                }) {
                                    Text("Delete")
                                        .font(.system(.headline, design: .rounded, weight: .semibold))
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.red.opacity(0.9))
                                        .foregroundStyle(.white)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Post Details")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $isShowingImagePicker) {
                ImagePicker(selectedImage: $selectedImage)
            }
            .alert(isPresented: $showDeleteConfirmation) {
                Alert(
                    title: Text("Delete Post"),
                    message: Text("Are you sure you want to delete this moment?"),
                    primaryButton: .destructive(Text("Delete")) {
                        viewModel.deletePost(post)
                    },
                    secondaryButton: .cancel()
                )
            }
            .overlay {
                if viewModel.isLoading {
                    LoadingView()
                }
            }
            .onChange(of: viewModel.shouldDismiss) { newValue in
                if newValue {
                    dismiss()
                }
            }
        }
    }
}
